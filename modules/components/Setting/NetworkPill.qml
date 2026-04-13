import Quickshell
import Quickshell.Widgets
import Quickshell.Networking
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
    color: network?.connected ? Colors.surfaceContainerHighest : "transparent"
    property var network: null
    visible: network !== null
    signal click(var network)
    signal needsPassword(var network)

    MouseArea{
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked:root.click(root.network)
    }



    Connections {
        target: root.network
        ignoreUnknownSignals: true
        function onConnectionFailed(reason) {
            if (reason === ConnectionFailReason.NoSecrets) {
                root.needsPassword(root.network)
            }
        }
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
            MaterialIconSymbol {
                anchors.centerIn: parent
                content: "android_wifi_4_bar"
                iconSize: 30
                // color: Colors.primaryText
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            CustomText {
                content: network?.name ?? ""
                size: 14
            }
            CustomText {
                content: network?.known ? "Known" : "Unknown"
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
                content: network?.connected ? "Disconnect" : "Connect"
                size: 14
                color: area.containsMouse ? Colors.primaryText : Colors.surfaceText
            }

            MouseArea {
                id: area
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true

                onClicked:{
                    if(!network?.connected){
                        //root.wrongPassword = false
                        network.connect()
                    }
                    else{
                        //root.wrongPassword = false
                        network.disconnect()
                    }
                }
            }
        }
    }
}
