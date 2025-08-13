import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes


Scope{
    id: root

    Variants{
        model: Quickshell.screens

        PanelWindow{
            required property var modelData
            screen: modelData
            color: "transparent"


            id: topBar

            implicitHeight: 50
            anchors{
                left: true
                right: true
                top: true
            }

            /*PopupWindow{
                implicitWidth: 1920
                implicitHeight: 100
                color: "red"
                visible: true
                anchor{
                    window: topBar
                    rect.x: 60
                    rect.y: 0
                }
            }*/

            WorkspaceRect{}
            MiddleRect{}
            UtilityRect{}
            
        }
    }
}
