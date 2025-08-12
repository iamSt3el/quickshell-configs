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

            WorkspaceRect{}
            UtilityRect{}
            
            MiddleRect{}
        }
    }
}
