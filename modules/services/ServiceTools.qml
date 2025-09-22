pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.util

Singleton {
    id: root

    // Recording state properties
    property bool isRecording: false
    property string recordingMode: ""
    property string recordingFilename: ""
    property date recordingStartTime: new Date()

    // Recording duration calculation with timer to trigger updates
    property int recordingSeconds: 0
    
    Timer {
        id: durationTimer
        interval: 1000
        repeat: true
        running: root.isRecording
        onTriggered: {
            recordingSeconds++
        }
    }

    // Recording state management using wf-recorder with temp file tracking
    readonly property string recordingInfoFile: "/tmp/quickshell-recording-info"
    
    // Direct file reading - much simpler!
    FileView {
        id: recordingInfoFileView
        path: recordingInfoFile
        // Suppress warnings when file doesn't exist initially
        Component.onCompleted: {
            // FileView will handle non-existent files gracefully
        }
    }
    
    // File checking state
    property bool shouldCheckFile: false
    property int checkAttempts: 0
    readonly property int maxCheckAttempts: 10 // Stop checking after 20 seconds if no file found
    
    // File checker - only runs when shouldCheckFile is true
    Timer {
        id: fileChecker
        interval: 2000
        repeat: true
        running: root.shouldCheckFile
        onTriggered: {
            recordingInfoFileView.reload()
            var content = recordingInfoFileView.text()
            
            if (content && content.trim() !== "") {
                // File found with content - recording is active
                if (!isRecording) {
                    // File appeared, start recording state
                    try {
                        var info = JSON.parse(content)
                        updateRecordingState(info)
                    } catch (e) {
                        // If JSON parse fails, just set basic recording state
                        isRecording = true
                        recordingMode = "Unknown"
                        recordingStartTime = new Date()
                    }
                }
            } else {
                // File doesn't exist or is empty
                if (isRecording) {
                    // File disappeared - recording stopped
                    handleRecordingEnded()
                    shouldCheckFile = false // Stop checking
                } else {
                    // Still no file, increment attempts
                    checkAttempts++
                    if (checkAttempts >= maxCheckAttempts) {
                        // Give up checking
                        shouldCheckFile = false
                        checkAttempts = 0
                    }
                }
            }
        }
    }
    
    function updateRecordingState(info) {
        if (!isRecording && info.recording) {
            // Recording started - use data from file
            recordingMode = info.mode || "Unknown"
            recordingFilename = info.filename || ""
            recordingStartTime = new Date(info.startTime || Date.now())
            recordingSeconds = 0 // Reset counter when recording is confirmed
            isRecording = true
        }
    }
    
    function handleRecordingEnded() {
        if (isRecording) {
            var duration = recordingSeconds
            isRecording = false
            recordingSeconds = 0
            recordingMode = ""
            recordingFilename = ""
            
            Quickshell.execDetached(["notify-send", "Recording Stopped", 
                "Duration: " + Math.floor(duration / 60) + ":" + String(duration % 60).padStart(2, "0")])
        }
    }

    property var tools: [
        {
            name: "Record",
            icon: "video",
            options: [
                {
                    name: "Screen",
                    icon: "max",
                    type: "recording"
                },
                {
                    name: "Window", 
                    icon: "crop",
                    type: "recording"
                },
                {
                    name: "Area",
                    icon: "pointer", 
                    type: "recording"
                }
            ]
        },
        {
            name: "Screenshot",
            icon: "camera",
            options: [
                {
                    name: "Screen",
                    icon: "max",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave output"]
                },
                {
                    name: "Window",
                    icon: "crop",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave active"]
                },
                {
                    name: "Area",
                    icon: "pointer",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave area"]
                }
            ]
        },
        {
            name: "Setting",
            icon: "setting",
            options: [
                {
                    name: "Control Center",
                    icon: "setting",
                    command: ["gnome-control-center"]
                }
            ]
        },
        {
            name: "Power",
            icon: "shutdown",
            options: [
                {
                    name: "Shutdown",
                    icon: "shutdown",
                    command: ["systemctl", "poweroff"]
                },
                {
                    name: "Restart",
                    icon: "reboot",
                    command: ["systemctl", "reboot"]
                },
                {
                    name: "Logout",
                    icon: "suspend", 
                    command: ["hyprctl", "dispatch", "exit"]
                }
            ]
        }    
    ]

    // Recording management functions
    function generateRecordingFilename() {
        var now = new Date()
        var timestamp = now.getFullYear() + 
            String(now.getMonth() + 1).padStart(2, "0") + 
            String(now.getDate()).padStart(2, "0") + "-" +
            String(now.getHours()).padStart(2, "0") + 
            String(now.getMinutes()).padStart(2, "0") + 
            String(now.getSeconds()).padStart(2, "0")
        return "/home/steel/Videos/recording-" + timestamp + ".mp4"
    }

    function getRecordingCommand(mode) {
        var filename = generateRecordingFilename()
        var startTime = Date.now()
        
        // Create recording info JSON
        var infoJson = JSON.stringify({
            recording: true,
            mode: mode,
            filename: filename,
            startTime: startTime,
            pid: "$$"
        })
        
        // Command that writes info file and starts recording
        var infoCommand = `echo '${infoJson}' > ${recordingInfoFile}`
        var cleanupCommand = `rm -f ${recordingInfoFile}`
        
        switch(mode.toLowerCase()) {
            case "screen":
                return ["sh", "-c", `${infoCommand} && trap '${cleanupCommand}' EXIT INT TERM && wf-recorder -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') -f ${filename}`]
            case "window":
                return ["sh", "-c", `${infoCommand} && trap '${cleanupCommand}' EXIT INT TERM && wf-recorder -g "$(hyprctl activewindow -j | jq -r '"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])"')" -f ${filename}`]
            case "area":
                return ["sh", "-c", `${infoCommand} && trap '${cleanupCommand}' EXIT INT TERM && wf-recorder -g "$(slurp)" -f ${filename}`]
            default:
                return ["sh", "-c", `${infoCommand} && trap '${cleanupCommand}' EXIT INT TERM && wf-recorder -f ${filename}`]
        }
    }

    function startRecording(mode, command = null) {
        if (shouldCheckFile) {
            return false // Already trying to start recording
        }
        
        recordingMode = mode
        recordingFilename = generateRecordingFilename()
        recordingStartTime = new Date()
        
        // Use provided command or generate one
        var cmd = command || getRecordingCommand(mode)
        
        // Execute the recording command
        Quickshell.execDetached(cmd)
        
        // Start checking for file
        shouldCheckFile = true
        checkAttempts = 0
        
        // Show notification
        Quickshell.execDetached(["notify-send", "Recording Started", "Recording " + mode])
        
        return true
    }

    function stopRecording() {
        if (!isRecording && !shouldCheckFile) {
            return false
        }
        
        // Cache values before resetting
        var duration = recordingSeconds
        var mode = recordingMode
        
        // Kill wf-recorder and clean up info file
        Quickshell.execDetached(["sh", "-c", `pkill -x wf-recorder && rm -f ${recordingInfoFile}`])
        
        // Stop checking and reset state
        shouldCheckFile = false
        checkAttempts = 0
        isRecording = false
        recordingSeconds = 0
        recordingMode = ""
        recordingFilename = ""
        
        // Show notification
        Quickshell.execDetached(["notify-send", "Recording Stopped", 
            "Duration: " + Math.floor(duration / 60) + ":" + String(duration % 60).padStart(2, "0")])
        
        return true
    }

    function toggleRecording(mode, command) {
        if (isRecording) {
            return stopRecording()
        } else {
            return startRecording(mode, command)
        }
    }

    function getFormattedRecordingTime() {
        return Math.floor(recordingSeconds / 60).toString().padStart(2, "0") + ":" + 
               (recordingSeconds % 60).toString().padStart(2, "0")
    }

    // Function to be called from external commands/IPC
    function forceStopRecording() {
        if (isRecording) {
            stopRecording()
            return "Recording stopped successfully"
        }
        return "No recording in progress"
    }

    // stopRecording function is already accessible as ServiceTools.stopRecording()

    function launchTool(command) {
        if (command) {
            if (Array.isArray(command)) {
                // Handle array commands
                Quickshell.execDetached(command)
            } else {
                // Handle string commands (legacy)
                Quickshell.execDetached([command])
            }
        }
    }
}