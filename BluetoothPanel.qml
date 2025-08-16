import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Bluetooth

Item {
    anchors.fill: parent
    
    property var sortedDevices: {
        if (!Bluetooth.devices || !Bluetooth.devices.values) {
            return [];
        }

        var devices = Bluetooth.devices.values.slice(); 
        
        return devices.sort(function(a, b) {
            if (a.connected !== b.connected) {
                return b.connected - a.connected;
            }
            return (a.name || "").localeCompare(b.name || "");
        });
    }

    Column {
        id: headerSection
        spacing: 10
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 20
        }
        height: 40
        
        Row {
            width: parent.width
            height: 20
            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
                Text {
                    text: "Bluetooth"
                    color: "#89b4fa"
                    font.pixelSize: 18
                }

                Rectangle {
                    implicitWidth: 50
                    implicitHeight: 20
                    color: "#11111b"
                    radius: 10

                    anchors {
                        right: parent.right
                    }

                    Rectangle {
                        property bool isToggleOn: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.state === 1 ? true : false
                        id: toggleButton
                        implicitWidth: 25
                        implicitHeight: 20
                        color: "#89b4fa"
                        radius: 20
                        x: isToggleOn ? 25 : 0

                        Behavior on x {
                            NumberAnimation {duration: 200; easing.type: Easing.Linear}
                        }

                        MouseArea {
                            id: toggleButtonArea
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                if (toggleButton.isToggleOn) {
                                    toggleButton.isToggleOn = false;
                                    Quickshell.execDetached(["bluetoothctl", "power", "off"])
                                    console.log("State: " + Bluetooth.defaultAdapter.state)
                                } else {
                                    toggleButton.isToggleOn = true
                                    Quickshell.execDetached(["bluetoothctl", "power", "on"])
                                    console.log("State: " + Bluetooth.defaultAdapter.state)
                                    toggleButton.x = toggleButton.width
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    ScrollView {
        id: deviceScrollView
        anchors {
            top: headerSection.bottom
            left: parent.left
            right: parent.right
            bottom: scanButton.top
            margins: 20
            topMargin: 10
            bottomMargin: 10
        }
        
        clip: true
        contentHeight: devicesList.implicitHeight
        
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        
        Column {
            id: devicesList
            spacing: 10
            width: deviceScrollView.width 
            
            Repeater {
                model: sortedDevices
                
                delegate: Rectangle {
                    visible: Bluetooth.defaultAdapter && Bluetooth.defaultAdapter.state === 1 ? true : false
                    width: parent.width
                    height: 50
                    color: modelData.state === 1 ? "#a6e3a1" : modelData.state === 3 ? "#f9e2af" : "#9399b2"
                    radius: 10

                    MouseArea{
                        id: deviceArea
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

                    Row {
                        width: parent.width
                        height: parent.height
                        spacing: 10

                        Rectangle {
                            implicitHeight: parent.height
                            implicitWidth: 50
                            color: "transparent"
                            Image {
                                anchors {
                                    centerIn: parent
                                }
                                width: parent.width - 10
                                height: parent.height - 10
                                source: Quickshell.iconPath(modelData.icon)
                            }
                        }

                        Rectangle {
                            implicitWidth: parent.width
                            implicitHeight: parent.height
                            color: "transparent"
                            clip: true

                            Text {
                                id: deviceName
                                text: modelData.deviceName
                                color: "#FFFFFF"
                                font.pixelSize: 16
                                anchors.verticalCenter: parent.verticalCenter

                                property bool needsScrolling: deviceName.contentWidth > parent.width
                                SequentialAnimation {
                                    running: deviceName.needsScrolling
                                    loops: Animation.Infinite

                                    PauseAnimation {duration: 1000}

                                    NumberAnimation {
                                        target: deviceName
                                        property: "x"
                                        from: 0
                                        to: -(deviceName.contentWidth - deviceName.parent.width)
                                        duration: 3000
                                        easing.type: Easing.Linear
                                    }
                                    PauseAnimation {duration: 1000}
                                    NumberAnimation {
                                        target: deviceName
                                        property: "x"
                                        from: -(deviceName.contentWidth - deviceName.parent.width)
                                        to: 0
                                        duration: 1500
                                        easing.type: Easing.Linear
                                    }
                                }
                            } 
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id: scanButton
        implicitWidth: 60
        implicitHeight: 40
        color: "transparent"
        anchors{
            right: parent.right
            bottom: parent.bottom
            //margins: 20
        }

        Rectangle{
            implicitHeight: parent.height - 10
            implicitWidth: parent.width - 10

            radius: 10
            color: "#89b4fa"

            anchors{
                centerIn: parent
            }

            Text{
                text: "Scan"
                anchors{
                    centerIn: parent
                }
                color:"#E4E4E4"
            }

            MouseArea{
                anchors{
                    fill: parent
                }
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked:{
                    Quickshell.execDetached(["bluetoothctl", "--timeout", "10", "scan", "on"])
                }
            }
        }
    }
}
