import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util
import Qt5Compat.GraphicalEffects

Item{
    id: workspacesItem
    anchors.left: parent.left
    width: wrapper.width + 20
    height: parent.height
    
    WindowInfoProvider {
        id: windowInfoProvider
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
            implicitHeight: workspacesRow.height + 4
            radius: 10
            //color: "#44444E"
            color: "transparent"
            Row{
                id: workspacesRow
                width: Hyprland.workspaces.length * 40
                anchors.centerIn: parent
                spacing: 10

                Repeater{
                    model: Hyprland.workspaces

                    delegate: Rectangle{
                        implicitWidth: Math.max(30, appRow.width + 20) 
                        implicitHeight: 25
                        color: modelData.focused ? colors.primaryContainer : colors.surfaceVariant 
                        radius: 10
                     

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

                        
                        Rectangle{
                            anchors.left: parent.left
                            implicitHeight: 25
                            implicitWidth: 12
                            color: colors.primaryContainer
                            topLeftRadius: 10
                            bottomLeftRadius: 5

                            Text{
                                text: modelData.id
                                font.pixelSize: 12
                                anchors.centerIn: parent
                                color: colors.surfaceText
                            }
                        }
                        

                        Row{
                            id: appRow
                            width: modelData.toplevels.length
                            anchors.rightMargin: 5
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            spacing: 4
                         
                            Repeater{
                                model: modelData.toplevels

                                delegate: Rectangle{
                                    implicitHeight: 20
                                    implicitWidth: 20
                                    color: "transparent"

                                    property string appClass: ""

                                    Component.onCompleted:{
                                        windowInfoProvider.getAppClass(modelData.address)
                                    }

                                    Connections {
                                        target: windowInfoProvider
                                        function onAppClassRetrieved(address, retrievedAppClass) {
                                            if (address === modelData.address) {
                                                appClass = retrievedAppClass
                                            }
                                        }
                                    }

                                    Image{
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(width, height)
                                        source: IconUtils.getIconPath(appClass)
                                        anchors.centerIn: parent
                                    }
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
