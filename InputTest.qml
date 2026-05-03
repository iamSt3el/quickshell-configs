import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.modules.utils
import "modules/MatrialShapes" as MaterialShapes
import "modules/MatrialShapes/material-shapes.js" as MaterialShapeFn

Scope {
    id: root
    property bool expanded: false

    ListModel { id: shapesModel }

    PanelWindow {
        id: panelWindow
        implicitHeight: 200
        implicitWidth: 500
        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Normal
        WlrLayershell.keyboardFocus: allow ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        color: "transparent"

        property bool allow: false

        Rectangle {
            anchors.fill: parent
            radius: 20
            color: Colors.surface

            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 400
                implicitHeight: 60
                radius: 20
                color: Colors.surfaceContainer

                TextInput {
                    id: input
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    font.pixelSize: 20
                    echoMode: TextInput.Normal
                    focus: true
                    cursorDelegate: Item {}

                    property int trackedLength: 0

                    onLengthChanged: {
                        if (length > trackedLength) {
                            for (let i = 0; i < length - trackedLength; i++)
                                shapesModel.append({})
                        } else {
                            for (let i = 0; i < trackedLength - length; i++)
                                if (shapesModel.count > 0)
                                    shapesModel.remove(shapesModel.count - 1)
                        }
                        trackedLength = length
                    }
                }

                ListView {
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 30
                    orientation: Qt.Horizontal
                    spacing: 5
                    clip: false
                    interactive: false
                    model: shapesModel

                    delegate: MaterialShapes.ShapeCanvas {
                        width: 30
                        height: 30
                        color: Colors.primary
                        roundedPolygon: MaterialShapeFn.getCircle()

                        Component.onCompleted: roundedPolygon = MaterialShapeFn.getCookie7Sided()
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 20 + shapesModel.count * 35
                    anchors.verticalCenter: parent.verticalCenter
                    width: 2
                    height: 30
                    radius: 1
                    color: Colors.primary
                    visible: input.activeFocus

                    SequentialAnimation on opacity {
                        running: input.activeFocus
                        loops: Animation.Infinite
                        NumberAnimation { to: 0; duration: 500; easing.type: Easing.InOutSine }
                        NumberAnimation { to: 1; duration: 500; easing.type: Easing.InOutSine }
                    }
                }
            }
        }

        Rectangle {
            anchors.right: parent.right
            anchors.top: parent.top
            implicitHeight: 40
            implicitWidth: 100
            radius: 20
            color: Colors.primary
            MouseArea {
                anchors.fill: parent
                onClicked: panelWindow.allow = !panelWindow.allow
            }
        }
    }
}
