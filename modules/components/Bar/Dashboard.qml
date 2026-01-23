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
    anchors.fill: parent
    property bool isWifiClicked: false
    property bool isBluetoothClicked: false
    property bool isOverlayClicked: false


    property var parentPos
    property var wifiPos
    property var bluetoothPos
    property var pos


    Timer{
        id: rowTimer
        interval: 300
        onTriggered:{
            colu.visible = true
            root.isOverlayClicked = false
        }
    }

    opacity:0
    scale: 0.8

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 400
        running: true
    }

    
    NumberAnimation on scale{
        from: 0.8
        to: 1
        duration: 400
        running: true
    }



    Loader{
        id: overlay
        active: root.isOverlayClicked
        anchors.fill: parent
        z: 1
        visible: active
        sourceComponent: Item{
            anchors.fill: parent
            Rectangle{
                anchors.fill: parent
                radius: 20
                color: Qt.alpha(Colors.surface, 0.7)
                property bool active: root.isWifiClicked || root.isBluetoothClicked

                opacity: active ? 1 : 0

                Behavior on opacity{
                    NumberAnimation{
                        duration: 300
                    }
                }
            }
            Rectangle{
                id: container
                property bool active: root.isWifiClicked || root.isBluetoothClicked

                x: active ? root.parentPos.x : root.pos.x
                y: active ? root.parentPos.y : root.pos.y

                implicitWidth: active ? controleRectangle.width : wifi.width
                implicitHeight: active ? controleRectangle.height + 200 : 60
                color: Colors.surfaceContainerHigh

                radius: 20
                opacity: active ? 1 : 0.9
                Behavior on opacity{
                    PropertyAnimation{
                        duration: 300
                    }
                }

                Timer{
                    interval: 300
                    running: container.active
                    onTriggered:{
                        if(root.isWifiClicked){
                            wifiLoader.active = true
                        }else{
                            bluetoothLoader.active = true
                        }
                    }
                }

                Behavior on x{
                    NumberAnimation{
                        duration: 300
                        easing.type: Easing.InOutCirc
                    }
                }
                Behavior on y{
                    NumberAnimation{
                        duration: 300
                        easing.type: Easing.InOutCirc
                    }
                }

                Behavior on implicitWidth{
                    NumberAnimation{
                        duration: 300
                        easing.type: Easing.InOutCirc
                    }
                }
                Behavior on implicitHeight{
                    NumberAnimation{
                        duration: 300
                        easing.type: Easing.InOutCirc
                    }
                }

                Loader{
                    id: wifiLoader
                    active: false
                    anchors.fill: parent
                    visible: active
                    sourceComponent: Wifi{
                        onBackClicked: {
                            root.isWifiClicked = false
                            wifiLoader.active = false
                            rowTimer.start()
                        }
                    }
                }

                Loader{
                    id: bluetoothLoader
                    active: false
                    anchors.fill: parent
                    visible: active
                    sourceComponent: Bluetooth{
                        onBackClicked: {
                            root.isBluetoothClicked = false
                            bluetoothLoader.active = false
                            rowTimer.start()
                        }
                    }
                }
            }
        }
    }

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

                MaterialIconSymbol{
                    content: "settings"
                    iconSize: 20 
                    MouseArea{
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: {
                            GlobalStates.settingsOpen = true
                            root.toggleDashboard()
                        }
                    }
                }
                MaterialIconSymbol{
                    content: "power_settings_new"
                    iconSize: 20
                }
                MaterialIconSymbol{
                    content: "close"
                    iconSize: 20
                    MouseArea{
                        cursorShape: Qt.PointingHandCursor
                        anchors.fill: parent
                        onClicked: root.toggleDashboard()
                    }
                }


            }
        }

        Rectangle{
            id: controleRectangle
            Layout.preferredHeight: root.isWifiClicked || root.isBluetoothClicked ? colu.implicitHeight + 20 : colu.implicitHeight + 20
            Layout.fillWidth: true
            color: Colors.surfaceContainer
            radius: 20

            Behavior on Layout.preferredHeight{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            ColumnLayout{
                id: colu
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                RowLayout{
                    Layout.fillWidth: true
                    spacing: 10

                    ColumnLayout{
                        Layout.fillHeight: true
                        spacing: 10
                        Rectangle{
                            id: wifi
                            Layout.preferredHeight: 60
                            Layout.fillWidth: true
                            radius: 20
                            color: Colors.surfaceContainerHighest
                            opacity: root.isWifiClicked ? 0 : 1

                            Behavior on opacity {
                                NumberAnimation { duration: 300 }
                            }

                            RowLayout{
                                anchors.fill: parent
                                anchors.margins: 5

                                Rectangle{
                                    Layout.fillHeight: true
                                    Layout.preferredWidth: 60
                                    radius: 15
                                    color: Colors.primary

                                    MaterialIconSymbol{
                                        anchors.centerIn: parent
                                        iconSize: 28
                                        content: ServiceWifi.icon
                                        color: ServiceWifi.wifiEnabled ? Colors.primaryText : Colors.surfaceText
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
                                    root.parentPos = controleRectangle.mapToItem(root, 0, 0)
                                    root.pos = wifi.mapToItem(root, 0, 0)
                                    root.isOverlayClicked = true
                                    root.isWifiClicked = true
                                }
                            }
                        }
                        Rectangle{
                            id: bluetooth
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


                                    MaterialIconSymbol{
                                        anchors.centerIn: parent
                                        iconSize: 28
                                        content: ServiceBluetooth.connectedDevices > 0 ? "bluetooth" : "bluetooth_disabled"
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
                                    root.parentPos = controleRectangle.mapToItem(root, 0, 0)
                                    root.pos = bluetooth.mapToItem(root, 0, 0)
                                    root.isOverlayClicked = true
                                    root.isBluetoothClicked = true
                                    //colu.visible = false
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

                                        MaterialIconSymbol{
                                            anchors.centerIn: parent
                                            iconSize: 20
                                            content: modelData.icon
                                            color: parent.active ? Colors.primaryText : Colors.surfaceText
                                            fill: 1
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
                        icon: "volume_up"
                        progress: ServicePipewire.volume
                        onProgressChanged:{
                            ServicePipewire.setVolume(progress)
                        }

                    }
                    CustomSlider{
                        property var brightnessMonitor: ServiceBrightness.getMonitorForScreen(screen)
                        Layout.fillHeight: true
                        icon: "brightness_7"
                        progress: brightnessMonitor.brightness
                        onChange:{
                            brightnessMonitor.setBrightness(progress)
                        }

                    }
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: Colors.surfaceContainer
            radius: 20

            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                RowLayout{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    spacing: 4
                    Repeater{
                        model: Settings.themeModes

                        delegate: Rectangle{
                            id: themeIcon
                            Layout.fillHeight: true
                            Layout.preferredWidth: row.implicitWidth + 20
                            required property int index
                            required property var modelData
                            property bool active: Settings.activeTheme === modelData.name
                            property bool leftmost: index === 0
                            property bool rightmost: index === Settings.themeModes.length - 1

                            color: active ? Colors.primary : themeArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) : Colors.surfaceContainerHighest


                            onYChanged: {
                                if (index === 0) {
                                    button.leftmost = true
                                } else {
                                    var prev = flow.children[index - 1]
                                    var thisIsOnNewLine = prev && prev.y !== button.y
                                    button.leftmost = thisIsOnNewLine
                                    prev.rightmost = thisIsOnNewLine
                                }
                            }


                            topLeftRadius: (active || leftmost) ? height / 2 : 5
                            topRightRadius: (active || rightmost) ? height / 2 : 5
                            bottomLeftRadius: (active || leftmost) ? height / 2 : 5
                            bottomRightRadius: (active || rightmost) ? height / 2 : 5


                            Behavior on topLeftRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on topRightRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on bottomLeftRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on bottomRightRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }
                            RowLayout{
                                anchors.centerIn: parent
                                id: row
                                MaterialIconSymbol{
                                    content: modelData.icon
                                    size: 18
                                    color: themeIcon.active ? Colors.primaryText : Colors.surfaceText
                                }
                                CustomText{
                                    content: modelData.name
                                    size: 13
                                    color: themeIcon.active ? Colors.primaryText : Colors.surfaceText
                                }
                            }

                            MouseArea{
                                id: themeArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:{
                                    Settings.setActiveTheme(modelData.name)
                                }
                            }

                        }
                    }
                }

                RowLayout{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    spacing: 4
                    Repeater{
                        model: Settings.quickIcons
                        delegate: Rectangle{
                            property bool isMute:false
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: isMute ? Colors.primary : iconsArea.containsMouse ? Qt.alpha(Colors.primary, 0.5) : Colors.surfaceContainerHighest
                            required property int index
                            required property var modelData
                            property bool active: isMute
                            property bool leftmost: index === 0
                            property bool rightmost: index === Settings.quickIcons.length - 1



                            onYChanged: {
                                if (index === 0) {
                                    button.leftmost = true
                                } else {
                                    var prev = flow.children[index - 1]
                                    var thisIsOnNewLine = prev && prev.y !== button.y
                                    button.leftmost = thisIsOnNewLine
                                    prev.rightmost = thisIsOnNewLine
                                }
                            }


                            topLeftRadius: (active || leftmost) ? height / 2 : 5
                            topRightRadius: (active || rightmost) ? height / 2 : 5
                            bottomLeftRadius: (active || leftmost) ? height / 2 : 5
                            bottomRightRadius: (active || rightmost) ? height / 2 : 5


                            Behavior on topLeftRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on topRightRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on bottomLeftRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on bottomRightRadius {
                                NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                            }
                            Behavior on color {
                                ColorAnimation { duration: 100 }
                            }


                            MaterialIconSymbol{
                                anchors.centerIn: parent
                                content: parent.isMute ? modelData.iconActive : modelData.icon
                                iconSize: 20
                                color: parent.isMute? Colors.primaryText : Colors.surfaceText
                            }


                            MouseArea{
                                id: iconsArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked:{
                                    parent.isMute = !parent.isMute
                                }
                            }
                        }
                    }
                }


            }
        }

        MusicPlayer{
            Layout.fillWidth: true
            Layout.fillHeight: true
            //Layout.preferredHeight: 100
        }

    }
}
