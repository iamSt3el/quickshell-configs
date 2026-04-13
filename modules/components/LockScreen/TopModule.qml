import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.settings
import qs.modules.customComponents
import qs.modules.components.Widgets
import qs.modules.services 
import QtQuick.Shapes
Item{
    implicitWidth: 600
    implicitHeight: 200
    Shape {
        id: bgShape
        z: 1
        preferredRendererType: Shape.CurveRenderer

        readonly property real w: container.width
        readonly property real h: container.height
        readonly property real bodyLeft: container.x
        readonly property real bodyRight: container.x + w
        readonly property real bodyTop: container.y
        readonly property real bodyBottom: container.y + h

        readonly property real rounding: Math.min(20, h / 3, w / 3)

        readonly property real flareX: w / 18
        readonly property bool flattenFlare: h < flareX * 2
        readonly property real flareY: flattenFlare ? Math.max(0, h / 2) : flareX
        readonly property real flareRadiusY: Math.min(flareX, Math.max(0, h))

        ShapePath {
            strokeWidth: -1
            fillColor: Settings.layoutColor

            startX: bgShape.bodyLeft - bgShape.flareX
            startY: bgShape.bodyTop

            PathArc {
                x: bgShape.bodyLeft
                y: bgShape.bodyTop + bgShape.flareY
                radiusX: bgShape.flareX
                radiusY: bgShape.flareRadiusY
                direction: PathArc.Clockwise
            }

            PathLine {
                x: bgShape.bodyLeft
                y: bgShape.bodyBottom - bgShape.rounding
            }

            PathArc {
                x: bgShape.bodyLeft + bgShape.rounding
                y: bgShape.bodyBottom
                radiusX: bgShape.rounding
                radiusY: Math.min(bgShape.rounding, bgShape.h)
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: bgShape.bodyRight - bgShape.rounding
                y: bgShape.bodyBottom
            }

            PathArc {
                x: bgShape.bodyRight
                y: bgShape.bodyBottom - bgShape.rounding
                radiusX: bgShape.rounding
                radiusY: Math.min(bgShape.rounding, bgShape.h)
                direction: PathArc.Counterclockwise
            }

            PathLine {
                x: bgShape.bodyRight
                y: bgShape.bodyTop + bgShape.flareY
            }

            PathArc {
                x: bgShape.bodyRight + bgShape.flareX
                y: bgShape.bodyTop
                radiusX: bgShape.flareX
                radiusY: bgShape.flareRadiusY
                direction: PathArc.Clockwise
            }

            PathLine {
                x: bgShape.bodyLeft - bgShape.flareX
                y: bgShape.bodyTop
            }
        }
    }
    Item{
        id: container
        z: 10
        implicitWidth: 500
        //implicitHeight: child.start ? 200 : 0
        //visible: child.start ? true : false
        implicitHeight: 200
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        Behavior on implicitHeight{
            NumberAnimation{
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        onVisibleChanged:{
            if(!visible){
                row.visible = false
            }
        }

        Timer{
            id: timer
            interval: 300
            running: child.start
            onTriggered:{
                row.visible = true
            }
        }
    }
}
