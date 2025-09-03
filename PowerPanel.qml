import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import qs.util

Item {

    id: root
    Colors {
        id: colors
    }

            property bool isPowerPanelVisible: false
            
            function open() {
                isPowerPanelVisible = true
                openAnimation.start()
            }
            
            function close() {
                closeAnimation.start()
            }

        PanelWindow {

            id: powerPanel

            property var buttons: ["shutdown", "reboot", "suspend"]

            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            implicitHeight: 230
            implicitWidth: 90
            visible: root.isPowerPanelVisible
            color: "transparent"

            anchors {
                right: true
            }





            // Container for both Shape and Rectangle
            Item {
                id: powerPanelContainer
                anchors.fill: parent

                // Apply transform to the entire container
                transform: Scale {
                    id: scaleTransform
                    origin.x: powerPanelContainer.width
                    origin.y: powerPanelContainer.height / 2
                    xScale: 0
                }

                // Shape background
                Shape {
                    anchors.fill: parent

                    ShapePath {
                        fillColor: "#06070e"
                        strokeWidth: 0
                        startX: powerPanel.width - 20
                        startY: 14

                        PathArc {
                            relativeX: 20
                            relativeY: -10
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }

                        PathLine {
                            relativeX: 0
                            relativeY: powerPanel.height - 9
                        }

                        PathArc {
                            relativeX: -20
                            relativeY: -10
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }

                        PathLine {
                            relativeY: -(powerPanel.height)
                            relativeX: 0
                        }
                    }
                }

                // Content rectangle (now without its own background since Shape provides it)
                Rectangle {
                    id: powerPanelRect
                    implicitWidth: 90
                    implicitHeight: 200
                    color: "#06070e"  // Made transparent since Shape provides background
                    bottomLeftRadius: 20
                    topLeftRadius: 20

                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                    }

                    Column {
                        spacing: 10

                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }

                        Repeater {
                            model: powerPanel.buttons

                            delegate: Rectangle {
                                width: 50
                                height: 50
                                color: iconArea.containsMouse ? "#48CFCB" : "#229799"
                                radius: 10

                                Behavior on color {
                                    ColorAnimation {duration: 150}
                                }

                                anchors {
                                    leftMargin: 10
                                }

                                Image {
                                    anchors {
                                        centerIn: parent
                                        margins: 4
                                    }
                                    smooth: true
                                    cache: true
                                    width: 30
                                    height: 30
                                    fillMode: Image.PreserveAspectFit
                                    sourceSize: Qt.size(width, height)
                                    source: "./assets/" + modelData + ".svg"

                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: "#F5F5F5"
                                    }
                                }

                                MouseArea {
                                    id: iconArea
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    anchors {
                                        fill: parent
                                    }
                             
                                    onClicked: {
                                        Quickshell.execDetached(["systemctl", modelData])
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
                    target: scaleTransform
                    property: "xScale"
                    from: 0
                    to: 1.0
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
            
            ParallelAnimation {
                id: closeAnimation

                NumberAnimation {
                    target: scaleTransform
                    property: "xScale"
                    from: 1.0
                    to: 0
                    duration: 200
                    easing.type: Easing.InCubic
                }
                
                onFinished: {
                    root.isPowerPanelVisible = false
                }
            }
        }
}
