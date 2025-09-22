import QtQuick
import QtQuick.Effects
import qs.modules.util

Item {
    id: root

    property string icon
    property var progress: 0.0
    property string color

    Row{
        anchors.fill: parent
        spacing: 5
        Image{
            anchors.verticalCenter: parent.verticalCenter
            id: systemIcon
            width: 20
            height: 20
            sourceSize: Qt.size(width, height)
            source: root.icon
        }

        Rectangle{
            anchors.verticalCenter: parent.verticalCenter
            implicitHeight: 10
            implicitWidth: parent.width - systemIcon.width
            color: Qt.alpha(root.color, 0.5)
            radius: 5

            Rectangle{
                anchors.bottom: parent.bottom
                implicitWidth: parent.width * root.progress
                implicitHeight: parent.height
                radius: 5
                color: root.color

                Behavior on implicitWidth{
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.InQuad
                    }
                }
            }
        }
    }
}
