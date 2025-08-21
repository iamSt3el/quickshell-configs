import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Shapes
import Quickshell.Bluetooth

Item {
    id: utilityPopUpItem
    property bool isUtilityPopUpVisible: false
    property var utility: null
    property alias utilityCloseTimer: utilityCloseTimer
 

    Timer {
        id: utilityCloseTimer
        interval: 300
        onTriggered: {
            close()
        }
    }

    PopupWindow {
        id: utilityPopupWrapper
        anchor.window: topBar
        implicitWidth: utilityRowWrapper.width - 150
        implicitHeight: 460
        color: "transparent"
        visible: isUtilityPopUpVisible

        anchor {
            rect.x: utilityRectItem.x
            rect.y: utilityRect.height
            //gravity: Edges.Bottom
            adjustment: PopupAdjustment.FlipX
            //margins.left: 0
            //margins.right: 0
        }

        Rectangle {
            id: animationRect
            anchors.fill: parent
            color: "transparent"

            transform: Scale {
                id: scaleTransform
                origin.x: animationRect.width / 2
                origin.y: 0
                yScale: 0
            }

            Shape {
                ShapePath {
                    fillColor: "#11111b"
                    //strokeColor: "blue"
                    strokeWidth: 0
                    startX: utilityPopupWrapper.x || 0
                    startY: utilityPopupWrapper.y || 0

                    PathArc {
                        relativeX: 20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 15
                    }
                    PathLine {
                        relativeX: utilityPopupWrapper.width - 40
                        relativeY: 0
                    }
                    PathLine {
                        relativeX: 0
                        relativeY: utilityPopupWrapper.height - 40
                    }
                    PathArc{
                        relativeY: 20
                        relativeX: 20
                        radiusX: 20
                        radiusY: 15
                    }
                    PathLine{
                        relativeY: - utilityPopupWrapper.height
                        relativeX: 0
                    }
                }
            }

            Rectangle {
                id: utilityPopup
                implicitHeight: parent.height - 20
                implicitWidth: parent.width - 20
                anchors.right: parent.right
                color: "#11111b"
                bottomLeftRadius: 20

                Rectangle {
                    implicitHeight: parent.height - 20
                    implicitWidth: parent.width - 20
                    color: "#1E1E2E"
                    clip: true
                    radius: 10
                    anchors {
                        bottom: parent.bottom
                        centerIn: parent
                    }

                    BluetoothPanel {
                        anchors.fill: parent
                    }
                }
            }
        }

        ParallelAnimation {
            id: openAnimation

            NumberAnimation {
                target: animationRect
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.1
            }
        }
        ParallelAnimation {
            id: closeAnimation

            NumberAnimation {
                target: animationRect
                property: "y"
                to: -30
                duration: 300
                easing.type: Easing.InCubic
            }

            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
                easing.overshoot: 1.1
            }

            onFinished: {
                isUtilityPopUpVisible = false
            }
        }
    }

    function open() {
        utilityCloseTimer.stop()
        isUtilityPopUpVisible = true
        openAnimation.start()
    }
    function close() {
        closeAnimation.start()
    }
}
