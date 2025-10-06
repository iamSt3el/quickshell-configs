import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import qs.modules.services
import Quickshell.Widgets

PopupWindow{
    id: bluetoothPanel
    anchor.window: bar
    implicitWidth: 250
    implicitHeight: 450
    property bool shouldShow: false
    visible: false

    color:"transparent"

     anchor{
         rect.x: wrapper.x + wrapper.width - bluetoothPanel.width
         rect.y: utilityWrapper.height
         adjustment: PopupAdjustment.None 
     }

    onShouldShowChanged: {
        if (shouldShow) {
            open()
        } else {
            close()
        }
    }
    
    NumberAnimation {
        id: openAnimation
        target: bluetoothWrapper
        property: "height"
        from: 0
        to: bluetoothPanel.implicitHeight
        duration: 200
        easing.type: Easing.OutQuad
        onStarted: bluetoothPanel.visible = true
    }
    
    NumberAnimation {
        id: closeAnimation
        target: bluetoothWrapper
        property: "height"
        from: bluetoothPanel.implicitHeight
        to: 0
        duration: 200
        easing.type: Easing.InQuad
        onFinished: bluetoothPanel.visible = false
    }
    
    function open() {
        openAnimation.start()
    }
    
    function close() {
        closeAnimation.start()
    }

     Item{
         id: bluetoothWrapper 
         anchors.left: parent.left
         anchors.right: parent.right
         anchors.top: parent.top
         height: 0
         clip: true

        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }

          Shape {
                preferredRendererType: Shape.CurveRenderer
                ShapePath {
                    fillColor: Colors.surfaceContainer
                    //strokeColor: "blue"
                    strokeWidth: 0
                    startX: bluetoothWrapper.x || 0
                    startY: bluetoothWrapper.y || 0

                    PathArc {
                        relativeX: Dimensions.position.x
                        relativeY: Dimensions.position.x
                        radiusX: Dimensions.radius.large
                        radiusY: Dimensions.radius.medium
                    }

                    PathLine{
                        relativeX: bluetoothRect.width - 20
                        relativeY: 0
                    }
                    PathLine{
                        relativeX: 0
                        relativeY: bluetoothRect.height - 20
                    }

                    PathArc{
                        relativeX: Dimensions.position.x
                        relativeY: Dimensions.position.y
                        radiusX: Dimensions.radius.large
                        radiusY: Dimensions.radius.medium
                    }

                    PathLine{
                        relativeX: 0
                        relativeY: -bluetoothRect.height - 10
                    }
                    
                }
            }


        Rectangle{
             id: bluetoothRect
             implicitWidth: parent.width - 20
             implicitHeight: parent.height - 20
             anchors{
                 right: parent.right
             }
             color: Colors.surfaceContainer
             bottomLeftRadius: 20

             Column{
                 anchors.fill: parent
                 spacing: 5
                 Item{
                    id: intro 
                    width: parent.width
                    height: 80
                    Column{
                        anchors.fill: parent
                        spacing: 5
                        Item{
                            width: parent.width
                            height: parent.height / 2
                            Row{
                                anchors.fill: parent
                                Item{
                                    height: parent.height
                                    width: 30
                                    Image{
                                        anchors.centerIn: parent
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(width, height)
                                        source: IconUtils.getSystemIcon("bluetooth")
                                        layer.enabled: true
                                        layer.effect: MultiEffect{
                                            colorization: 1.0
                                            colorizationColor: ServiceBluetooth.state ? "#89b4fa" : Colors.surfaceText
                                            brightness: 1
                                        }
                                    }
                                }
                                
                                Item{
                                    height: parent.height
                                    width: 80

                                    Column{
                                        anchors.fill: parent
                                        StyledText{
                                            content: "BLUETOOTH"
                                            size: 16
                                        }
                                        StyledText{
                                            content:  ServiceBluetooth.state ? ServiceBluetooth.connectedDevices + " connected" : "Disabled"
                                            size: 12
                                        }
                                    }
                                }

                                StylesToggle{
                                    height: parent.height
                                    width: 110
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
                        }
                    
                        Item{
                            width: parent.width
                            height: 30

                            Rectangle{
                                id: scanButton
                                property bool isScanning: false
                                anchors.centerIn: parent
                                implicitWidth: parent.width - 14
                                implicitHeight: parent.height
                                color: isScanning ? Qt.alpha(Colors.primary, 0.8) : Colors.primary
                                radius: 10

                                Row{
                                    anchors.centerIn: parent
                                    spacing: 10
                                    Image{
                                        id: scanIcon
                                        property string icon:{
                                            if(scanButton.isScanning) return "reload"
                                            return "scan"
                                        }
                                        width: 20
                                        height: 20
                                        sourceSize: Qt.size(width, height)
                                        source: IconUtils.getSystemIcon(icon)
                                        layer.enabled: true
                                        layer.effect: MultiEffect{
                                            colorization: 1.0
                                            colorizationColor: Colors.primaryText
                                            brightness: 1
                                        }

                                        NumberAnimation on rotation {
                                            from: 0
                                            to: 360
                                            duration: 2000
                                            loops: Animation.Infinite
                                            running: scanButton.isScanning
                                        }
                                    }
                                    StyledText{
                                        id: text
                                        content: scanButton.isScanning ? "Scanning" : "Scan"
                                        size: 16
                                        effect: false
                                        color: Colors.primaryText
                                    }
                                }

                                Timer{
                                    id: scanTimer
                                    interval: 10000
                                    onTriggered:{
                                        scanButton.isScanning = false
                                    }
                                }

                                MouseArea{
                                    id: buttonArea
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked:{
                                            scanIcon.rotation = 0
                                            if(!scanButton.isScanning){
                                                scanButton.isScanning = true
                                                scanTimer.start()
                                                Quickshell.execDetached(["bluetoothctl", "--timeout", "10", "scan", "on"])
                                            }
                                    }
                                }
                            }
                        }
                    
                    }
                }
                Rectangle{
                    implicitWidth: parent.implicitWidth - 10
                    implicitHeight: 2
                    radius: 5
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: Colors.surfaceVariant
                }
                 ClippingWrapperRectangle{
                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: parent.width - 10
                    implicitHeight: parent.height - intro.height - 20
                    radius: 10
                    color: "transparent"

                    Item {
                        anchors.fill: parent

                        Loader{
                            active: !ServiceBluetooth.state
                            anchors.fill: parent
                            
                            sourceComponent: Component{ 
                            Item{
                            anchors.fill: parent

                            Column{
                                anchors.centerIn: parent
                                spacing: 10
                                Rectangle{
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    implicitWidth: 60
                                    implicitHeight: 60
                                    radius: 30
                                    color: Colors.surfaceVariant
                                    Image{
                                        anchors.centerIn: parent
                                        width: 30
                                        height: 30
                                        sourceSize: Qt.size(width, height)
                                        source: IconUtils.getSystemIcon("bluetooth")

                                        layer.enabled: true
                                            layer.effect: MultiEffect{
                                                colorization: 1.0
                                                colorizationColor: Qt.alpha(Colors.primaryText, 0.5)
                                                brightness: 1
                                        }
                                    }
                                }

                                StyledText{
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    content: "Bluetooth is off"
                                    size: 16
                                }

                                StyledText{
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    content: "Enable to connect devices"
                                    size: 12
                                }
                            }
                        }
                    }
                        }

                        Column{
                            visible: ServiceBluetooth.state
                            anchors.fill: parent
                            spacing: 5

                            // Paired devices section
                            Column{
                                id: pairedSection
                                width: parent.width
                                height: (parent.height - parent.spacing) / 2
                                spacing: 5

                                Item{
                                    width: parent.width
                                    height: 20
                                    StyledText{
                                        anchors.left: parent.left
                                        anchors.leftMargin: 4
                                        anchors.verticalCenter: parent.verticalCenter
                                        content: "Paired Devices"
                                        size: 11
                                        color: Qt.alpha(Colors.surfaceText, 0.6)
                                        effect: false
                                    }
                                }

                                ListView{
                                    id: pairedListView
                                    property int expandedIndex: -1
                                    width: parent.width
                                    height: parent.height - 20
                                    orientation: Qt.Vertical
                                    spacing: 5
                                    clip: true
                                    model: ServiceBluetooth.pairedDevices
                                    delegate:Rectangle{
                                id: bluetoothItem
                                property bool isExpanded: pairedListView.expandedIndex === index
                                property bool isConnecting: false
                                property bool showConnectionStatus: false
                                property bool connectionSuccess: false

                                implicitWidth: ListView.view.width - 4
                                implicitHeight: isExpanded ? 120 : 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 5
                                color: modelData.state === 1 ? Colors.tertiary : modelData.state === 3 ? Colors.secondary : Colors.surfaceVariant

                                Behavior on color{
                                    ColorAnimation{
                                        duration: 300
                                    }
                                }

                                Behavior on implicitHeight{
                                    NumberAnimation{
                                        duration: 300;
                                        easing.type: Easing.OutQuad
                                    }
                                }

                                // Connection status timer
                                Timer{
                                    id: connectionStatusTimer
                                    interval: 2000
                                    onTriggered: {
                                        bluetoothItem.showConnectionStatus = false
                                    }
                                }

                                Connections{
                                    target: modelData
                                    function onConnectedChanged(){
                                        if(bluetoothItem.isConnecting){
                                            bluetoothItem.isConnecting = false
                                            bluetoothItem.connectionSuccess = modelData.connected
                                            bluetoothItem.showConnectionStatus = true
                                            connectionStatusTimer.start()
                                        }
                                    }
                                }

                                Column{
                                    anchors.fill: parent
                                    spacing: 0

                                    // Header row (always visible)
                                    Row{
                                        width: parent.width
                                        height: 40

                                        Item{
                                            width: parent.width * 0.2
                                            height: parent.height
                                            Image{
                                                anchors.centerIn: parent
                                                height: 25
                                                width: 25
                                                sourceSize: Qt.size(height, width)
                                                source: IconUtils.getIconPath(modelData.icon)
                                            }
                                        }

                                        Item{
                                            width: parent.width * 0.6
                                            height: parent.height
                                            clip: true
                                            StyledText{
                                                content: modelData.deviceName || "Unknown device"
                                                color: Colors.surfaceText
                                                size: 14
                                                anchors.verticalCenter: parent.verticalCenter
                                                elide: Text.ElideRight
                                            }
                                        }

                                        Item{
                                            width: parent.width * 0.2
                                            height: parent.height
                                            Image{
                                                id: arrowIcon
                                                anchors.centerIn: parent
                                                width: 20
                                                height: 20
                                                sourceSize: Qt.size(width, height)
                                                source: IconUtils.getSystemIcon("down")
                                                rotation: bluetoothItem.isExpanded ? 180 : 0

                                                Behavior on rotation{
                                                    NumberAnimation{
                                                        duration: 300
                                                        easing.type: Easing.OutQuad
                                                    }
                                                }
                                            }

                                            MouseArea{
                                                id: expandArea
                                                hoverEnabled: true
                                                anchors.fill: parent
                                                cursorShape: Qt.PointingHandCursor
                                                onClicked:{
                                                    pairedListView.expandedIndex = bluetoothItem.isExpanded ? -1 : index
                                                }
                                            }
                                        }
                                    }

                                    // Expanded content
                                    Item{
                                        width: parent.width
                                        height: bluetoothItem.height - 40
                                        clip: true
                                        visible: bluetoothItem.isExpanded

                                        Column{
                                            anchors.fill: parent
                                            anchors.leftMargin: 8
                                            anchors.rightMargin: 8
                                            anchors.topMargin: 4
                                            anchors.bottomMargin: 8
                                            spacing: 10

                                            // Device info
                                            Column{
                                                width: parent.width
                                                spacing: 3

                                                StyledText{
                                                    content: "Address: " + (modelData.address || "N/A")
                                                    size: 11
                                                    color: Qt.alpha(Colors.surfaceText, 0.7)
                                                    effect: false
                                                }

                                                StyledText{
                                                    content: "Status: " + (modelData.state === 1 ? "Connected" : modelData.state === 3 ? "Paired" : "Available")
                                                    size: 11
                                                    color: Qt.alpha(Colors.surfaceText, 0.7)
                                                    effect: false
                                                }
                                            }

                                            // Action buttons
                                            Row{
                                                width: parent.width
                                                spacing: 8

                                                // Connect/Disconnect button
                                                Rectangle{
                                                    width: (parent.width - parent.spacing) / 2
                                                    height: 32
                                                    radius: 8
                                                    color: Colors.primary

                                                    Row{
                                                        anchors.centerIn: parent
                                                        spacing: 6

                                                        Image{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            width: 18
                                                            height: 18
                                                            sourceSize: Qt.size(width, height)
                                                            source: IconUtils.getSystemIcon(modelData.connected ? "close" : "bluetooth")
                                                            layer.enabled: true
                                                            layer.effect: MultiEffect{
                                                                colorization: 1.0
                                                                colorizationColor: Colors.primaryText
                                                                brightness: 1
                                                            }
                                                        }

                                                        StyledText{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            content: modelData.connected ? "Disconnect" : "Connect"
                                                            size: 12
                                                            color: Colors.primaryText
                                                            effect: false
                                                        }
                                                    }

                                                    MouseArea{
                                                        anchors.fill: parent
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked:{
                                                            if(modelData.connected){
                                                                bluetoothItem.isConnecting = true
                                                                modelData.disconnect()
                                                            }else{
                                                                bluetoothItem.isConnecting = true
                                                                modelData.connect()
                                                            }
                                                        }
                                                    }
                                                }

                                                // Forget button
                                                Rectangle{
                                                    width: (parent.width - parent.spacing) / 2
                                                    height: 32
                                                    radius: 8
                                                    color: Qt.alpha(Colors.error || "#ef4444", 0.9)

                                                    Row{
                                                        anchors.centerIn: parent
                                                        spacing: 6

                                                        Image{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            width: 18
                                                            height: 18
                                                            sourceSize: Qt.size(width, height)
                                                            source: IconUtils.getSystemIcon("close")
                                                            layer.enabled: true
                                                            layer.effect: MultiEffect{
                                                                colorization: 1.0
                                                                colorizationColor: "#ffffff"
                                                                brightness: 1
                                                            }
                                                        }

                                                        StyledText{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            content: "Forget"
                                                            size: 12
                                                            color: "#ffffff"
                                                            effect: false
                                                        }
                                                    }

                                                    MouseArea{
                                                        anchors.fill: parent
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked:{
                                                            modelData.forget()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                            // Unpaired devices section
                            Column{
                                id: unpairedSection
                                width: parent.width
                                height: (parent.height - parent.spacing) 
                                spacing: 5

                                Item{
                                    width: parent.width
                                    height: 20
                                    StyledText{
                                        anchors.left: parent.left
                                        anchors.leftMargin: 4
                                        anchors.verticalCenter: parent.verticalCenter
                                        content: "Available Devices"
                                        size: 11
                                        color: Qt.alpha(Colors.surfaceText, 0.6)
                                        effect: false
                                    }
                                }

                                ListView{
                                    id: unpairedListView
                                    property int expandedIndex: -1
                                    width: parent.width
                                    height: parent.height - 20
                                    orientation: Qt.Vertical
                                    spacing: 5
                                    clip: true
                                    model: ServiceBluetooth.unpairedDevices
                                    delegate:Rectangle{
                                id: unpairedItem
                                property bool isExpanded: unpairedListView.expandedIndex === index
                                property bool isConnecting: false
                                property bool showConnectionStatus: false
                                property bool connectionSuccess: false

                                implicitWidth: ListView.view.width - 4
                                implicitHeight: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                                radius: 5
                                color: Colors.surfaceVariant

                                Behavior on color{
                                    ColorAnimation{
                                        duration: 300
                                    }
                                }

                                Behavior on implicitHeight{
                                    NumberAnimation{
                                        duration: 300;
                                        easing.type: Easing.OutQuad
                                    }
                                }

                                Timer{
                                    id: unpairedConnectionStatusTimer
                                    interval: 2000
                                    onTriggered: {
                                        unpairedItem.showConnectionStatus = false
                                    }
                                }

                                Connections{
                                    target: modelData
                                    function onConnectedChanged(){
                                        if(unpairedItem.isConnecting){
                                            unpairedItem.isConnecting = false
                                            unpairedItem.connectionSuccess = modelData.connected
                                            unpairedItem.showConnectionStatus = true
                                            unpairedConnectionStatusTimer.start()
                                        }
                                    }
                                }

                                Row{
                                    anchors.fill: parent

                                    Item{
                                        width: parent.width * 0.2
                                        height: parent.height
                                        Image{
                                            anchors.centerIn: parent
                                            height: 25
                                            width: 25
                                            sourceSize: Qt.size(height, width)
                                            source: IconUtils.getIconPath(modelData.icon)
                                        }
                                    }

                                    Item{
                                        width: parent.width * 0.6
                                        height: parent.height
                                        clip: true
                                        StyledText{
                                            content: modelData.deviceName || "Unknown device"
                                            color: Colors.surfaceText
                                            size: 14
                                            anchors.verticalCenter: parent.verticalCenter
                                            elide: Text.ElideRight
                                        }
                                    }

                                    Item{
                                        width: parent.width * 0.2
                                        height: parent.height

                                        MouseArea{
                                            id: pairArea
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked:{
                                                unpairedItem.isConnecting = true
                                                modelData.pair()
                                            }
                                        }

                                        StyledText{
                                            anchors.centerIn: parent
                                            content: "Pair"
                                            size: 11
                                            color: Colors.primary
                                            effect: false
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
     }
}
