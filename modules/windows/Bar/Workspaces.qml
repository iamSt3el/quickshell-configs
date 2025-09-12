import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs.modules.util
import qs.modules.services
import qs.modules.components

Item{
    id: wrapper
    anchors.left: parent.left
    width: container.width
    height: parent.height

    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 1.0
        shadowColor: Qt.alpha(Colors.shadow, 1)
    }
   Shape{
        preferredRendererType: Shape.CurveRenderer
        ShapePath{
            fillColor: Colors.surfaceContainer
            strokeWidth: 0

            startX: container.width + 20  
            startY: 0

            PathArc{
                relativeX: -Dimensions.position.x
                relativeY: Dimensions.position.y 
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
                direction: PathArc.Counterclockwise
             }
             PathLine{
               relativeX: -container.width + 20
               relativeY: 0
           }
           PathLine{
               relativeX: 0
               relativeY: container.height - 10
           }
            PathArc{
                relativeX: -Dimensions.position.x
                relativeY: Dimensions.position.y
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
                direction: PathArc.Counterclockwise
            }
            PathLine{
                relativeX: 0
                relativeY: -container.height - 10
            }
        }
    }
    
    Rectangle{
        id: container
        implicitWidth: workspacesRow.width + 20
        implicitHeight: 40
        bottomRightRadius: 20
        color: Colors.surfaceContainer

        ListView{
            id: workspacesRow
            width: contentWidth
            height: parent.height - 10
            orientation: Qt.Horizontal
            anchors.centerIn: parent
            spacing: 10
            interactive: false

            model: ServiceWorkspace.workspaces


            delegate: Rectangle{
                implicitWidth: Math.max(40, (modelData.toplevels.values.length * 24) + 20)
                implicitHeight: 25
                color: modelData.focused ? Colors.primaryContainer : Colors.surfaceVariant
                topLeftRadius: 30
                bottomRightRadius: 30
                topRightRadius: 5
                bottomLeftRadius: 5

                Behavior on color{
                    ColorAnimation{duration: 100}
                }

                Behavior on implicitWidth{
                    NumberAnimation{
                        duration: 200;
                        easing.type: Easing.OutQuad
                    }
                }

                TopLevels{}

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: modelData.activate()
                }
            }
        }
    }
}
