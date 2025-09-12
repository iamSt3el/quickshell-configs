pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland

Loader {
    id: backgroundLoader


    sourceComponent: PanelWindow {
            id: panel;
            WlrLayershell.layer: WlrLayer.Background
            WlrLayershell.namespace: "Shell:Background"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            screen: Quickshell.screens[1]
            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Item {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                width: 42

                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0, 255, 255, 1)

                }
            }
        }
    }
