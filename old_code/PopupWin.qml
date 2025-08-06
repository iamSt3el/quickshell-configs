import Quickshell
import Quickshell.Io
import QtQuick

Item {
    property bool isHovered: false
    property var dockRect: null  // Reference to the main dock rectangle
    property int iconIndex: -1   // Which icon is being hovered
    property string windowAddress: ""  // Window address for capturing
    
    // Expose the popup timer for external access
    property alias hideTimer_popup: hideTimer_popup

    // Timer to prevent flickering
    Timer {
        id: hideTimer_popup
        interval: 400
        onTriggered: {
            popupWindow.hidePopup()
            previewRefreshTimer.stop()  // Stop refresh timer when hiding
        }
    }

    // Timer for refreshing window preview
    Timer {
        id: previewRefreshTimer
        interval: 1000  // Refresh every second when popup is visible
        running: false
        repeat: true
        
        onTriggered: {
            if (windowAddress && popupWindow.visible) {
                captureWindow()
            }
        }
    }

    // Process for focusing window when clicked
    Process {
        id: focusProcess
        running: false
    }

    // Process for capturing window screenshots
    Process { 
        id: captureProcess
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                // Add timestamp to force image reload
                previewImage.source = "file:///tmp/preview-" + windowAddress + ".png?" + Date.now()
            }
        }
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.length > 0) {
                    console.log("Capture error:", this.text)
                }
            }
        }
    }

    // Function to capture window screenshot
    function captureWindow() {
        //console.log(windowAddress)
        if (!windowAddress) return
        
        // Use grim-hyprland if available, fallback to regular grim
        captureProcess.command = ["grim", "-w", windowAddress, "/tmp/preview-" + windowAddress + ".png"]
        captureProcess.running = true
    }

    // Watch isHovered to trigger animations
    onIsHoveredChanged: {
        if (isHovered && dockRect !== null) {
            hideTimer.stop()
            popupWindow.showPopup()
            // Start preview refresh timer
            previewRefreshTimer.start()
            // Capture initial screenshot
            captureWindow()
        } else {
            hideTimer.restart()
        }
    }

    PopupWindow {
        id: popupWindow
        anchor.window: dock
        color: "transparent"
        implicitWidth: 200
        implicitHeight: 160
        visible: false

        // Animation properties
        property real animScale: 0.8
        property real animOpacity: 0.0

        // Show/hide functions
        function showPopup() {
            visible = true
            showAnimation.start()
        }

        function hidePopup() {
            hideAnimation.start()
        }

        anchor {
            // Calculate position based on icon index and prevent overflow
            rect.x: {
                if (!dockRect || iconIndex < 0) return 0

                var iconWidth = 50
                var actualX = dockRect.x + width / 2 - iconWidth
                actualX = actualX + (iconWidth * iconIndex)
                

                return actualX
            }
            rect.y: 0  // Position above the dock
            gravity: Edges.Top
        }

        // Show animation
        ParallelAnimation {
            id: showAnimation
            NumberAnimation {
                target: popupWindow
                property: "animScale"
                to: 1.0
                duration: 250
                easing.type: Easing.OutBack
            }
            NumberAnimation {
                target: popupWindow
                property: "animOpacity"
                to: 1.0
                duration: 200
                easing.type: Easing.OutQuart
            }
        }

        // Hide animation
        ParallelAnimation {
            id: hideAnimation
            NumberAnimation {
                target: popupWindow
                property: "animScale"
                to: 0.8
                duration: 150
                easing.type: Easing.InQuart
            }
            NumberAnimation {
                target: popupWindow
                property: "animOpacity"
                to: 0.0
                duration: 150
                easing.type: Easing.InQuart
            }
            onFinished: {
                popupWindow.visible = false
                dockRect.topLeftRadius = 10
                dockRect.topRightRadius = 10
            }
        }

        // Animated container
        Item {
            anchors.fill: parent
            scale: popupWindow.animScale
            opacity: popupWindow.animOpacity
            transformOrigin: Item.Bottom

            Rectangle {
                id: popupBackground
                implicitWidth: parent.width
                implicitHeight: parent.height - 20
                //anchors.fill: parent
                //anchors.bottom: parent.bottom
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#06070e"
                radius: 10
                //border.color: "#333"
                //border.width: 1

                // Window preview image
                Image {
                    id: previewImage
                    anchors.fill: parent
                    anchors.margins: 8
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    cache: false  // Disable caching to ensure fresh images
                    
                    // Placeholder or loading state
                    Rectangle {
                        anchors.fill: parent
                        color: "#1a1a1a"
                        radius: 6
                        visible: previewImage.status !== Image.Ready
                        
                        Text {
                            anchors.centerIn: parent
                            text: previewImage.status === Image.Loading ? "Loading..." : "No Preview"
                            color: "#666"
                            font.pixelSize: 12
                        }
                    }
                    
                    // Error handling
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("Failed to load preview image for window:", windowAddress)
                        }
                    }
                }

                MouseArea {
                    id: popupArea
                    anchors.fill: parent
                    hoverEnabled: true

                    onEntered: {
                        hideTimer.stop()
                        hideTimer_popup.stop()
                    }

                    onExited: {
                        hideTimer.start()
                        hideTimer_popup.start();
                    }
                    
                    // Optional: Click to focus window
                    onClicked: {
                        if (windowAddress) {
                            // Focus the window using hyprctl
                            focusProcess.command = ["hyprctl", "dispatch", "focuswindow", "address:" + windowAddress]
                            focusProcess.running = true
                        }
                    }
                }
            }
        }
    }
}
