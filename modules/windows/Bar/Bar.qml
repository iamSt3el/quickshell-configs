import Quickshell
import QtQuick

PanelWindow{
    id: bar
    implicitHeight: 50
    color: "transparent"

    anchors{
        top: true
        left: true
        right: true
    }

    Workspaces{}
    Clock{}
    Utility{}
}
