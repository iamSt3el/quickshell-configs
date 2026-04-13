import Quickshell
import Quickshell.Widgets
import Quickshell.Bluetooth
import Quickshell.Networking
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle{
    id: root
    anchors.fill: parent
    color: Qt.alpha(Colors.surface, 0.5)
    radius: 20
    z: 10
    signal close
    property var network

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true
        onClicked: mouse => mouse.accepted = true
    }


    Rectangle{
        anchors.centerIn: parent
        implicitHeight: 400 
        implicitWidth: 400 
        radius: 20
        color: Colors.surfaceContainer
        z: 20

        NumberAnimation on scale{
            from: 0.7
            to: 1
            duration: 300
            easing.type: Easing.OutQuad
        }

        MaterialIconSymbol{
            content: "close"
            iconSize: 24
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 10
            anchors.topMargin: 10

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.close()
            }
        }

        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10

            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 80

                Rectangle{
                    anchors.centerIn: parent
                    implicitHeight: 50
                    implicitWidth: 50
                    radius: height
                    color: Qt.alpha(Colors.primary, 0.8)

                    MaterialIconSymbol{
                        anchors.centerIn: parent
                        content: "wifi"
                        iconSize: 30
                        color: Colors.primaryText
                    }
                }
            }

            CustomText{
                Layout.alignment: Qt.AlignCenter
                content: network?.name ?? ""
                size: 16
            }

            CustomText{
                Layout.alignment: Qt.AlignCenter
                content: network?.connected ? "Connected" : "Not Connected"
                size: 12
                color: Colors.primary
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.topMargin: 10
                CustomText{
                    content: "Signal Strength"
                    size: 14
                    color: Colors.outline
                }
                Item{
                    Layout.fillWidth: true
                }

                CustomText{
                    content: Math.floor(network?.signalStrength * 100) + " %"          
                    size: 14
                }
            }
            RowLayout{
                Layout.topMargin: 10
                Layout.fillWidth: true
                CustomText{
                    content: "Security Type"
                    size: 14
                    color: Colors.outline
                }
                Item{
                    Layout.fillWidth: true
                }

                CustomText{
                    content:  WifiSecurityType.toString(network?.security)      
                    size: 14
                }
            }
            RowLayout{
                Layout.topMargin: 10
                Layout.fillWidth: true
                CustomText{
                    content: "Known"
                    size: 14
                    color: Colors.outline
                }
                Item{
                    Layout.fillWidth: true
                }

                CustomText{
                    content: network?.known              
                    size: 14
                }
            }
            Item{
                Layout.fillHeight: true
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.maximumHeight: 40
                Rectangle{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 10
                    color: Colors.error
                    CustomText{
                        anchors.centerIn: parent
                        content: "Forgot"
                        size: 14
                        color: network.known ? Colors.errorText : Colors.tertiaryText
                    }

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: network.known ? Qt.PointingHandCursor : Qt.ForbiddenCursor
                        onClicked:{
                            if(network.known){
                                network.forget()
                            }
                        }
                    }
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 10
                    color: Colors.surfaceContainerHighest
                    CustomText{
                        anchors.centerIn: parent
                        content: network?.connected ? "Disconnect" : "Connect"
                        size: 14
                    }

                     MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }
    }
}
