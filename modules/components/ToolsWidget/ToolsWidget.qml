import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Scope{
    Loader{
        id: loader
        active: false
        property bool animation: false
        sourceComponent: PanelWindow{
            id: panelWindow
            implicitWidth: 600
            implicitHeight: 600
            WlrLayershell.layer: WlrLayer.Top
            exclusionMode: ExclusionMode.Normal
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            color: "transparent"

            mask: Region {
                item: maskRect
                intersection: Intersection.Xor

                Region {
                    item: container
                    intersection: Intersection.Subtract
                }
            }

            Rectangle {
                id: maskRect
                anchors.fill: parent
                color: "transparent"
                //color: Qt.alpha(Colors.outline, 0.5)
            }

            HyprlandFocusGrab{
                id: focusGrab
                windows: [panelWindow]
                active: loader.active
                onCleared: () => {
                    if(!active) {
                        GlobalStates.toolsWidgetOpen = false
                    }
                }
            }

            // ToolsWidgetContentNew{
            //     id: container
            // }

            ToolsWidgetContent{
                id: container
            }
            //CameraTools{}

        }
    }

    Connections {
        target: GlobalStates
        function onToolsWidgetOpenChanged() {
            if (GlobalStates.toolsWidgetOpen) {
                loader.active = true
            }
            else{
                loader.active = false
            }
        }
    }

    // // Re-open the widget to show the recording UI once Area/Window recording starts
    // Connections {
    //     target: ServiceTools
    //     function onIsRecordingChanged() {
    //         if (ServiceTools.isRecording && !GlobalStates.toolsWidgetOpen) {
    //             GlobalStates.toolsWidgetOpen = true
    //         }
    //     }
    // }


    GlobalShortcut{
        name: "toolsWidget"
        onPressed:{
            if(!GlobalStates.toolsWidgetOpen){
                GlobalStates.toolsWidgetOpen = true
            }else{
                GlobalStates.toolsWidgetOpen = false
            }
        }
    }

}
