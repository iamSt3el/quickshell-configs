pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property real downloadSpeed: 0.0
    property real uploadSpeed: 0.0
    property string downloadSpeedText: formatSpeed(downloadSpeed)
    property string uploadSpeedText: formatSpeed(uploadSpeed)

    property var previousStats: ({})
    property int updateInterval: 1000

    FileView {
        id: networkFileView
        path: "/proc/net/dev"
    }

    Timer {
        id: updateTimer
        interval: root.updateInterval
        running: true
        repeat: true
        onTriggered: updateNetworkSpeed()
    }

    function updateNetworkSpeed() {
        networkFileView.reload()
        const data = networkFileView.text()
        parseNetworkStats(data)
    }

    function parseNetworkStats(data) {
        const lines = data.split('\n')
        let totalRx = 0
        let totalTx = 0

        for (let i = 2; i < lines.length; i++) {
            const line = lines[i].trim()
            if (line === '') continue

            const parts = line.split(/\s+/)
            const interfaceName = parts[0].replace(':', '')

            if (interfaceName.startsWith('lo') ||
                interfaceName.startsWith('docker') ||
                interfaceName.startsWith('veth') ||
                interfaceName.startsWith('virbr') ||
                interfaceName.startsWith('br-')) {
                continue
            }

            if (parts.length >= 10) {
                totalRx += parseInt(parts[1]) || 0
                totalTx += parseInt(parts[9]) || 0
            }
        }

        const currentTime = Date.now()
        const currentStats = {
            rx: totalRx,
            tx: totalTx,
            time: currentTime
        }

        if (previousStats.time) {
            const timeDiff = (currentTime - previousStats.time) / 1000

            if (timeDiff > 0) {
                const rxDiff = currentStats.rx - previousStats.rx
                const txDiff = currentStats.tx - previousStats.tx

                downloadSpeed = Math.max(0, rxDiff / timeDiff)
                uploadSpeed = Math.max(0, txDiff / timeDiff)
            }
        }

        previousStats = currentStats
    }

    function formatSpeed(bytesPerSecond) {
        if (bytesPerSecond < 1024) {
            return bytesPerSecond.toFixed(0) + " B/s"
        } else if (bytesPerSecond < 1024 * 1024) {
            return (bytesPerSecond / 1024).toFixed(1) + " KB/s"
        } else if (bytesPerSecond < 1024 * 1024 * 1024) {
            return (bytesPerSecond / (1024 * 1024)).toFixed(1) + " MB/s"
        } else {
            return (bytesPerSecond / (1024 * 1024 * 1024)).toFixed(1) + " GB/s"
        }
    }
}