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
//import qs.modules.components.MangaReader

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
    Vis{
        anchors {
            left: true
            right: true
            bottom: true
        }
    }

    


    // Lock screen - responds to `loginctl lock-session`
    LockScreen {}
}
