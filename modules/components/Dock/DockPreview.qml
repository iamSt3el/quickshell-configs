import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.settings

PopupWindow {
    id: root
    readonly property int cardWidth: 180
    readonly property int cardSpacing: 6
    readonly property int layoutMargins: 10

    implicitWidth: appEntry
        ? appEntry.toplevels.length * (cardWidth + cardSpacing) - cardSpacing + layoutMargins * 2
        : cardWidth + layoutMargins * 2
    implicitHeight: 170
    visible: true
    color: "transparent"

    property point anchorPoint: Qt.point(0, 0)
    property var appEntry: null

    signal hoverEntered
    signal hoverExited

    HoverHandler {
        onHoveredChanged: hovered ? root.hoverEntered() : root.hoverExited()
    }

    anchor {
        window: panelWindow
        rect: Qt.rect(anchorPoint.x + 20, anchorPoint.y - 15, 1, 1)
        gravity: Edges.Top
        edges: Edges.Bottom
    }

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Colors.surface

        NumberAnimation on opacity {
            from: 0
            to: 1
            duration: 100
        }

        NumberAnimation on scale {
            from: 0.8
            to: 1
            duration: 100
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: root.layoutMargins
            spacing: root.cardSpacing

            Repeater {
                model: root.appEntry.toplevels

                delegate: Rectangle {
                    id: card
                    required property var modelData
                    Layout.fillHeight: true
                    Layout.preferredWidth: root.cardWidth
                    color: Colors.surfaceContainerHigh
                    radius: 10
                    layer.enabled: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.modelData.activate()
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 4

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            CustomText {
                                Layout.fillWidth: true
                                content: card.modelData.title ?? ""
                                size: 11
                                weight: 600
                            }

                            Rectangle {
                                width: 20
                                height: 20
                                radius: 10
                                color: closeArea.containsMouse ? Colors.surfaceVariant : "transparent"

                                MaterialIconSymbol {
                                    anchors.centerIn: parent
                                    content: "close"
                                    iconSize: 14
                                }

                                MouseArea {
                                    id: closeArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: card.modelData.close()
                                }
                            }
                        }

                        ScreencopyView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            captureSource: root.visible ? card.modelData : null
                            live: true
                            paintCursor: false
                            constraintSize: Qt.size(root.cardWidth, 120)
                        }
                    }
                }
            }
        }
    }
}
