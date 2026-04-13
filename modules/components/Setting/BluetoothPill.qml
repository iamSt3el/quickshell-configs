import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle {
    id: root
    implicitWidth: parent?.width
    implicitHeight: 60
    radius: 15
    color: bluetooth.state === 1 ? Colors.surfaceContainerHighest : "transparent"
    property var bluetooth: null
    visible: bluetooth !== null
    signal click(var bluetooth)


    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.click(root.bluetooth)
    }
    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 10
            //color: Colors.primary
            color: "transparent"
            // CustomIconImage {
            //     implicitSize: 30
            //     icon: bluetooth.icon
            // }

            MaterialIconSymbol{
                anchors.centerIn: parent
                content: bluetooth.icon.split("-")[1] ?? "bluetooth"
                iconSize: 30
                // color: Colors.primaryText
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            CustomText {
                content: bluetooth?.name ?? ""
                size: 14
            }
            CustomText {
                content: bluetooth?.bonded ? "Saved" : "Not Trusted"
                size: 13
                color: Colors.outline
            }
        }

        Item {
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.preferredWidth: child.width + 10
            Layout.preferredHeight: 40
            radius: 10
            color: area.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
            CustomText {
                id: child
                anchors.centerIn: parent
                content: bluetooth?.connected ? "Disconnect" : "Connect"
                size: 14
                color: area.containsMouse ? Colors.primaryText : Colors.surfaceText
            }

            MouseArea {
                id: area
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
            }
        }
    }
    
}
