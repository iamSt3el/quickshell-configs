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
    id: overall
    implicitHeight: 300
    implicitWidth: 300
    radius: 20
    color: Colors.surface

    signal cameraClicked()
    signal recordingClicked()

    property list<var> toolItems: [
        { icon: "photo_camera", action: "camera" },
        { icon: "videocam",     action: "video"  },
        { icon: "power_settings_new", action: "power"    },
        { icon: "settings",    action: "settings" }
    ]

    GridLayout{
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rows: 2
        columnSpacing: 10
        rowSpacing: 10

        Repeater{
            model: overall.toolItems
            delegate: Rectangle{
                id: tile
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 20
                color: area.containsMouse ? Colors.primary : Colors.surfaceContainer

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }


                MaterialIconSymbol{
                    anchors.centerIn: parent
                    content: modelData.icon
                    color: area.containsMouse ? Colors.primaryText : Colors.surfaceText
                    iconSize: 80

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
                        if (modelData.action === "camera") overall.cameraClicked()
                        if (modelData.action === "video") overall.recordingClicked()
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
