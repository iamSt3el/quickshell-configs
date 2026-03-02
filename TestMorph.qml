import Quickshell
import Quickshell.Wayland
import QtQuick
import "modules/MatrialShapes" as MS

Scope {
    id: root
    property bool expanded: false

    PanelWindow {
        id: panelWindow
        implicitHeight: 500
        implicitWidth: 500
        anchors.left: true
        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Normal
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10
            color: "#aaa"
            text: "Click to toggle morph"
            font.pixelSize: 12
        }

        MS.MorphShape {
            anchors.centerIn: parent
            implicitWidth: 350
            implicitHeight: 350
            color: "#685496"
            expanded: root.expanded

            // All configurable:
            upperWidth: 0.8
            upperHeight: 0.55
            stemWidth: 0.15
            stemHeight: 0.25
            topRounding: 0.08
            stepRounding: 0.05
            stemRounding: 0.03
        }
    }
}
