import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: utility
    width: utility.isClicked ? 300 : utility.isNotificationClicked ? 350 : row.width + 20
    height: utility.isClicked ? 550 : utility.isNotificationClicked ? 600 : 40
    anchors.right: parent.right
    property alias container: container
    property bool isClicked: false 

    property bool isWifiClicked: false
    property bool isBluetoothClicked: false
    property bool isNotificationClicked: false 

    Behavior on width{
        NumberAnimation{
            duration: 300
            easing.type: Easing.OutQuad
        }
    }
    Behavior on height{
        NumberAnimation{
            duration: 300
            easing.type: Easing.OutQuad
        }
    }


    Rectangle{
        id: container 
        anchors.fill: parent
        color: Settings.layoutColor
        bottomLeftRadius: 20 

        Loader{
            id: notificationLoader
            active: utility.isNotificationClicked
            anchors.fill: parent
            anchors.margins: 10
            visible: false
            Timer{
                interval: 200
                running: utility.isNotificationClicked
                onTriggered:{
                    notificationLoader.visible = true
                }
            }
            sourceComponent: NotificationCenter{
                id: notificationCenter
                onNotificationCenterClosed: {
                    utility.isNotificationClicked = false
                    notificationLoader.visible = false
                }
            }
        }

        Loader{
            id: dashboardLoader
            active: utility.isClicked
            anchors.fill: parent
            visible: false
            Timer{
                interval: 300
                running: utility.isClicked
                onTriggered:{
                    dashboardLoader.visible = true
                }
            }
            sourceComponent: Dashboard{
                id: dashboard
                onToggleDashboard: {
                    utility.isClicked = false
                    dashboardLoader.visible = false
                } 
                onIsWifiClickedChanged: utility.isWifiClicked = dashboard.isWifiClicked
                onIsBluetoothClickedChanged: utility.isBluetoothClicked = dashboard.isBluetoothClicked
            }
        }

        RowLayout{
            id: row
            visible: !utility.isClicked && utility.height === 40
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10

            Rectangle{
                radius: 10
                Layout.preferredWidth: child.width + child.spacing * 2
                Layout.preferredHeight: 25
                color: Colors.surfaceContainerHigh
                RowLayout{
                    id: child
                    spacing: 10
                    anchors.centerIn: parent
                    CustomIconImage{
                        size: 17
                        icon: ServiceWifi.wifiEnabled ? ServiceWifi.icon : "wifi-off"                    
                        MouseArea{
                            id: wifiArea
                            anchors.fill: parent
                            hoverEnabled: true

                        }

                        CustomToolTip{
                            content: ServiceWifi.currentSSID
                            visible: wifiArea.containsMouse
                        }
                    }

                    CustomIconImage{
                        size: 17
                        icon: ServiceBluetooth.state ? "bluetooth-on" : "bluetooth-off"

                        MouseArea{
                            id: bluetoothArea
                            anchors.fill: parent
                            hoverEnabled: true

                        }

                        CustomToolTip{
                            content: ServiceBluetooth.connectedDevices + " connected"
                            visible: bluetoothArea.containsMouse
                        }
                    }


                    CustomIconImage{
                        size: 17
                        icon: ServiceNotification.notificationsNumber > 0 ? "notification-active" : "notification"

                        MouseArea{
                            id: notificaitonArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked:{
                                utility.isNotificationClicked = true
                            }

                        }
                        CustomToolTip{
                            content: ServiceNotification.notificationsNumber + " notifications"
                            visible: notificaitonArea.containsMouse
                        }
                    }


                    CustomIconImage{
                        size: 17
                        icon: ServiceUPower.powerProfileIcon                    
                        MouseArea{
                            id: powerProfileArea
                            anchors.fill: parent
                            hoverEnabled: true

                        }
                    }
                }
            }

            Battery{
                Layout.preferredHeight: 40
            }

            Rectangle{
                Layout.preferredHeight: dashboardIcon.height + 4
                Layout.preferredWidth: dashboardIcon.width + 10
                color: Colors.surfaceContainerHighest
                radius: 8

                Behavior on scale{
                    NumberAnimation{
                        duration: 100
                    }
                }
                CustomIconImage{
                    id: dashboardIcon
                    size: 17
                    icon: "dashboard"
                    anchors.centerIn: parent
  
                }

                CustomMouseArea{
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked:{
                        utility.isClicked = true
                    }
                }
            }

        }
    }
}
