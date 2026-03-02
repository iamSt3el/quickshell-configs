import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.customComponents
import Quickshell.Hyprland
import qs.modules.utils
import qs.modules.settings
import qs.modules.services

PopupWindow {
    id: root

    property var appEntry: null

    implicitWidth: 120
    implicitHeight: menuCol.implicitHeight + 10
    color: "transparent"

    signal close

    anchor {
        window: panelWindow
        edges: Edges.Top
        gravity: Edges.Top
    }

    HyprlandFocusGrab {
        active: true
        windows: [QsWindow.window]
        onCleared: root.close()
    }



    Rectangle {
        anchors.fill: parent
        color: Colors.surface
        radius: 10
        clip: true

        ColumnLayout {
            id: menuCol
            anchors.fill: parent
            anchors.margins: 5
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                radius: 10
                color: pinArea.containsMouse ? Colors.surfaceVariant : "transparent"

                CustomText {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    content: ServiceApps.isPinnedById(root.appEntry?.appId ?? "") ? "Unpin from dock" : "Pin to dock"
                }

                MouseArea {
                    id: pinArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        ServiceApps.togglePinById(root.appEntry?.appId ?? "")
                        root.visible = false
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true 
                Layout.preferredHeight: 40
                radius: 10
                visible: (root.appEntry?.toplevels.length ?? 0) > 0
                color: closeArea.containsMouse ? Colors.surfaceVariant : "transparent"

                CustomText {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    content: (root.appEntry?.toplevels.length ?? 0) > 1 ? "Close all" : "Close"
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        for (const t of root.appEntry?.toplevels ?? [])
                        t.sendClose()
                        root.visible = false
                    }
                }
            }
        }
    }
}
