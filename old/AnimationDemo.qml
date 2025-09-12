import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util
import Qt5Compat.GraphicalEffects

Scope{
    id: animationDemoRoot
    property var activePanels: Quickshell.globalAnimationDemoPanels || (Quickshell.globalAnimationDemoPanels = {})
    
    Colors{
        id: colors
    }
    
    IpcHandler{
        target: "screencapture"
        
        function togglePanel(): void{
            var focusedMonitor = Hyprland.focusedMonitor
            
            if(focusedMonitor){
                for(var i = 0; i < Quickshell.screens.length; i++){
                    var screen = Quickshell.screens[i];
                    var hyprMonitor = Hyprland.monitorFor(screen);
                    if(hyprMonitor && hyprMonitor.name === focusedMonitor.name){
                        var panel = animationDemoRoot.activePanels[screen.name];
                        if(panel){
                            if(!panel.visible) panel.open()
                            else panel.close()
               
                            return;
                        }
                    }
                }
            }
        }
    }

    Variants{
        model: Quickshell.screens

        PanelWindow{
            id: panel
            required property var modelData
            implicitWidth: 80
            implicitHeight: 380
            color: "transparent"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            visible: false
            
            property int selectedMode: 0
            property bool isRecording: false
            property int recordingSeconds: 0
            
            property string savePath: "/home/steel/Videos/"
            property string fileExtension: "mp4"
            
            function generateFileName() {
                var now = new Date()
                var timestamp = now.getFullYear() + 
                    String(now.getMonth() + 1).padStart(2, "0") + 
                    String(now.getDate()).padStart(2, "0") + "-" +
                    String(now.getHours()).padStart(2, "0") + 
                    String(now.getMinutes()).padStart(2, "0") + 
                    String(now.getSeconds()).padStart(2, "0")
                return savePath + "recording-" + timestamp + "." + fileExtension
            }
            property var captureModes: [
                { icon: "./assets/max.svg", screenshotCommand: ["grimblast", "--notify", "copysave", "output"], recordCommand: "screen" },
                { icon: "./assets/crop.svg", screenshotCommand: ["grimblast", "--notify", "copysave", "active"], recordCommand: "window" },
                { icon: "./assets/pointer.svg", screenshotCommand: ["grimblast", "--notify", "copysave", "area"], recordCommand: "area" }
            ]
            
            function getRecordCommand(mode) {
                var filename = generateFileName()
                switch(mode) {
                    case "screen":
                        return ["sh", "-c", "wf-recorder -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') -f " + filename]
                    case "window":
                        return ["sh", "-c", "wf-recorder -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" -f " + filename]
                    case "area":
                        return ["sh", "-c", "wf-recorder -g \"$(slurp)\" -f " + filename]
                    default:
                        return ["sh", "-c", "wf-recorder -f " + filename]
                }
            }
            
            Component.onCompleted: {
                animationDemoRoot.activePanels[modelData.name] = this;
            }
            
            anchors{
                right: true
            }

        Item{
            id: wrapper
            height: parent.height
            width: 0
            anchors.right: parent.right
            anchors.top: parent.top
            
            Shape{
                id: shapeElement
                preferredRendererType: Shape.CurveRenderer
                
                
                transform: Scale {
                    id: shapeScale
                    origin.x: wrapper.width
                    origin.y: 0
                    xScale: 0
                }
                
                ShapePath{
                    fillColor: colors.surface
                    strokeWidth: 0
                    startX: wrapper.width
                    startY: wrapper.y

                    PathArc{
                        relativeX: -20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 20
                    }

                    PathLine{
                        relativeY: wrapper.height - 40
                        relativeX: 0
                    }

                    PathArc{
                        relativeX: 20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 15
                    }
                }
            }

            Rectangle{
                id: rect
                width: parent.width - 40
                height: parent.height - 40 + (panel.isRecording ? 30 : 0)
                color: colors.surface
                topLeftRadius: 20
                bottomLeftRadius: 20
                anchors{
                    verticalCenter: parent.verticalCenter
                    right: parent.right
                }
                
                Behavior on height {
                    NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                }

                Column{
                    anchors.fill: parent
                    visible: rect.width === 80
                    anchors.margins: 10
                    
                    // Recording timer
                    Item {
                        width: parent.width
                        height: panel.isRecording ? 30 : 0
                        visible: panel.isRecording
                        
                        Behavior on height {
                            NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
                        }
                        
                        Rectangle {
                            anchors.centerIn: parent
                            width: parent.width - 10
                            height: 25
                            color: colors.errorContainer
                            radius: 8
                            
                            Text {
                                anchors.centerIn: parent
                                text: Math.floor(panel.recordingSeconds / 60).toString().padStart(2, "0") + ":" + (panel.recordingSeconds % 60).toString().padStart(2, "0")
                                color: colors.errorContainerText
                                font.pixelSize: 12
                                font.weight: 800
                            }
                        }
                    }

                    Repeater {
                        model: panel.captureModes
                        
                        Item {
                            width: parent.width
                            height: 50
                            
                            Rectangle {
                                implicitHeight: 40
                                implicitWidth: 40
                                radius: 5
                                anchors.centerIn: parent
                                color: panel.selectedMode === index ? colors.primaryContainer : colors.surfaceVariant

                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Image {
                                    anchors.centerIn: parent
                                    width: 30
                                    height: 30
                                    sourceSize: Qt.size(width, height)
                                    source: modelData.icon

                                    layer.enabled: true
                                    layer.effect: ColorOverlay {
                                        color: panel.selectedMode === index ? colors.primaryContainerText : colors.surfaceText
                                    }
                                }
                                
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: panel.selectedMode = index
                                }
                            }
                        }
                    }

                     Item{
                        width: parent.width
                        height: 20
                        Rectangle{
                            implicitHeight: 1
                            implicitWidth: 40
                            anchors.centerIn: parent
                            color: colors.surfaceVariant
                        }
                    }

                    Item{
                        width: parent.width
                        height: 50
                        Rectangle{
                            implicitHeight: 40
                            implicitWidth: 40
                            radius: 5
                            anchors.centerIn: parent
                            color: colors.surfaceVariant

                             Image{
                                anchors.centerIn: parent
                                 width: 30
                                 height: 30
                                 sourceSize: Qt.size(width, height)
                                 source: "./assets/camera.svg"

                                 layer.enabled: true
                                 layer.effect: ColorOverlay{
                                     color: colors.surfaceText
                                 }
                            }
                            
                            MouseArea{
                                anchors.fill: parent
                                 cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Quickshell.execDetached(panel.captureModes[panel.selectedMode].screenshotCommand)
                                    panel.close()
                                }
                            }

                        }
                    }

                     Item{
                        width: parent.width
                        height: 50
                        Rectangle{
                            implicitHeight: 40
                            implicitWidth: 40
                            radius: 5
                            anchors.centerIn: parent
                            color: panel.isRecording ? colors.errorContainer : colors.surfaceVariant
                            
                            Behavior on color {
                                ColorAnimation { duration: 150 }
                            }

                             Image{
                                anchors.centerIn: parent
                                 width: 30
                                 height: 30
                                 sourceSize: Qt.size(width, height)
                                 source: panel.isRecording ? "./assets/square.svg" : "./assets/video.svg"

                                 layer.enabled: true
                                 layer.effect: ColorOverlay{
                                     color: panel.isRecording ? colors.errorContainerText : colors.surfaceText
                                 }
                            }
                            
                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (panel.isRecording) {
                                        // Stop recording
                                        Quickshell.execDetached(["pkill", "wf-recorder"])
                                        panel.isRecording = false
                                        recordingTimer.stop()
                                        processChecker.stop()
                                        panel.recordingSeconds = 0
                                        Quickshell.execDetached(["notify-send", "Recording", "Recording saved successfully"])
                                    } else {
                                        // Start recording
                                        var recordCommand = panel.getRecordCommand(panel.captureModes[panel.selectedMode].recordCommand)
                                        Quickshell.execDetached(recordCommand)
                                        panel.isRecording = true
                                        panel.recordingSeconds = 0
                                        recordingTimer.start()
                                        processChecker.start()
                                        Quickshell.execDetached(["notify-send", "Recording", "Recording started"])
                                    }
                                }
                            }

                        }
                    }

                     Item{
                        width: parent.width
                        height: 50
                        Rectangle{
                            implicitHeight: 40
                            implicitWidth: 40
                            radius: 5
                            anchors.centerIn: parent
                            color: colors.surfaceVariant
                             Image{
                                anchors.centerIn: parent
                                 width: 30
                                 height: 30
                                 sourceSize: Qt.size(width, height)
                                 source: "./assets/setting.svg"

                                 layer.enabled: true
                                 layer.effect: ColorOverlay{
                                     color: colors.surfaceText
                                 }
                            }

                        }
                    }

                }

            }
        }

        Timer{
            id: timer
            interval: 100
            onTriggered:{
                panel.visible = false
            }
        }
        
        Timer{
            id: recordingTimer
            interval: 1000
            repeat: true
            onTriggered: panel.recordingSeconds++
        }
        
        Timer {
            id: processChecker
            interval: 5000  // Check every 5 seconds instead of 1
            repeat: true
            onTriggered: {
                if (panel.isRecording) {
                    // Check if wf-recorder is still running
                    Quickshell.execDetached(["pgrep", "wf-recorder"])
                }
            }
        }

        SequentialAnimation {
            id: openAnimation
            
            // Stage 1: Width 0 → 30 AND Shape scales up (parallel)
            ParallelAnimation {
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: 0
                    to: 30
                    duration: 400
                    easing.type: Easing.OutQuad
                }
                
                NumberAnimation {
                    target: shapeScale
                    property: "xScale"
                    from: 0
                    to: 1.0
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }
            
            // Stage 2: Width 30 → 200 (full panel slides out)
            NumberAnimation {
                target: rect
                property: "width"
                from: 30
                to: 80
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
        
        SequentialAnimation {
            id: closeAnimation
            
            // Reverse: Width 200 → 30
            NumberAnimation {
                target: rect
                property: "width"  
                from: 80
                to: 30
                duration: 200
                easing.type: Easing.InQuad
            }
            
            ParallelAnimation {
                // Shape scales down
                NumberAnimation {
                    target: shapeScale
                    property: "xScale"
                    from: 1.0
                    to: 0
                    duration: 400
                    easing.type: Easing.InQuad
                }
                
                // Width 30 → 0
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: 30
                    to: 0
                    duration: 400
                    easing.type: Easing.InQuad
                }
            }
            
            onFinished: {
                timer.start()
            }
        }
        
        function open(){
            panel.visible = true
            openAnimation.start()
        }

        function close(){
            closeAnimation.start()
        }
        
     
        }
    }
}
