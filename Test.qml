import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import qs.util

Item {
    PanelWindow {
        id: testpanel
        implicitWidth: grid.width + 20
        implicitHeight: grid.height + 20
        WlrLayershell.layer: WlrLayer.Overlay
        //visible: false
        color: "transparent"
   
        Colors {
            id: colors
        }
        
        Connections {
            target: Hyprland
            function onRawEvent(event) {
                if (event.name === "movewindow" || 
                    event.name === "resizewindow" ||
                    event.name === "fullscreen" ||
                    event.name === "activewindow" ||
                    event.name === "openwindow" ||
                    event.name === "closewindow" ||
                    event.name === "changefloatingmode") {
                    console.log(`Window event: ${event.name} - ${event.data}`)
                    Hyprland.refreshToplevels()
                }
            }
        }
        
        Rectangle {
            id: workspaceOverview
            anchors.fill: parent
            color: colors.surface
            radius: 10
            clip: true

            
            Grid{
                id:grid
                anchors.centerIn: parent
                width: (5 * 300) + 40
                height: (2 *  200) + 10
                rows: 2
                columns: 5
                spacing: 10
                
                Repeater{
                    id: rep
                    model: Hyprland.workspaces
                    delegate: Item{
                        width: 300
                        height: 200
                        
                        Rectangle{
                            id: workspaceThumbnail
                            anchors.fill: parent
                            color: colors.surfaceContainer
                            radius: 10
                            border.width: (Hyprland.focusedWorkspace && modelData.id === Hyprland.focusedWorkspace.id) ? 3 : 1
                            border.color: (Hyprland.focusedWorkspace && modelData.id === Hyprland.focusedWorkspace.id) ? colors.primary : colors.outline
                            
                            // Workspace label
                            Text {
                                anchors.centerIn: parent
                                text: `WS ${modelData.id}`
                                color: colors.surfaceText
                                font.pixelSize: 16
                                font.weight: Font.Bold
                            }

                            Repeater{
                                model: modelData.toplevels
                                onItemRemoved:{
                                    console.log("changed")
                                    Hyprland.refreshToplevels()
                                }

                                delegate: Rectangle{
                                    property real localX: modelData.lastIpcObject.at[0] - modelData.monitor.x
                                    property real localY: modelData.lastIpcObject.at[1] - modelData.monitor.y
                                    
                                    x: Math.floor((localX / modelData.monitor.width) * parent.width)
                                    y: Math.floor((localY / modelData.monitor.height) * parent.height)  
                                    width: Math.floor((modelData.lastIpcObject.size[0] / modelData.monitor.width) * parent.width)
                                    height: Math.floor((modelData.lastIpcObject.size[1] / modelData.monitor.height) * parent.height)
                                    
                                    color: colors.primary
                                    //color: "transparent"
                                    radius: 3
                                    opacity: 0.8
                                    
                                    MouseArea {
                                        anchors.fill: parent
                                        drag.target: parent
                                        drag.axis: Drag.XAndYAxis
                                        cursorShape: Qt.SizeAllCursor
                                        
                                        onPressed: {
                                            parent.opacity = 0.6
                                        }
                                        
                                        onReleased: {
                                            parent.opacity = 0.8
                                        }
                                    }
                                    Behavior on width{
                                        NumberAnimation{
                                            duration: 200
                                            easing.type: Easing.InQuad
                                        }
                                    }

                                    /*ScreencopyView{
                                        anchors.fill: parent
                                        captureSource: modelData.wayland
                                        live: true
                                        paintCursor: false
                                    }*/
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
