import Quickshell
import QtQuick
import qs.modules.util


Item{
    id: root
    property bool isToggleOn: true
    signal toggled(bool state)

    implicitHeight: 24
    implicitWidth: 44

    Rectangle{
        id: track
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 44
        implicitHeight: 24
        radius: 12
        color: root.isToggleOn ? Colors.primary : Colors.surfaceVariant

        Behavior on color{
            ColorAnimation{
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        MouseArea{
            id: toggleArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:{
                root.isToggleOn = !root.isToggleOn
                root.toggled(root.isToggleOn)
            }
        }

        Rectangle{
            id: handle
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: root.isToggleOn ? 18 : 14
            implicitHeight: width
            radius: 12
            x: root.isToggleOn ? track.width - (width + 4) : 4
            color: "#ffffff"

            Behavior on implicitWidth{
                NumberAnimation{
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on x{
                NumberAnimation{
                    duration: 300
                    easing.type: Easing.OutElastic
                }
            }
        }
    }
}
