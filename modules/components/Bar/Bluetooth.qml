import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services
import QtQuick.Effects

ColumnLayout{
    id: root
    anchors.fill: parent
    anchors.margins: 10
    spacing: 0
    signal backClicked

    opacity: 0

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 200
        running: true
    }

    RowLayout{
        Layout.fillWidth: true
        Layout.margins: 5
        CustomIconImage {
            size: 24
            icon: "back"
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:root.backClicked()
            }
        }

        Item {
            Layout.fillWidth: true
        }

        CustomIconImage {
            id: scanButton
            property bool isScanning
            size: 20
            icon: "refresh"


            NumberAnimation on rotation {
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
                running: scanButton.isScanning
            }

            Timer{
                id: scanTimer
                interval: 10000
                onTriggered:{
                    scanButton.isScanning = false
                }
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    parent.rotation = 0
                    if(!scanButton.isScanning){
                        scanButton.isScanning = true
                        scanTimer.start()
                        Quickshell.execDetached(["bluetoothctl", "--timeout", "10", "scan", "on"])
                    }
                }
            }
        }
    }

    RowLayout{
        Layout.margins: 5
        CustomText{
            content: "Bluetooth"
            size: 18
        }

        Item {
            Layout.fillWidth: true
        }

        CustomToogle{
            isToggleOn: ServiceBluetooth.state
            onToggled: function(state){
                if(state){
                    Quickshell.execDetached(["bluetoothctl", "power", "on"])
                }else{
                    Quickshell.execDetached(["bluetoothctl", "power", "off"])
                }
            }
        }
    }

    ClippingWrapperRectangle{
        Layout.fillHeight: true
        Layout.fillWidth: true
        radius: 10
        color: "transparent"

        ListView{
            anchors.fill: parent
            anchors.margins: 5
            anchors.centerIn: parent
            orientation: Qt.Vertical
            model: ServiceBluetooth.list
            spacing: 5

            delegate: Rectangle{
                implicitHeight: 40
                implicitWidth:  parent ? parent.width : 0
                color: modelData.state === 1 ? Colors.primary : wifiArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent"
                radius: 10

                Behavior on color{
                    ColorAnimation{
                        duration: 200
                    }
                }

                MouseArea{
                    id: wifiArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onClicked:{
                        if(modelData.connected){
                            modelData.disconnect()
                        }else{
                            modelData.connect()
                        }
                    }
                }

                RowLayout{
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10

                    CustomIconImage {
                        implicitSize: 20
                        icon: modelData.icon
                        color: modelData.state === 1 ? Colors.primaryText : Colors.surfaceText
                    }



                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        CustomText{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            size: 12
                            content: modelData.name
                            color: modelData.state === 1 ? Colors.primaryText : Colors.surfaceText
                        }

                        CustomText{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            size: 11
                            content: modelData.bonded ? "Saved" : "Not Trusted"
                            color: Colors.outline
                        }
                    }



                    Loader{
                        active: modelData.batteryAvailable

                        property string icon:{
                            let level = modelData.battery
                            if(level === 1){
                                return "battery-full"
                            }else if(level < 1 && level >= 0.9){
                                return "battery-6"
                            }else if(level < 0.9 && level >= 0.7){
                                return "battery-5"
                            }else if(level < 0.7 && level >= 0.5){
                                return "battery-4"
                            }else if(level < 0.5 && level >= 0.3){
                                return "battery-3"
                            }else if(level < 0.3 && level >= 0.2){
                                return "battery-2"
                            }else if(level < 0.2 && level >= 0){
                                return "battery-1"
                            }
                            return "battery-0"
                        }
                        sourceComponent: CustomIconImage {
                            size: 18
                            source: IconUtil.getSystemIcon(parent.icon)
                            color: modelData.state === 1 ? Colors.primaryText : Colors.surfaceText

                        }
                    }
                }
            }
        }
    }
}
