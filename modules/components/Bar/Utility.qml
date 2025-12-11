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
    width: utility.isClicked ? 300 : row.width + 20
    height: utility.isClicked ? utility.isWifiClicked || utility.isBluetoothClicked ? 480: (dashboardLoader.item ? dashboardLoader.item.height : 40) : 40
    anchors.right: parent.right
    property alias container: container
    property bool isClicked: false

    property bool isWifiClicked: false
    property bool isBluetoothClicked: false

    Behavior on width{
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    Behavior on height{
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    Rectangle{
        id: container 
        anchors.fill: parent
        color: Settings.layoutColor
        bottomLeftRadius: 20 
        
        Loader{
            id: dashboardLoader
            active: utility.isClicked
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            sourceComponent: Dashboard{
                id: dashboard
                onToggleDashboard: utility.isClicked = false

                onIsWifiClickedChanged: utility.isWifiClicked = dashboard.isWifiClicked
                onIsBluetoothClickedChanged: utility.isBluetoothClicked = dashboard.isBluetoothClicked
            }
        }

        RowLayout{
            id: row
            visible: !utility.isClicked && utility.height === 40
            spacing: 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10

     
            Rectangle{
                radius: 10
                Layout.preferredWidth: child.width + 10
                Layout.preferredHeight: 25
                color: Colors.surfaceContainerHigh
                RowLayout{
                    id: child
                    spacing: 10
                    anchors.centerIn: parent
                    Item{
                        id: wifi
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 40
                        IconImage{
                            anchors.centerIn: parent
                            implicitSize: parent.width
                            source: ServiceWifi.wifiEnabled ? IconUtil.getSystemIcon(ServiceWifi.icon) : IconUtil.getSystemIcon("wifi-off")                    
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Colors.surfaceText
                                Behavior on colorizationColor{
                                    ColorAnimation{
                                        duration: 200
                                    }
                                }
                                brightness: 0
                            }
                        }

                        MouseArea{
                            id: wifiArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked:{
                                utility.isClicked = true
                            }
                        }
                    }
                    Item{
                        id: bluetooth
                        Layout.preferredWidth: 20
                        Layout.preferredHeight: 40
                        IconImage{
                            anchors.centerIn: parent
                            implicitSize: parent.width
                            source: ServiceBluetooth.state ? IconUtil.getSystemIcon("bluetooth-on") : IconUtil.getSystemIcon("bluetooth-off")                    
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Colors.surfaceText
                                Behavior on colorizationColor{
                                    ColorAnimation{
                                        duration: 200
                                    }
                                }
                                brightness: 0
                            }
                        }

                        MouseArea{
                            id: bluetoothArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked:{
                                utility.isClicked = true
                            }
                        }
                    }
                    Item{
                        id: powerProfile
                        Layout.preferredWidth: 18
                        Layout.preferredHeight: 40
                        IconImage{
                            anchors.centerIn: parent
                            implicitSize: parent.width
                            source: IconUtil.getSystemIcon(ServiceUPower.powerProfileIconPath)                    
                            layer.enabled: true
                            layer.effect: MultiEffect {
                                colorization: 1.0
                                colorizationColor: Colors.surfaceText
                                Behavior on colorizationColor{
                                    ColorAnimation{
                                        duration: 200
                                    }
                                }
                                brightness: 0
                            }
                        }

                        MouseArea{
                            id: powerProfileArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true

                            onClicked:{
                                utility.isClicked = true
                            }
                        }
                    }
                }
            }

            Battery{
                //Layout.preferredWidth: 24
                Layout.preferredHeight: 40
            }

            /*Item{
                Layout.preferredWidth: 18
                Layout.preferredHeight: 40
                IconImage{
                    anchors.centerIn: parent
                    implicitSize: parent.width
                    source: IconUtil.getSystemIcon("dashboard")                    
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Colors.surfaceText
                        Behavior on colorizationColor{
                            ColorAnimation{
                                duration: 200
                            }
                        }
                        brightness: 0
                    }
                }

                MouseArea{
                    id: dashboardArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true

                    onClicked:{
                        utility.isClicked = true
                    }
                }
            }*/ 
        }
    }
}
