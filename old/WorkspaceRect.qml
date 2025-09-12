import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util
import QtQuick.Effects

Item{
    id: workspacesItem
    anchors.left: parent.left
    width: wrapper.width + 20
    height: parent.height

    
        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          blurMax: 15
          shadowColor: Qt.alpha(colors.shadow, 1)
        }
          

    

    
    Colors {
        id: colors
    }

    Shape{
        preferredRendererType: Shape.CurveRenderer
        ShapePath{
            fillColor: colors.surfaceContainer
            strokeWidth: 0
            startX: workspacesItem.width
            startY: 0

            PathArc{
                relativeX: -20
                relativeY: 10
                radiusX: 20
                radiusY: 15
                direction: PathArc.Counterclockwise
            }
            PathLine{
                relativeX: -workspacesItem.width + 40
                relativeY: 30
            }
            PathArc{
                relativeX: -20
                relativeY: 10
                radiusX: 20
                radiusY: 15
                direction: PathArc.Counterclockwise
            }
            PathLine{
                relativeY: -workspacesItem.height
                relativeX: 0
            }
        }
    }
    Rectangle{
        id: wrapper
        implicitWidth: workspacesRow.width + 20
        implicitHeight: 40
        bottomRightRadius: 20
        color: colors.surfaceContainer

        Rectangle{
            anchors.centerIn: parent
            implicitWidth: workspacesRow.width + 10
            implicitHeight: parent.height
            radius: 10
            //color: "#44444E"
            color: "transparent"
            ListView{
                id: workspacesRow
                width: contentWidth
                height: parent.height - 10 
                orientation: Qt.Horizontal
                anchors.centerIn: parent
                spacing: 10
                interactive: false
                
                model: Hyprland.workspaces

                    delegate: Rectangle{
                        implicitWidth: Math.max(40, (modelData.toplevels.values.length * 24) + 20) 
                        implicitHeight: 25
                        color: modelData.focused ? colors.primaryContainer : colors.surfaceVariant 
                        //radius: 10
                        topLeftRadius: 30
                        bottomRightRadius: 30
                        topRightRadius: 5
                        bottomLeftRadius: 5

                     

                        Behavior on color{
                            ColorAnimation {duration: 100}
                        }

                        Behavior on implicitWidth{
                            NumberAnimation{duration: 200; easing.type: Easing.OutQuad}
                        }

                        Text{
                            visible: false
                            font.pixelSize: 16
                            text: modelData.id
                            color: colors.surfaceText
                            anchors.centerIn: parent
                        }

                        Item{
                            anchors.fill: parent
                        Rectangle{
                            x: -5
                            y: 10
                            implicitHeight: 20
                            implicitWidth: 20
                            color: colors.tertiaryContainer
                            radius: 30
                        
                            Text{
                                text: modelData.id
                                font.pixelSize: 12
                                anchors.centerIn: parent
                                color: colors.tertiaryContainerText
                                font.weight: 800
                            }
                        }
                        

                        ListView{
                            id: appRow
                            //width: Math.max(20, contentWidth)
                            width: parent.width
                            height: parent.height - 5
                            orientation: Qt.Horizontal
                            //anchors.centerIn: parent
                            anchors.leftMargin: 15
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            spacing: 4
                            interactive: false
                            //layoutDirection: Qt.LeftToRight

                            add: Transition { 
                                ParallelAnimation {
                                    NumberAnimation{
                                        property: "opacity"
                                        from: 0
                                        to: 1
                                        duration: 300
                                        easing.type: Easing.OutBack
                                    }
                                    NumberAnimation{
                                        property: "scale"
                                        from: 0.3
                                        to: 1.0
                                        duration: 300
                                        easing.type: Easing.OutBack
                                    }
                                    NumberAnimation{
                                        property: "y"
                                        from: -10
                                        to: 0
                                        duration: 300
                                        easing.type: Easing.OutBack
                                    }
                                }
                            }

                        
                            
                            model: modelData.toplevels

                                delegate: Rectangle{
                                    implicitHeight: 20
                                    implicitWidth: 20
                                    color: "transparent"

                                    Component.onCompleted:{
                                        Hyprland.refreshToplevels()
                                    }


                                    Image{
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(width, height)
                                        source: IconUtils.getIconPath(modelData.lastIpcObject.class)
                                        anchors.centerIn: parent
                                    }
                                }
                        }

                        MouseArea{
                            id: workspacesArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked:{
                                modelData.activate()
                            }
                        }
                    }
                }
            }
        }
    }
}
