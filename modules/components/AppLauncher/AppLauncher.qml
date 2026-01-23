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
        active: GlobalStates.appLauncherOpen
        property bool animation: false
        sourceComponent:PanelWindow{
            id: panelWindow
            implicitWidth: 300
            implicitHeight: 600
            anchors.left: true
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

            AppLauncherContent{
                implicitWidth: loader.animation ? parent.width : 0
                onClosed:{
                    loader.animation = false
                    animationTimer.start();
                }

                layer.enabled: true
                layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                }
            }
        }
    }

    Timer{
        id: animationTimer
        interval: 300
        onTriggered:{
            if(GlobalStates.appLauncherOpen) GlobalStates.appLauncherOpen = false
        }
    }

    GlobalShortcut{
        name: "appLauncher"
        onPressed:{
            if(GlobalStates.appLauncherOpen){
                loader.animation = false
                animationTimer.start();
            }else{
                GlobalStates.appLauncherOpen = true
                loader.animation = true
            }
        }
    }

}
