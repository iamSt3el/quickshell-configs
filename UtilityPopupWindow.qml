import Quickshell
import QtQuick
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
        implicitWidth: utilityRowWrapper.width + 30
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
                //anchors.horizontalCenter: parent.horizontalCenter
                //visible: false

                color: "#11111b"
                bottomLeftRadius: 20
                //bottomRightRadius: 10

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

                    /*Column {
                        id: wifiDetails
                        anchors.fill: parent
                        //anchors.leftMargin: 5
                        visible: utility && utility.objectName === "wifi"

                        Text {
                            text: "connected To"
                            color: "#799EFF"
                        }
                    }*/

                    Column {
                        id: devicesList
                        spacing: 10
                        anchors {
                            fill: parent
                            margins: 20
                        }
                        Row {
                            width: parent.width
                            height: 20
                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: "transparent"
                                Text {
                                    text: "Bluetooth"
                                    color: "#89b4fa"
                                    font.pixelSize: 18
                                }

                                Rectangle {
                                    implicitWidth: 50
                                    implicitHeight: 20
                                    color: "#11111b"
                                    radius: 10

                                    anchors {
                                        right: parent.right
                                    }

                                    Rectangle {
                                        property bool isToggleOn: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.state === 1 ? true : false
                                        id: toggleButton
                                        implicitWidth: 25
                                        implicitHeight: 20
                                        color: "#89b4fa"
                                        radius: 20
                                        x: isToggleOn ? 25 : 0

                                        Behavior on x {
                                            NumberAnimation {duration: 200; easing.type: Easing.Linear}
                                        }
                                        anchors {

                                        }

                                        MouseArea {
                                            id: toggleButtonArea
                                            anchors.fill: parent
                                            hoverEnabled: true

                                            onClicked: {
                                                if (toggleButton.isToggleOn) {
                                                    toggleButton.isToggleOn = false;
                                                    //toggleButton.x = 0
                                                    Quickshell.execDetached(["bluetoothctl", "power", "off"])
                                                    console.log("State: " + Bluetooth.defaultAdapter.state)
                                                } else {
                                                    toggleButton.isToggleOn = true
                                                    Quickshell.execDetached(["bluetoothctl", "power", "on"])
                                                    console.log("State: " + Bluetooth.defaultAdapter.state)
                                                    toggleButton.x = toggleButton.width
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Repeater {
                            model: Bluetooth.devices
                            delegate: Rectangle {
                                visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.state === 1 ? true : false
                                width: parent.width
                                height: 50
                                color: modelData.state === 1 ? "#a6e3a1" : "#45475a"
                                radius: 10

                                Row {
                                    width: parent.width
                                    height: parent.height

                                    Rectangle {
                                        implicitHeight: parent.height
                                        implicitWidth: 50
                                        color: "transparent"
                                        Image {
                                            anchors {
                                                centerIn: parent
                                            }
                                            width: parent.width - 10
                                            height: parent.height - 10
                                            source: Quickshell.iconPath(modelData.icon)
                                        }
                                    }

                                    Column {
                                        width: parent.width - 60
                                        height: parent.height

                                        Rectangle {
                                            implicitWidth: parent.width
                                            implicitHeight: 30
                                            color: "transparent"
                                            clip: true

                                            Text {
                                                id: deviceName
                                                text: modelData.deviceName
                                                color: "#FFFFFF"
                                                font.pixelSize: 16
                                                anchors.verticalCenter: parent.verticalCenter

                                                property bool needsScrolling: deviceName.contentWidth > parent.width
                                                SequentialAnimation {
                                                    running: deviceName.needsScrolling
                                                    loops: Animation.Infinite

                                                    PauseAnimation {duration: 1000}

                                                    NumberAnimation {
                                                        target: deviceName
                                                        property: "x"
                                                        from: 0
                                                        to: -(deviceName.contentWidth - deviceName.parent.width)
                                                        duration: 3000
                                                        easing.type: Easing.Linear
                                                    }
                                                    PauseAnimation {duration: 1000}
                                                    NumberAnimation {
                                                        target: deviceName
                                                        property: "x"
                                                        from: -(deviceName.contentWidth - deviceName.parent.width)
                                                        to: 0
                                                        duration: 1500
                                                        easing.type: Easing.Linear
                                                    }
                                                }
                                            }
                                        } 
                                    }
                                }
                            }
                        }
                    }

                    Rectangle{
                        implicitWidth: 60
                        implicitHeight: 40
                        color: "transparent"
                        anchors{
                            right: parent.right
                            bottom: parent.bottom
                        }

                        Rectangle{
                            implicitHeight: parent.height - 10
                            implicitWidth: parent.width - 10

                            radius: 10
                            color: "#89b4fa"

                            anchors{
                                centerIn: parent
                            }

                            Text{
                                text: "Scan"
                                anchors{
                                    centerIn: parent
                                }
                                color:"#E4E4E4"
                            }

                            MouseArea{
                                anchors{
                                    fill: parent
                                }
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:{
                                    Quickshell.execDetached(["bluetoothctl", "--timeout", "10", "scan", "on"])
                                }
                            }
                        }

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
