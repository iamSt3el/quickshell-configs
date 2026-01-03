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
    property bool isWifiSettingClicked: false
    property var wifiDetailsData

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
        CustomIconImage{
            size: 24
            icon: "back"

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    if(root.isWifiSettingClicked){
                        root.isWifiSettingClicked = false
                    }else{
                        root.backClicked()
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        CustomIconImage {
            visible: !root.isWifiSettingClicked
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
    Item {
        visible: root.isWifiSettingClicked
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 10

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                radius: height / 2
                color: Qt.alpha(Colors.primary, 0.3)

                CustomIconImage {
                    anchors.centerIn: parent
                    icon: "wifi-full"
                    size: 20
                    color: Colors.primary
                }
            }

            CustomText {
                Layout.alignment: Qt.AlignHCenter
                content: root.wifiDetailsData ? root.wifiDetailsData.ssid : ""
                size: 14
                color: Colors.surfaceText
            }

            CustomText {
                Layout.alignment: Qt.AlignHCenter
                content: root.wifiDetailsData && root.wifiDetailsData.active ? "Connected" : "Not Connected"
                size: 12
                color: Colors.primary
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Signal Strength"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? root.wifiDetailsData.signal + "%" : ""
                    size: 12
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Frequency"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? root.wifiDetailsData.band: ""
                    size: 12
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Security"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? root.wifiDetailsData.security : ""
                    size: 12
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "MAC Address"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? "44:22:2R:F4:R3:23" : ""
                    size: 12
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Mode"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? root.wifiDetailsData.mode: ""
                    size: 12
                }
            }



            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Speed"
                    size: 12
                    color: Colors.outline
                }
                CustomText{
                    content: root.wifiDetailsData ? root.wifiDetailsData.rate: ""
                    size: 12
                }
            }

            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true
            }



            Rectangle{
                visible: root.wifiDetailsData && root.wifiDetailsData.active ? false : true 
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                radius: 10
                color: Qt.alpha(Colors.primary, 0.8)


                CustomText{
                    anchors.centerIn: parent
                    content: "Connect Network"
                    size: 13
                    color: Colors.primaryText
                }
            }

            Rectangle{
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                radius: 10
                color: Qt.alpha(Colors.errorContainer, 0.3)

                CustomText{
                    anchors.centerIn: parent
                    content: "Forget Network"
                    size: 13
                    color: Colors.error
                }
            }

        }
    }


    RowLayout{
        visible: !root.isWifiSettingClicked
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
        visible: !root.isWifiSettingClicked
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
                        color: modelData.active ? Colors.primaryText : Colors.surfaceText
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
                            color: modelData.active ? Colors.primaryText : Colors.surfaceText
                        }

                        CustomText{
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            visible: modelData.active
                            content: modelData.active ? "Connected" : ""
                            color: Colors.outline
                        }
                    }


                    Item{
                        Layout.preferredWidth: row.implicitWidth 
                        Layout.fillHeight: true
                        
                        Behavior on Layout.preferredWidth{
                            NumberAnimation{
                                duration: 200
                                easing.type:Easing.OutQuad
                            }
                        }
                        RowLayout{
                            id: row
                            anchors.fill: parent
                            spacing: 10
                            Loader{
                                id: lockLoader
                                active: modelData.isSecure

                                sourceComponent: CustomIconImage {
                                    size: 18
                                    icon: "lock"
                                    color: modelData.ssid === ServiceWifi.currentSSID ? Colors.primaryText : Colors.surfaceText
                                }
                            }

                            Loader{
                                id: rightLoader
                                active: wifiArea.containsMouse
                                visible: active

                                sourceComponent: Rectangle{ 
                                    implicitWidth: 20
                                    implicitHeight: 20
                                    radius: height / 2
                                    color: modelData.ssid === ServiceWifi.currentSSID ? Colors.primaryText :  Qt.alpha(Colors.primaryText, 0.5)
                                    CustomIconImage {
                                        anchors.centerIn: parent
                                        size: 18
                                        icon: "right"
                                        //color: modelData.ssid === ServiceWifi.currentSSID ? Colors.primaryText : Colors.surfaceText

                                        NumberAnimation on opacity{
                                            from: 0
                                            to: 1
                                            duration: 300
                                            running: true
                                        }

                                        MouseArea{
                                            id: wifiDetails
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked:{
                                                root.isWifiSettingClicked = true
                                                root.wifiDetailsData = modelData
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

        }
    }
}

