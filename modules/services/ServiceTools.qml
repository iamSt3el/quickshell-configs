pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick


Singleton{
    id: root

    // Recording state properties
    property bool isRecording: false
    property string recordingMode: ""
    property date recordingStartTime: new Date()
    property int recordingSeconds: 0
    property bool wasRecording: false

    // Timer for tracking recording duration
    Timer {
        id: durationTimer
        interval: 1000
        repeat: true
        running: root.isRecording
        onTriggered: {
            recordingSeconds++
        }
    }

    // Process to check if wf-recorder is running
    Process {
        id: recordingCheckProcess
        running: false
        command: ["pgrep", "-x", "wf-recorder"]

        stdout: StdioCollector {
            onStreamFinished: {
                wasRecording = isRecording
                isRecording = recordingCheckProcess.exitCode === 0

                // Recording just stopped
                if (wasRecording && !isRecording) {
                    var duration = recordingSeconds
                    recordingSeconds = 0
                    recordingMode = ""
                    Quickshell.execDetached(["notify-send", "Recording Stopped",
                        "Duration: " + Math.floor(duration / 60) + ":" + String(duration % 60).padStart(2, "0")])
                }
            }
        }
    }

    // Timer to trigger recording state checks
    Timer {
        id: recordingChecker
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            recordingCheckProcess.running = true
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

    // Get XDG Videos directory (or fallback to ~/Videos)
    readonly property string videosDir: {
        var result = Quickshell.exec(["xdg-user-dir", "VIDEOS"])
        var dir = result.stdout.trim()
        return (dir && dir !== "/home/steel") ? dir : "/home/steel/Videos"
    }

    // Get audio output source for recording with audio
    function getAudioOutput() {
        var result = Quickshell.exec(["sh", "-c", "pactl list sources | grep 'Name' | grep 'monitor' | cut -d ' ' -f2"])
        return result.stdout.trim()
    }

    // Get active monitor name
    function getActiveMonitor() {
        var result = Quickshell.exec(["sh", "-c", "hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name'"])
        return result.stdout.trim()
    }

    // Generate filename with timestamp
    function generateFilename() {
        var now = new Date()
        var timestamp = now.getFullYear() + "-" +
            String(now.getMonth() + 1).padStart(2, "0") + "-" +
            String(now.getDate()).padStart(2, "0") + "_" +
            String(now.getHours()).padStart(2, "0") + "." +
            String(now.getMinutes()).padStart(2, "0") + "." +
            String(now.getSeconds()).padStart(2, "0")
        return videosDir + "/recording_" + timestamp + ".mp4"
    }

    // Toggle recording with improved bash-based approach
    function toggleRecording(mode, withAudio) {
        // If already recording, stop it
        if (isRecording) {
            Quickshell.execDetached(["pkill", "-x", "wf-recorder"])
            return
        }

        // Start new recording
        recordingMode = mode
        recordingStartTime = new Date()
        recordingSeconds = 0

        var filename = generateFilename()
        var cmd = ""

        // Build command based on mode
        if (mode === "Screen") {
            var monitor = getActiveMonitor()
            cmd = `wf-recorder -o ${monitor} --pixel-format yuv420p -f '${filename}' -t`
        } else if (mode === "Window") {
            cmd = `wf-recorder -g "$(hyprctl activewindow -j | jq -r '"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"')" --pixel-format yuv420p -f '${filename}' -t`
        } else if (mode === "Area") {
            cmd = `wf-recorder -g "$(slurp)" --pixel-format yuv420p -f '${filename}' -t`
        }

        // Add audio if requested
        if (withAudio) {
            var audio = getAudioOutput()
            if (audio) {
                cmd += ` --audio="${audio}"`
            }
        }

        // Execute recording command
        Quickshell.execDetached(["sh", "-c", cmd])
        Quickshell.execDetached(["notify-send", "Recording Started", "Recording " + mode])
    }

    function stopRecording() {
        if (isRecording) {
            Quickshell.execDetached(["pkill", "-x", "wf-recorder"])
        }
    }

    function getFormattedRecordingTime() {
        return Math.floor(recordingSeconds / 60).toString().padStart(2, "0") + ":" +
               (recordingSeconds % 60).toString().padStart(2, "0")
    }
}
