pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    id: root
    
    // Brightness properties (shared across all monitors)
    property real currentBrightness: 50.0
    property real maxBrightness: 100.0
    
    // Volume properties (shared across all monitors)  
    readonly property real currentVolume: Pipewire.defaultAudioSink?.audio?.volume ?? 0.5
    
    // Brightness control processes
    Process {
        id: getBrightnessProcess
        command: ["brightnessctl", "get"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let brightness = parseInt(this.text.trim());
                if (!isNaN(brightness)) {
                    root.currentBrightness = brightness;
                }
            }
        }
    }
    
    Process {
        id: getMaxBrightnessProcess
        command: ["brightnessctl", "max"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let maxBrightness = parseInt(this.text.trim());
                if (!isNaN(maxBrightness)) {
                    root.maxBrightness = maxBrightness;
                }
            }
        }
    }
    
    Process {
        id: setBrightnessProcess
        command: ["brightnessctl", "set", "50%"]
    }
    
    // PipeWire audio tracking
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSource,
            Pipewire.defaultAudioSink
        ]
    }
    
    // Functions
    function setBrightness(percentage) {
        setBrightnessProcess.command = ["brightnessctl", "set", Math.round(percentage) + "%"];
        setBrightnessProcess.running = true;
        // Update immediately for visual feedback
        root.currentBrightness = (percentage / 100) * root.maxBrightness;
    }
    
    function setVolume(newVolume) {
        if (Pipewire.defaultAudioSink?.ready && Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.muted = false;
            Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, newVolume / 100));
        }
    }
    
    // Brightness update timer
    Timer {
        id: brightnessUpdateTimer
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            getBrightnessProcess.running = true;
        }
    }
    
    // Initialize
    Component.onCompleted: {
        getMaxBrightnessProcess.running = true;
        getBrightnessProcess.running = true;
    }
}