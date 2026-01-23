import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Scope{
    Loader{
        id: loader
        active: GlobalStates.osdOpen
        sourceComponent:PanelWindow{
            id: panelWindow
            implicitWidth: Appearance.size.osdWidth
            implicitHeight: Appearance.size.osdHeight
            visible: true
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Top
            exclusionMode: ExclusionMode.Normal
            WlrLayershell.keyboardFocus:WlrKeyboardFocus.None
            anchors{
                top: true
            }
            margins{
                top: 50
            }

            OsdContent{

            }
            Timer{
                id: timer
                interval: 4000
                running: true
                onTriggered:{
                    GlobalStates.osdOpen = false
                }
            }
        }
    }

    Connections {
        target: ServicePipewire.sink?.audio ?? null
        function onVolumeChanged() {
            //if (!ServicePipewire.ready) return
            GlobalStates.osdOpen = true
            //root.triggerOsd()
        }
        // function onMutedChanged() {
        //     if (!ServicePipewire.ready) return
        //     //root.triggerOsd()
        // }
    }
}
