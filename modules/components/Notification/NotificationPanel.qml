import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: root
    implicitHeight: notifications.length > 0 ? innerItem.height + 10 : 0
    implicitWidth: 400
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    clip: true

    Behavior on implicitHeight{
        NumberAnimation{
            easing.type: Easing.OutQuad
            duration: 300
        }
    }

    property var notifications: ServiceNotification.popups
    property real disX: 18
    property real disY: 18
    property real radX: 18
    property real radY: 18

    Shape{
        preferredRendererType: Shape.CurveRenderer
        visible: root.height > 0
        ShapePath{
            strokeWidth: 2
            strokeColor: "transparent"
            fillColor: Colors.surface
            startX: 0
            startY: root.height

            PathArc{
                relativeX: root.disX
                relativeY: -root.disY
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: 0
                relativeY: - (root.height - 3 * root.disY)
            }

            PathArc{
                relativeX: root.disX
                relativeY: -root.disY
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                relativeX: root.width - 3 * root.disX
                relativeY: 0
            }

            PathArc{
                relativeX: root.disX
                relativeY: -root.disY
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: 0
                relativeY: root.height
            }

        }
    }

    Item{
        id: innerItem
        width: 380
        height: list.contentHeight + 20
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 10

        ListView{
            id: list
            anchors.fill: parent
            anchors.margins: 10
            orientation: Qt.Vertical
            model: ScriptModel{
                values: [...root.notifications].reverse()
            }
            spacing: 10
            interactive: false

            delegate: Rectangle{
                id: popup
                width: list.width
                implicitHeight: 80
                radius: 20
                color: Colors.surfaceContainerHigh
            }

        }
    }
}
