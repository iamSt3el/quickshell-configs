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
    property bool isBluetootSettingClicked
    property var bluetoothData

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
    
    Item{
        visible: root.isBluetootSettingClicked
        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout{
            anchors.fill: parent
            spacing: 10
            Rectangle{
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                radius: height / 2
                color: Qt.alpha(Colors.primary, 0.3)

                CustomIconImage{
                    anchors.centerIn: parent
                    icon: root.bluetoothData ? root.bluetoothData.icon : "bluetooth"
                    size: 20
                    color: Colors.primary
                }
            }

            CustomText{
                Layout.alignment: Qt.AlignHCenter
                content: root.bluetoothData ? root.bluetoothData.name : ""
                size: 14
                color: Colors.surfaceText
            }

            CustomText{
                Layout.alignment: Qt.AlignHCenter
                content: root.bluetoothData && root.bluetoothData.state === 1 ? "Connected" : "Not Connected"
                size: 12
                color: Colors.primary
            }
            RowLayout{
                Layout.fillWidth: true
                Layout.topMargin: 10
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Battery"
                    size: 12
                    color: Colors.outline
                }

                CustomText{
                    content: root.bluetoothData ? Math.floor(root.bluetoothData.battery * 100) + " %" : ""
                }
            }
            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Address"
                    size: 12
                    color: Colors.outline
                }

                CustomText{
                    content: root.bluetoothData ? root.bluetoothData.address : ""
                }
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                CustomText{
                    Layout.fillWidth: true
                    content: "Trusted"
                    size: 12
                    color: Colors.outline
                }

                CustomText{
                    content: root.bluetoothData ? root.bluetoothData.trusted : ""
                }
            }


            Item{
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            Rectangle{
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                radius: 10
                color: Qt.alpha(Colors.primary, 0.8)
                property bool active : root.bluetoothData && root.bluetoothData.state === 1 ? true : false
                CustomText{
                    anchors.centerIn: parent
                    content: parent.active ? "Disconnect" : "Connect"
                    size: 13
                    color: Colors.primaryText
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{
                        if(parent.active){
                            root.bluetoothData.disconnect()
                        }else{
                            root.bluetoothData.connect()
                        }
                    }
                }
            }

            Rectangle{
                Layout.preferredHeight: 30
                Layout.fillWidth: true
                radius: 10
                color: Qt.alpha(Colors.primary, 0.8)
                property bool active : root.bluetoothData && root.bluetoothData.paired ? true : false

                CustomText{
                    anchors.centerIn: parent
                    content: parent.active ? "Unpair" : "Pair"
                    size: 13
                    color: Colors.primaryText
                }

                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{
                        if(parent.active){
                            root.bluetoothData.forget()
                        }else{
                            root.bluetoothData.pair()
                        }
                    }
                }
            }


        }
    }



    RowLayout{
        visible: !root.isBluetootSettingClicked
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
        visible: !root.isBluetootSettingClicked
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
                color: modelData.state === 1 ? Colors.primary : bluetoothArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent"
                radius: 10

                Behavior on color{
                    ColorAnimation{
                        duration: 200
                    }
                }

                MouseArea{
                    id: bluetoothArea
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
                    anchors.margins: 10
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
                                id: batteryLoader
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

                            Loader{
                                id: rightLoader
                                active: bluetoothArea.containsMouse
                                visible: active

                                sourceComponent:Rectangle{ 
                                    implicitHeight: 20
                                    implicitWidth: 20
                                    radius: height / 2
                                    color: modelData.state === 1 ? Colors.primaryText : Qt.alpha(Colors.primary, 0.5)
                                    CustomIconImage {
                                        anchors.centerIn: parent
                                        size: 18
                                        icon: "right"

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
                                                root.isBluetootSettingClicked = true
                                                root.bluetoothData = modelData
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
