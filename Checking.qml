pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

Loader {
    id: backgroundLoader

    active: true
    sourceComponent: PanelWindow {
            id: panel;
            WlrLayershell.layer: WlrLayer.Overlay
            //WlrLayershell.namespace: "Shell:Background"
            WlrLayershell.exclusionMode: ExclusionMode.Normal
            screen: Quickshell.screens[1]
            implicitWidth: 400
            implicitHeight: 100
           

            Item {
                anchors.fill: parent
                ClippingWrapperRectangle {
                    id: wrapper
                    anchors.centerIn: parent
                    implicitHeight: 50
                    implicitWidth: 50
                    //color: "black"
                    radius: 20
                    
                }
            }
        }
    }
