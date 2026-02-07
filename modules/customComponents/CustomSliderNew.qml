import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.utils
import QtQuick.Effects
import qs.modules.customComponents

Item {
    id: root
    property real progress: 0.0
    property real minimum: 0.0
    property real maximum: 1.0
    property real value: minimum + (maximum - minimum) * progress
    property bool interactive: true

    onValueChanged: {
        if (value !== minimum + (maximum - minimum) * progress) {
            progress = (value - minimum) / (maximum - minimum)
        }
    }



    Rectangle {
        id: track
        anchors.centerIn: parent
        width: parent.width
        height: 6
        radius: 10
        color: Colors.surface

        Rectangle {
            id: handle
            width: 16
            height: 16
            radius: height / 2
            x: (track.width - handle.width) * root.progress
            anchors.verticalCenter: parent.verticalCenter
            z: 2
            color: Colors.primaryContainer
            Behavior on x{
                NumberAnimation{
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }
            // border {
            //     width: 3
            //     color: Colors.inverseSurface
            // }

            scale: handleMouseArea.pressed ? 1.2 : (handleMouseArea.containsMouse ? 1.1 : 1.0)

            Behavior on scale {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }

            MouseArea {
                id: handleMouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                drag.target: handle
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: track.width - handle.width

                onPositionChanged: {
                    if (drag.active) {
                        let percentage = handle.x / (track.width - handle.width)
                        root.progress = Math.max(0, Math.min(1, percentage))
                    }
                }
            }
        }

        Rectangle {
            id: bar
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            radius: 10
            height: parent.height
            width: (track.width - handle.width) * root.progress + handle.width / 2
            color: Colors.primary

            Behavior on width{
                NumberAnimation{
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }
        }

        MouseArea {
            id: trackMouseArea
            anchors.fill: parent
            visible: root.interactive
            onClicked: (mouse) => {
                var newProgress = Math.max(0, Math.min(1, mouse.x / width))
                root.progress = newProgress
            }
        }
    }
}

