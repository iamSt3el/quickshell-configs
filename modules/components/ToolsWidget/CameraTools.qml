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


Rectangle{
    id: cameraRoot
    implicitWidth: 300
    implicitHeight: 300
    radius: 20
    color: Colors.surface

    signal backClicked()

    property list<var> toolItems: [
        { icon: "select",              action: ""     },
        { icon: "screenshot_monitor",  action: ""     },
        { icon: "arrow_back",          action: "back" },
        { icon: "settings_photo_camera", action: ""   }
    ]

    GridLayout{
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater{
            model: cameraRoot.toolItems
            delegate: Rectangle{
                Layout.fillHeight: true
                Layout.fillWidth: true
                radius: 20
                color: area.containsMouse ? Colors.primary : Colors.surfaceContainer

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                MaterialIconSymbol{
                    anchors.centerIn: parent
                    content: modelData.icon
                    color: area.containsMouse ? Colors.primaryText : Colors.surfaceText
                    iconSize: 60

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }

                MouseArea{
                    id: area
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.action === "back") cameraRoot.backClicked()
                    }
                }
            }
        }
    }

    Rectangle{
        implicitWidth: 80
        implicitHeight: 80
        color: Colors.surface
        anchors.centerIn: parent
        radius: width

        Rectangle{
            anchors.fill: parent
            anchors.margins: 10
            radius: width
            color: Colors.primary

            MaterialIconSymbol{
                anchors.centerIn: parent
                content: "close"
                color: Colors.primaryText
                iconSize: 40
            }
        }
    }

}
