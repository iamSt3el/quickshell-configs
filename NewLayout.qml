import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.modules.utils

PanelWindow{
    id: root
    implicitWidth: 400
    implicitHeight: 400
    color: "transparent"

    Rectangle{
        id: container
        anchors.fill: parent
        radius: 10
        color: Colors.surface
        property real rate: 1

        // Fixed arc radius — does not scale with rate
        property real rounding: 20

        // Total height of the notch bump
        property real totalHeight: 80 * rate

        // Clamp like the reference: if height is too small, shrink radius to fit
        property bool flatten: totalHeight < rounding * 2
        property real radX: rounding
        property real radY: flatten ? Math.max(totalHeight / 2, 0) : rounding
        property real disX: rounding
        property real disY: radY

        // Vertical line between arcs absorbs remaining height
        property real smallDis: Math.max(0, totalHeight - radY * 2)

        Behavior on rate{
            NumberAnimation{
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        Rectangle{
            anchors.left: parent.left
            implicitWidth: 60
            implicitHeight: 30
            color: Colors.primary
            radius: 10
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(container.rate > 0.1) container.rate = 0
                }
            }
        }

        Rectangle{
            anchors.right: parent.right
            implicitWidth: 60
            implicitHeight: 30
            color: Colors.tertiary
            radius: 10
            MouseArea{
                anchors.fill: parent
                onClicked:{
                    if(container.rate < 1)container.rate = 1
                }
            }
        }


        Shape{
            preferredRendererType: Shape.CurveRenderer   

            ShapePath{
                fillColor: Colors.primary
                strokeWidth: 2
                strokeColor: "transparent"
                startX: 10; startY: container.width / 2
 
                PathLine{
                    relativeX: 10
                    relativeY: 0
                } 
                PathArc{
                    relativeX: container.disX
                    relativeY: -container.disY
                    radiusX: container.radX
                    radiusY: container.radY
                    direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: (10 * ( 1 - container.rate))
                    relativeY: -container.smallDis
                }

                PathArc{
                    relativeX: container.disX
                    relativeY: -container.disY
                    radiusX: container.radX
                    radiusY: container.radY
                }
                PathLine{
                    relativeX: container.width - container.disX * 4 - 40 - (20 * (1 - container.rate))
                    relativeY: 0
                }
                PathArc{
                    relativeX: container.disX
                    relativeY: container.disY
                    radiusX: container.radX
                    radiusY: container.radY
                }
                PathLine{
                    relativeX: (10 * ( 1 - container.rate))
                    relativeY: container.smallDis
                }
                PathArc{
                    relativeX: container.disX
                    relativeY: container.disY
                    radiusX: container.radX
                    radiusY: container.radY
                    direction: PathArc.Counterclockwise
                }
                PathLine{
                    relativeX: 10
                    relativeY: 0
                }
            }

        }
    }

}
