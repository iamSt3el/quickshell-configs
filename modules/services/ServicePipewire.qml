pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import Quickshell.Services.Pipewire

Singleton{
    id: root    

    property var volume : Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio ? Pipewire.defaultAudioSink.audio.volume : 0.0

    property bool isMuted: Pipewire.defaultAudioSink.audio.muted
    
    // Track pipewire objects to ensure they're loaded
    PwObjectTracker {
        objects: [
            Pipewire.defaultAudioSource,
            Pipewire.defaultAudioSink
        ]
    }
    
    Component.onCompleted:{
        console.log("volume: " + (Pipewire.defaultAudioSink?.audio?.volume ?? "not ready"))
    }
    function updateVolume(volume): void{
        if (Pipewire.defaultAudioSink?.ready && Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, Pipewire.defaultAudioSink.audio.volume + volume))
        }
    }

    function updateState(): void{
        if (Pipewire.defaultAudioSink?.ready && Pipewire.defaultAudioSink?.audio) {
            Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }
    }
}
