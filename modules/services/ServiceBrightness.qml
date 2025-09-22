pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<var> ddcMonitors: []
    readonly property list<BrightnessMonitor> monitors: Quickshell.screens.map(screen => monitorComp.createObject(root, {
        screen
    }))

    function getMonitorForScreen(screen: ShellScreen): var {
        return monitors.find(m => m.screen === screen)
    }

    reloadableId: "brightness"

    Component.onCompleted: {
        ddcProc.running = true
    }

    onMonitorsChanged: {
        ddcMonitors = []
        ddcProc.running = true
    }


    Process {
        id: ddcProc
        command: ["ddcutil", "detect", "--brief"]
        stdout: StdioCollector {
            onStreamFinished: root.ddcMonitors = text.trim().split("\n\n").filter(d => d.startsWith("Display ")).map(d => {
                const modelMatch = d.match(/Monitor:[ ]*([^:]+):([^:]+):/)
                const model = modelMatch ? modelMatch[2] : ""
                const busNum = d.match(/I2C bus:[ ]*\/dev\/i2c-([0-9]+)/)?.[1] || ""
                console.log("DDC Monitor detected - Model:", model, "Bus:", busNum)
                return { model, busNum }
            })
        }
    }

    // Helper functions for compatibility
    function updateBrightness(screen: ShellScreen, change: real): void {
        const monitor = getMonitorForScreen(screen)
        if (monitor) {
            monitor.setBrightness(monitor.brightness + (change / 100))
        }
    }

    function setBrightness(screen: ShellScreen, percentage: real): void {
        const monitor = getMonitorForScreen(screen)
        if (monitor) {
            monitor.setBrightness(percentage / 100)
        }
    }

    function getBrightness(screen: ShellScreen): real {
        const monitor = getMonitorForScreen(screen)
        return monitor ? monitor.brightness : 0
    }

    component BrightnessMonitor: QtObject {
        id: monitor

        required property ShellScreen screen
        readonly property bool isDdc: root.ddcMonitors.some(m => m.model === screen.model)
        readonly property string busNum: root.ddcMonitors.find(m => m.model === screen.model)?.busNum ?? ""
        property real brightness
        property bool ready: false

        function initialize() {
            monitor.ready = false
            initProc.command = isDdc ? ["ddcutil", "-b", busNum, "getvcp", "10", "--brief"] : ["sh", "-c", `echo "a b c $(brightnessctl g) $(brightnessctl m)"`]
            initProc.running = true
        }

        readonly property Process initProc: Process {
            stdout: SplitParser {
                onRead: data => {
                    const [, , , current, max] = data.split(" ")
                    monitor.brightness = parseInt(current) / parseInt(max)
                    monitor.ready = true
                }
            }
        }

        function setBrightness(value: real): void {
            value = Math.max(0.01, Math.min(1, value))
            const rounded = Math.round(value * 100)
            if (Math.round(brightness * 100) === rounded)
                return
            brightness = value
            setProc.command = isDdc ? ["ddcutil", "-b", busNum, "setvcp", "10", rounded] : ["brightnessctl", "s", `${rounded}%`, "--quiet"]
            setProc.startDetached()
        }

        Component.onCompleted: {
            initialize()
        }

        onBusNumChanged: {
            initialize()
        }
    }

    Process {
        id: setProc
    }

    Component {
        id: monitorComp
        BrightnessMonitor {}
    }
}