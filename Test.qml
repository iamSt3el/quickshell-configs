import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland
import qs.util

Item {
    PanelWindow {
        id: testpanel
        implicitWidth: 400
        implicitHeight: 200
        WlrLayershell.layer: WlrLayer.Overlay
        
        color: "transparent"
   
        Colors {
            id: colors
        }
        
        Rectangle {
            anchors.fill: parent
            color: colors.surface
            radius: 20     
            
            Row {
                anchors.centerIn: parent
                spacing: 30
                
                // Example 1: CPU Usage
                CircularProgressIndicator {
                    width: 120
                    height: 120
                    progress: 0.75
                    name: "CPU"
                    iconSource: "./assets/cpu.svg"
                    interactive: true
                }
                
                // Example 2: Memory Usage  
                CircularProgressIndicator {
                    width: 120
                    height: 120
                    progress: 0.45
                    name: "Memory"
                    displayText: "4.5 GB"
                    iconSource: "./assets/memory.svg"
                    fgColor: colors.secondary
                }
                
                // Example 3: Storage
                CircularProgressIndicator {
                    width: 120
                    height: 120
                    progress: 0.23
                    name: "Storage"
                    iconSource: "./assets/storage.svg"
                    fgColor: colors.tertiary
                }
            }
            
            // Test button to change values
            Rectangle {
                implicitWidth: 60
                implicitHeight: 30
                color: colors.primaryContainer
                radius: 15
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 10
                
                Text {
                    anchors.centerIn: parent
                    text: "Test"
                    color: colors.primaryContainerText
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // Randomize values for testing
                        var indicators = testpanel.children[0].children[0].children
                        for (var i = 0; i < indicators.length; i++) {
                            if (indicators[i].progress !== undefined) {
                                indicators[i].progress = Math.random()
                            }
                        }
                    }
                }
            }
        }
    }
}