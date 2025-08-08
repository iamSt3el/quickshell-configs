import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

Scope{
    id: root
    Variants{
        model: Quickshell.screens

        PanelWindow{
            required property var modelData
            screen: modelData


            id: powerPanel

            property bool isPowerPanelVisible: true
            property var buttons: ["shutdown", "reboot", "suspend"]

            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            implicitHeight: 230 
            implicitWidth: isPowerPanelVisible ? 120 : 20
            visible: true
            color: "transparent"

            anchors{
                right: true
            }

            // Timer to hide the powePanel after mouse leave
            
            Timer{
                id: powerPanelTimer
                interval: 800
                running: true
                onTriggered: {
                    powerPanel.isPowerPanelVisible = false
                }
            }

            MouseArea{
                id: powerPanelArea
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    powerPanelTimer.stop();
                    powerPanel.isPowerPanelVisible = true
                }

                onExited: {
                    powerPanelTimer.start()
                }
            }

            Rectangle{
                id: powerPanelRect
                implicitWidth: 90
                implicitHeight: 200
                color: "#06070e"
                bottomLeftRadius: 20
                topLeftRadius: 20
                visible: powerPanel.isPowerPanelVisible
               

                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                
                Column{
                    spacing: 10

                    anchors{
                        verticalCenter: parent.verticalCenter
                        horizontalCenter: parent.horizontalCenter
                    }

                    Repeater{
                        model: powerPanel.buttons

                        delegate: Rectangle{
                            width: 50
                            height: 50
                            color: iconArea.containsMouse ? "#48CFCB" : "#229799"
                            radius: 10


                            anchors{
                                leftMargin: 10
                            }

                            Image{
                                anchors{
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
                                layer.effect: ColorOverlay{
                                    color: "#F5F5F5"
                                }
                            }

                            MouseArea{
                                id: iconArea
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                anchors{
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

            Shape{
                visible: powerPanel.isPowerPanelVisible


                ShapePath{
                    fillColor: "#06070e"
                    strokeWidth: 0
                    startX: powerPanel.width - 20
                    startY: 14

                    PathArc{
                        relativeX: 20
                        relativeY: -10
                        radiusX: 20
                        radiusY: 15
                        direction: PathArc.Counterclockwise
                    }

                    PathLine{
                        relativeX: 0
                        relativeY: powerPanel.height - 9
                    }

                    PathArc{
                        relativeX: -20
                        relativeY: -10
                        radiusX: 20
                        radiusY: 15
                        direction: PathArc.Counterclockwise
                    }

                    PathLine{
                        relativeY: -(powerPanel.height)
                        relativeX: 0
                    }
                }
            }
        }
    }
}
