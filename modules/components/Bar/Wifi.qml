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

    RowLayout{
        Layout.fillWidth: true
        Layout.margins: 5
        CustomIconImage{
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
            size: 20
            icon: "refresh"
            NumberAnimation on rotation {
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
                running: ServiceWifi.wifiScanning
            }
            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:ServiceWifi.scanNetworks()
            }
        }
    }

    RowLayout{
        Layout.margins: 5
        CustomText{
            content: "Wi-fi"
            size: 18
        }

        Item {
            Layout.fillWidth: true
        }

        CustomToogle{
            isToggleOn: ServiceWifi.wifiEnabled
            onToggled: ServiceWifi.toggleWifi()
        }
    }

    ClippingWrapperRectangle{
        Layout.fillWidth: true
        Layout.fillHeight: true
        radius: 10
        color: "transparent"

        ListView{
            anchors.fill: parent
            anchors.margins: 5
            anchors.centerIn: parent
            orientation: Qt.Vertical
            model: ServiceWifi.availableNetworks
            spacing: 5

            delegate: Rectangle{
                implicitHeight: 40
                implicitWidth: parent ? parent.width : 0
                color: modelData.active ? Colors.primary : wifiArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent"
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
                        if(modelData.active){
                            ServiceWifi.disconnect()
                        }else{
                            ServiceWifi.connect(modelData.ssid)
                        }
                    }
                }

                RowLayout{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    CustomIconImage {
                        property string batteryIcon: {
                            let signal = modelData.signal
                            if(signal >= 90){
                                return "wifi-full"
                            }
                            else if(signal < 90 && signal >=60){
                                return "wifi-3"
                            }else if(signal < 60 && signal >= 30){
                                return "wifi-2"
                            }
                            return "wifi-1"
                        }

                        implicitSize: 20
                        icon: batteryIcon
                        color: modelData.active ? Colors.primaryText : Colors.surfaceVariantText
                    }



                    ColumnLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10
                        CustomText{
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            size: 12
                            content: modelData.ssid
                            color: modelData.active ? Colors.primaryText : Colors.surfaceVariantText
                        }

                        CustomText{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: modelData.active
                            content: modelData.active ? "Connected" : ""
                            color: Colors.outline
                        }
                    }



                    Loader{
                        active: modelData.isSecure
                        sourceComponent: CustomIconImage {
                            size: 18
                            icon: "lock"
                            color: modelData.ssid === ServiceWifi.currentSSID ? Colors.primaryText : Colors.surfaceVariantText

                        }

                    }
                }
            }

        }
    }
}

