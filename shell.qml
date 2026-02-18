//@ pragma UseQApplication
import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.modules.components.layout
import qs.modules.components.LockScreen
import qs.modules.components.AppLauncher
import qs.modules.components.Clipboard
import qs.modules.components.Setting
import qs.modules.components.Osd
import qs.modules.components.WallpaperSelector
import qs.modules.components.MusicVis
import qs.modules.settings

ShellRoot{
    Variants{
        model: Quickshell.screens
        delegate: Item{
            required property var modelData
            Layout{
                screen: modelData
            }
        }
    }

    AppLauncher{}
    Clipboard{}
    SettingsPanel{}
    Osd{}
    Wallpaper{}

    Loader{
        active: GlobalStates.musicVis
        sourceComponent:Vis{
            anchors {
                left: true
                right: true
                bottom: true
            }
        }
    }

    //Panel{}
    //ColorPicker{}
    


    // Lock screen - responds to `loginctl lock-session`
    LockScreen {}
}
