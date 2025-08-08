import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland

Item{
    Rectangle{
        id: topBarWrapper
        implicitWidth: 260
        implicitHeight: 50
        color: "transparent"
        anchors{
            left: parent.left
        }

        Shape{
            ShapePath{
                fillColor: "#06070e"
                //strokeColor: "blue"
                strokeWidth: 0
                startX: 0
                startY: topBarWrapper.height

                PathArc{
                    relativeX: 20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: topBarWrapper.width - 30 
                    relativeY: -(topBarWrapper.height) + 20
                }

                PathArc{
                    relativeX: 20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }
                
                PathLine{
                    relativeX: -(topBarWrapper.width + 10)
                    relativeY: 0

                }
            }
        }

        Rectangle{
            implicitWidth: {console.log(7); return topBarWrapper.width}
            implicitHeight: 40
            color: "#06070e"
            bottomRightRadius: 20
            anchors{
            }
            Row{
                spacing: 5
                anchors{
                    //horizontalCenter: parent.horizontalCenter
                    centerIn: parent
                }
                Repeater{
                    model: Hyprland.workspaces

                    delegate: Rectangle{
                        width: modelData.focused ? 50 : 30 
                        height: 30
                        color: workspaceArea.containsMouse || modelData.focused ? "#48CFCB" : "#229799"
                        radius: workspaceArea.containsMouse ? 8 : 5

                        Behavior on color{
                            ColorAnimation {duration: 150}
                        }

                        Behavior on radius{
                            NumberAnimation {duration: 200; easing.type:Easing.OutBack}
                        }

                        Behavior on width{
                            NumberAnimation {duration: 200; easing.type:Easing.InCurve}
                        }

                        border{
                            width: 1
                            color: "#3C3D37"
                        } 
                        Text{
                            anchors{
                                centerIn: parent
                            }
                            text: modelData.id
                        }

                        MouseArea{
                            id: workspaceArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                Hyprland.dispatch("workspace " + modelData.name)
                            }
                        }
                    }
                }
            }
        }
 
    }
}
