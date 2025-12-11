import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services
import qs.modules.settings

Item{
    id: root 
    width: parent.width
    height: col.implicitHeight + 20
    property bool isWifiClicked: false
    property bool isBluetoothClicked: false
    opacity: 0

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 200
        running: true
    }


    signal toggleDashboard

    ColumnLayout{
        id: col
        //width: parent.width
        anchors.fill: parent
        spacing: 10
        anchors.margins: 10

        Rectangle{
            Layout.preferredHeight: 50
            Layout.fillWidth: true
            color: Colors.surfaceContainer
            radius: 20
            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                anchors.rightMargin: 10
                spacing: 10

                ClippingWrapperRectangle{
                    Layout.preferredWidth: 30
                    Layout.preferredHeight: 30
                    radius: height
                    color: "transparent"

                    border{
                        width: 1
                        color: Colors.outline
                    }

                    Image{
                        anchors.fill: parent
                        sourceSize: Qt.size(width, height)
                        source: Settings.profile
                    }
                }

                ColumnLayout{
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    spacing: 0
                    CustomText{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        content: "St3el"
                        size: 14
                    }
                    CustomText{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        content: "uptime " + ServiceSystemInfo.getUptime()

                        size: 13
                        color: Colors.outline
                    }
                }

                CustomIconImage{
                    icon: "setting"
                    size: 18
                }
                CustomIconImage{
                    icon: "power"
                    size: 18
                }
                CustomIconImage{
                    icon: "close"
                    size: 18
                    MouseArea{
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: root.toggleDashboard()
                    }
                }


            }
        }
        
        Rectangle{
            Layout.preferredHeight: root.isWifiClicked || root.isBluetoothClicked ? row.implicitHeight + 20 + 200 : row.implicitHeight + 20
            Layout.fillWidth: true
            color: Colors.surfaceContainer
            radius: 20

            Behavior on Layout.preferredHeight{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            RowLayout{
                id: row
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                visible: !root.isWifiClicked && !root.isBluetoothClicked

                ColumnLayout{
                    Layout.fillHeight: true
                    spacing: 10
                    Rectangle{
                        Layout.preferredHeight: 60
                        Layout.fillWidth: true
                        radius: 20
                        color: Colors.surfaceContainerHighest

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5

                            Rectangle{
                                Layout.fillHeight: true
                                Layout.preferredWidth: 60
                                radius: 15
                                color: Colors.primary

                                CustomIconImage{
                                    anchors.centerIn: parent
                                    size: 28
                                    icon: ServiceWifi.icon
                                    color: ServiceWifi.wifiEnabled ? Colors.primaryText : Colors.surfaceVariantText
                                }
                            }

                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                spacing: 5
                                CustomText{
                                    Layout.fillWidth: true
                                    content: ServiceWifi.connectionType
                                    size: 14
                                    weight: 700
                                }

                                CustomText{
                                    Layout.fillWidth: true
                                    content: ServiceWifi.currentSSID || "no device"
                                    size: 12
                                    weight: 600
                                    color: Colors.outline
                                }
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked:{
                                root.isWifiClicked = true
                            }
                        }
                    
                    }
                    Rectangle{
                        Layout.preferredHeight: 60
                        Layout.fillWidth: true
                        radius: 20
                        color: Colors.surfaceContainerHighest

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5

                            Rectangle{
                                Layout.fillHeight: true
                                Layout.preferredWidth: 60
                                radius: 15
                                color: Colors.primary


                                CustomIconImage{
                                    anchors.centerIn: parent
                                    size: 28
                                    icon: ServiceBluetooth.connectedDevices > 0 ? "bluetooth-on" : "bluetooth-off"
                                    color: Colors.primaryText
                                }
                            }

                            ColumnLayout{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                spacing: 5
                                CustomText{
                                    Layout.fillWidth: true
                                    content: "Bluetooth"
                                    size: 14
                                    weight: 700
                                }

                                CustomText{
                                    Layout.fillWidth: true
                                    content: ServiceBluetooth.connectedDevices + " connected"
                                    size: 12
                                    weight: 600
                                    color: Colors.outline
                                }
                            }
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked:{
                                root.isBluetoothClicked = true
                            }
                        }
                    }

                    Rectangle{
                        Layout.preferredHeight: 40
                        Layout.fillWidth: true
                        radius: 20
                        color: Colors.surfaceContainerHighest

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5

                            Repeater{
                                model: ServiceUPower.powerProfiles

                                Rectangle{
                                    property bool active: ServiceUPower.powerProfile === index
                                    Layout.fillHeight: true
                                    Layout.fillWidth: true
                                    radius: 20
                                    color: active ? Colors.primary : profileArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) :"transparent"

                                    CustomIconImage{
                                        anchors.centerIn: parent
                                        size: 20
                                        icon: modelData.icon
                                        color: parent.active ? Colors.primaryText : Colors.surfaceVariantText
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 200
                                        }
                                    }

                                    MouseArea{
                                        id: profileArea
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true
                                        onClicked:{
                                            ServiceUPower.setPowerProfile(index)
                                        }
                                    }
                                }
                            }

                        }
                    }
                }

                CustomSlider{
                    Layout.fillHeight: true
                    icon: "volume"
                    progress: ServicePipewire.volume
                    onProgressChanged:{
                        ServicePipewire.updateVolume(progress)
                    }

                }
                CustomSlider{
                    Layout.fillHeight: true
                    icon: "brightness"
                    progress: 0.5
                }
            }

            Loader{
                active: root.isWifiClicked
                anchors.fill: parent
                sourceComponent: Wifi{
                    onBackClicked: root.isWifiClicked = false
                }
            }

            Loader{
                active: root.isBluetoothClicked
                anchors.fill: parent
                sourceComponent: Bluetooth{
                    onBackClicked: root.isBluetoothClicked = false
                }
            }
        }
    }

    
    
}
