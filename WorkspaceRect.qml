import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland

Item{
    Rectangle{
        id: topBarWrapper
        //implicitWidth: 390
        implicitWidth: rect.width
        implicitHeight: 50
        color: "transparent"
        anchors{
            left: parent.left
        }

        Shape{
            preferredRendererType: Shape.CurveRenderer
            ShapePath{
                fillColor: "#06070e"
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
                    relativeX: topBarWrapper.width - 20 
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
                    relativeX: -(topBarWrapper.width + 20)
                    relativeY: 0
                }
            }
        }

        Rectangle{
            id: rect
            //implicitWidth: topBarWrapper.width
            implicitWidth: row.width + 20
            implicitHeight: 40
            color: "#11111b"
            bottomRightRadius: 20
            anchors{
            }
            Row{
                id: row
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
                        color: workspaceArea.containsMouse || modelData.focused ? "#74c7ec" : "#1E1E2E"
                        radius: workspaceArea.containsMouse ? 8 : 5

                        Behavior on color{
                            ColorAnimation {duration: 150}
                        }

                        Behavior on radius{
                            NumberAnimation {duration: 200; easing.type:Easing.Bezier}
                        }

                        Behavior on width{
                            NumberAnimation {duration: 200; easing.type:Easing.Bezier}
                        }

                        border{
                            width: 1
                            color: "#45475A"
                        } 
                        Text{
                            anchors{
                                centerIn: parent
                            }
                            text: modelData.id
                            color: "#cdd6f4"
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
