import Quickshell
import Quickshell.Io
import QtQuick


Item{
    id: root
    property var dockRect: null
    property var iconIndex: -1
    property var windowData: null 
    readonly property int windowWidth: 140
    readonly property int windowHeight: 120
    property bool popupVisible: false
    
    property int calculatedWidth: 160
    
    onWindowDataChanged: {
        if (windowData && windowData.windows) {
            calculatedWidth = Math.max(160, windowData.windows.length * (windowWidth + 10) + 10)
        } else {
            calculatedWidth = 160
        }
    }

    property alias popup_hideTimer: popupHideTimer

    Timer{
        id: popupHideTimer
        interval: 400
        onTriggered:{
            popupVisible = false
        }
    }


    // Timer for refreshing window preview
    Timer{
        id: previewRefreshTimer
        interval: 5000
        running: false
        repeat: true

        onTriggered: {
            if(windowData && popupWindow.visible){
                captureWindow()
            }
        }
    }

    property int currentCaptureIndex: 0
    property var captureQueue: []

    Process{
        id: captureProcess
        running: false

        onRunningChanged: {
            if(!running && captureQueue.length > 0){
                processNextCapture()
            }
        }

        stdout: StdioCollector{
            onStreamFinished: {
                // Force refresh of the image that was just captured
                refreshImageSources()
            }
        }
            stderr: StdioCollector{
                onStreamFinished: {
                    if(this.text.length > 0){
                        console.log("Capture error: ", this.text)
                    }
            } 
        }
    }

    function refreshImageSources(){
        // Trigger a refresh by updating a timestamp property
        imageRefreshTimestamp = Date.now()
    }

    property var imageRefreshTimestamp: Date.now()

    function captureWindow(){
        if(!windowData || !windowData.windows) return

        captureQueue = []
        for(let i = 0; i < windowData.windows.length; i++){
            captureQueue.push(windowData.windows[i].address)
        }
        currentCaptureIndex = 0
        processNextCapture()
    }

    function processNextCapture(){
        if(currentCaptureIndex >= captureQueue.length) return

        let address = captureQueue[currentCaptureIndex]
        captureProcess.command = ["grim", "-w", address, "/tmp/preview-" + address + ".png"]
        captureProcess.running = true
        currentCaptureIndex++
    }

    PopupWindow{
        id: popupWindow
        anchor.window: dock
        color: "transparent"
        implicitWidth: calculatedWidth
        implicitHeight: 180
        visible: popupVisible
        
        onVisibleChanged: {
            if(visible && windowData){
                captureWindow()
                previewRefreshTimer.start()
            } else {
                previewRefreshTimer.stop()
            }
        }

        anchor{
            rect.x: {
                if (!dockRect || iconIndex < 0) return 0
                    
                var iconWidth = 60
                var actualX = (dockRect.x + width / 2) - iconWidth
                actualX = actualX + (iconWidth * iconIndex)

                return actualX
            }
            rect.y: 0
            gravity: Edges.Top 
        }
        
        Rectangle{
            implicitWidth: parent.width
            implicitHeight: 160
            color: "#06070e"
            radius: 10

            anchors{
                centerIn: parent
            }
            
            Text{
                anchors{
                    horizontalCenter: parent.horizontalCenter
                }

                text: windowData && windowData.className ? windowData.className : ""
                color: "white"

            }

            Row{
                spacing: 10
                anchors{
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 10
                }
                
                Repeater{
                    model: windowData && windowData.windows ? windowData.windows : []

                    delegate: Rectangle{
                        width: root.windowWidth
                        height: root.windowHeight
                        color: "#4E6688"
                        radius: 10

                        Rectangle{
                            anchors{
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                margins: 5
                            }
                            height: 20
                            color: "transparent"
                            clip: true
                            
                            Text{
                                id: titleText
                                text: modelData.windowTitle
                                color: "white"
                                font.pixelSize: 12
                                
                                anchors.verticalCenter: parent.verticalCenter
                                
                                property bool needsScrolling: titleText.contentWidth > parent.width
                                
                                SequentialAnimation {
                                    running: titleText.needsScrolling
                                    loops: Animation.Infinite
                                    
                                    PauseAnimation { duration: 1000 }
                                    NumberAnimation {
                                        target: titleText
                                        property: "x"
                                        from: 0
                                        to: -(titleText.contentWidth - titleText.parent.width)
                                        duration: 3000
                                        easing.type: Easing.Linear
                                    }
                                    PauseAnimation { duration: 1000 }
                                    NumberAnimation {
                                        target: titleText
                                        property: "x"
                                        from: -(titleText.contentWidth - titleText.parent.width)
                                        to: 0
                                        duration: 1500
                                        easing.type: Easing.Linear
                                    }
                                }
                            }
                        }

                        Rectangle{
                            implicitWidth: parent.width - 10
                            implicitHeight: 90
                            radius: 10
                            anchors{
                                bottom: parent.bottom
                                horizontalCenter: parent.horizontalCenter
                                bottomMargin: 5
                            }

                            color: "#06070e"

                            Image{
                                id: previewImage
                                anchors.fill: parent
                                anchors.margins: 8
                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                cache: false
                                source: "file:///tmp/preview-" + modelData.address + ".png?" + root.imageRefreshTimestamp

                                onStatusChanged: {
                                    if(status === Image.Error){
                                        console.log("Failed to load preview image for:", modelData.address)
                                    }
                                }

                                Rectangle{
                                    anchors.fill: parent
                                    color: "#1a1a1a"
                                    radius: 6
                                    visible: previewImage.status !== Image.Ready

                                    Text{
                                        anchors.centerIn: parent
                                        text: {
                                            if(previewImage.status === Image.Loading) return "Loading..."
                                            if(previewImage.status === Image.Error) return "Capture Failed"
                                            return "No Preview"
                                        }
                                        color: "#666"
                                        font.pixelSize: 12
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
