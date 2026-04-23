pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import qs.modules.settings
import WfRecorder


Singleton{
    id: root

    // Recording state — sourced directly from the C++ plugin
    readonly property bool   isRecording:   WfRecorder.recording
    readonly property string recordingMode: WfRecorder.mode
    readonly property int    recordingSeconds: WfRecorder.elapsed
    readonly property string lastFilename:  WfRecorder.filename

    // Send stop notification when recording finishes
    Connections {
        target: WfRecorder
        function onRecordingStopped(duration) {
            Quickshell.execDetached(["notify-send", "Recording Stopped",
                "Duration: " + Math.floor(duration / 60) + ":" +
                String(duration % 60).padStart(2, "0")])
        }
        function onRecordingError(message) {
            Quickshell.execDetached(["notify-send", "-u", "critical",
                "Recording Error", message])
        }
    }

    property var tools: [
        {
            name: "Record",
            icon: "videocam",
            options:[
                {
                    name: "Screen",
                    icon: "screenshot_frame_2",
                    audio: false
                },

                {
                    name: "Window",
                    icon: "window",
                    audio: false
                },
                {
                    name: "Area",
                    icon: "select",
                    audio: false
                },
 
            ]
        },
        {
            name: "Screenshot",
            icon: "photo_camera",
            options:[
                {
                    name: "Screen",
                    icon: "screenshot_frame_2",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave output"]

                },
                {
                    name: "Window",
                    icon: "window",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave active"]

                },
                {
                    name: "Area",
                    icon: "select",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave area"]

                }
            ]
        },
        {
            name: "Setting",
            icon: "settings"
        },
        {
            name: "Power",
            icon: "power_settings_new",
            options:[
                {
                    name: "Shutdown",
                    icon: "power_settings_new",
                    command: ["systemctl", "poweroff"]


                },
                {
                    name: "Restart",
                    icon: "refresh",
                    command: ["systemctl", "reboot"]

                },
                {
                    name: "Logout",
                    icon: "logout",
                    command: ["loginctl", "lock-session"]

                }
            ]
        }
    ]

    // Delay timer for Area/Window modes: fires after the panel has closed so
    // slurp / compositor input grabs don't compete with HyprlandFocusGrab.
    Timer {
        id: delayTimer
        interval: 400
        repeat: false
        property string pendingMode: ""
        property string pendingGeometry: ""
        onTriggered: root.toggleRecording(pendingMode, pendingGeometry)
    }

    // Call this from ToolsWidgetContent for Area/Window so the timer
    // survives the Loader teardown.
    function startDelayed(mode, geometry) {
        delayTimer.pendingMode = mode
        delayTimer.pendingGeometry = geometry
        delayTimer.restart()
    }

    // Generate filename using SettingsConfig output path + muxer extension
    function generateFilename() {
        var now = new Date()
        var timestamp = now.getFullYear() + "-" +
            String(now.getMonth() + 1).padStart(2, "0") + "-" +
            String(now.getDate()).padStart(2, "0") + "_" +
            String(now.getHours()).padStart(2, "0") + "." +
            String(now.getMinutes()).padStart(2, "0") + "." +
            String(now.getSeconds()).padStart(2, "0")
        var dir = SettingsConfig.recording.outputPath.replace("~", Quickshell.env("HOME"))
        var ext = SettingsConfig.recording.muxer
        return dir + "/recording_" + timestamp + "." + ext
    }

    // geometry is pre-captured for Window mode (empty string for Screen/Area)
    function toggleRecording(mode, geometry) {
        if (WfRecorder.recording) {
            WfRecorder.stop()
            return
        }

        var rec = SettingsConfig.recording
        var filename = generateFilename()
        var base = `wf-recorder --codec ${rec.codec} --pixel-format ${rec.pixelFormat} -r ${rec.framerate}`
        var cmd = ""

        if (mode === "Screen") {
            cmd = `${base} -o ${Hyprland.focusedMonitor.name} -f '${filename}'`
        } else if (mode === "Window") {
            cmd = `${base} -g "${geometry}" -f '${filename}'`
        } else if (mode === "Area") {
            cmd = `${base} -g "$(slurp)" -f '${filename}'`
        }

        if (rec.audioEnabled) {
            // --audio without a device uses the default monitor source automatically
            cmd += ` --audio --audio-codec ${rec.audioCodec} --audio-bitrate ${rec.audioBitrate} --sample-rate ${rec.audioSampleRate}`
        }

        WfRecorder.start(cmd, mode, filename)
        Quickshell.execDetached(["notify-send", "Recording Started", "Recording " + mode])
    }

    function stopRecording() {
        WfRecorder.stop()
    }

    function getFormattedRecordingTime() {
        return WfRecorder.formattedTime()
    }
}
