import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Scope{
    Loader{
        id: loader
        active: GlobalStates.wallpaperOpen
        property bool animation: false
        sourceComponent:PanelWindow{
            id: panelWindow
            implicitWidth: Appearance.size.wallpaperPanelWidth
            implicitHeight: Appearance.size.wallpaperPanelHeight
            anchors.bottom: true
            WlrLayershell.layer: WlrLayer.Top
            exclusionMode: ExclusionMode.Normal
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            color: "transparent"
                
            HyprlandFocusGrab{
                id: grab
                windows: [panelWindow]
                active: loader.active
                onCleared: () => {
                     if(!active) {
                        loader.animation = false
                        animationTimer.start()
                    }
                }
            }

            WallpaperContent{
                implicitHeight:loader.animation ?  parent.height : 0
            }

            
        }
    }

    Timer{
        id: animationTimer
        interval: Appearance.duration.normal
        onTriggered:{
            if(GlobalStates.wallpaperOpen) GlobalStates.wallpaperOpen = false
        }
    }


    GlobalShortcut{
        name: "wallpaperLauncher"
        onPressed:{
            if(GlobalStates.wallpaperOpen){
                loader.animation = false
                animationTimer.start();
            }else{
                GlobalStates.wallpaperOpen = true
                loader.animation = true
            }
        }
    }

}
