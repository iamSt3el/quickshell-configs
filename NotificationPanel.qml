import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Shapes

Scope{
    id: notificationScope
    property var notifList: []
    
    Variants{
        model: Quickshell.screens
        PanelWindow{
            required property var modelData
            screen: modelData
            color: "transparent"
            implicitWidth: 250
            implicitHeight: Math.max(120, (notifList.length * 85) + 30)
            id: notificationPanel
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            anchors{
                top: true
                right: true
            }
            //margins.top: 80
            
            Connections {
                target: notificationScope
                function onNotifListChanged() {
                    if (notificationScope.notifList.length === 1) {
                        openAnimation.start()
                    }
                }
            }
            
            Rectangle{
                color: "transparent"
                anchors{
                    fill: parent
                }
 
                transform: Scale{
                    id: scaleTransform
                    origin.x: notificationPanel.width
                    origin.y: notificationPanel.height / 2
                    xScale: 0
                }
                Shape{
                    anchors.fill: parent
                    ShapePath{
                        fillColor: "#06070e"
                        //strokeColor: "blue"
                        strokeWidth: 0
                        startX: notificationPanel.width - 20
                        startY: 10
                        PathArc{
                            relativeX: 20
                            relativeY: -10
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }
                        PathLine{
                            relativeX: 0
                            relativeY: notificationPanel.height
                        }
                        PathArc{
                            relativeX: -20
                            relativeY: -10
                            radiusY: 15
                            radiusX: 20
                            direction: PathArc.Counterclockwise
                        }
                        PathLine{
                            relativeX: 0
                            relativeY: - (notificationPanel.height - 20)
                        }
                    }
                }
                Rectangle{
                    id: notificationRect
                    implicitWidth: parent.width
                    implicitHeight: parent.height - 20
                    color: "black"
                    //visible: false
                    topLeftRadius: 10
                    bottomLeftRadius: 10

                    /*Behavior on implicitWidth{
                        NumberAnimation{duration: 100; easing.type: Easing.OutCubic}
                    }*/
                    anchors{
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Column{
                        id: notificationWrapper
                        anchors.fill: parent
                        anchors.topMargin: 10
                        spacing: 5
                        Repeater{
                            model: notificationScope.notifList
                            delegate: Rectangle{
                                implicitHeight: 80;
                                implicitWidth: 240;
                                color: "#1E1E2E" 
                                radius: 10
                                anchors{
                                    horizontalCenter: parent.horizontalCenter
                                } 
                                transform: Scale {
                                    id: itemScaleTransform
                                    origin.x: parent.width
                                    origin.y: parent.height / 2
                                    xScale: index === 0 ? 0 : 1
                                }
                                
                                NumberAnimation {
                                    running: index === 0
                                    target: itemScaleTransform
                                    property: "xScale"
                                    from: 0
                                    to: 1
                                    duration: 200
                                    easing.type: Easing.OutCubic
                                }

                                Rectangle{
                                    color: "transparent"
                                    implicitHeight: parent.height - 6
                                    implicitWidth: parent.width - 6
                                    anchors{
                                        centerIn: parent
                                    }

                                    Column{
                                        anchors.fill: parent
                                        Row{
                                            spacing: 10

                                            width: parent.width
                                            height: 20
                                            anchors{
                                                leftMargin: 10
                                            }
                                            Image{
                                                anchors{
                                                    //verticalCenter: parent.verticalCenter
                                                }
                                                width: 20
                                                height: 20
                                                source: modelData.image
                                            }
                                            Text{
                                                text: modelData.appName
                                                color: "#FFFFFF"
                                                font.pixelSize: 12
                                            }
                                        }

                                        Rectangle{
                                            width: parent.width
                                            height: 20
                                            color: "transparent"
                                            Text{
                                                text: modelData.summary
                                                color: "#FFFFFF"
                                                font.pixelSize: 16
                                            }
                                        }

                                        Rectangle{
                                            width: parent.width
                                            height: 40
                                            color: "transparent"
                                            Text{
                                                text: modelData.body
                                                color: "#FFFFFF"
                                                font.pixelSize: 14
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            ParallelAnimation{
                id: openAnimation
                NumberAnimation{
                    target: scaleTransform
                    property: "xScale"
                    from: 0
                    to: 1.0
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}
