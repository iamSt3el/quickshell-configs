import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Wayland
import qs.modules.util

Rectangle{
    id: overlay
    focus: true
    z: 1
    color: "transparent"

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
            model: 10
            delegate: Item{
                width: 300
                height: 200
                
                Rectangle{
                    id: workspaceThumbnail
                    anchors.fill: parent
                    color: Colors.surfaceContainer
                    radius: 10
                    border.width: (Hyprland.focusedWorkspace && (index + 1) === Hyprland.focusedWorkspace.id) ? 3 : 1
                    border.color: (Hyprland.focusedWorkspace && (index + 1) === Hyprland.focusedWorkspace.id) ? Colors.primary : Colors.outline
                    
                    Text {
                        anchors.centerIn: parent
                        text: `WS ${index + 1}`
                        color: Colors.surfaceText
                        font.pixelSize: 16
                        font.weight: Font.Bold
                    }

                    Repeater{
                        model: Hyprland.workspaces.values.find(ws => ws.id === index + 1)?.toplevels ?? []
                        onItemRemoved:{
                            Hyprland.refreshToplevels()
                        }

                        delegate: Rectangle{
                            id: windowRect
                            visible: modelData && modelData.monitor && modelData.lastIpcObject
                            
                            property real localX: modelData && modelData.monitor && modelData.lastIpcObject && modelData.lastIpcObject.at ? modelData.lastIpcObject.at[0] - modelData.monitor.x : 0
                            property real localY: modelData && modelData.monitor && modelData.lastIpcObject && modelData.lastIpcObject.at ? modelData.lastIpcObject.at[1] - modelData.monitor.y : 0
                            
                            property real originalX: modelData && modelData.monitor ? Math.floor((localX / modelData.monitor.width) * parent.width) : 0
                            property real originalY: modelData && modelData.monitor ? Math.floor((localY / modelData.monitor.height) * parent.height) : 0
                            property real originalWidth: modelData && modelData.monitor && modelData.lastIpcObject && modelData.lastIpcObject.size ? Math.floor((modelData.lastIpcObject.size[0] / modelData.monitor.width) * parent.width) : 0
                            property real originalHeight: modelData && modelData.monitor && modelData.lastIpcObject && modelData.lastIpcObject.size ? Math.floor((modelData.lastIpcObject.size[1] / modelData.monitor.height) * parent.height) : 0
                                       
                            x: originalX
                            y: originalY  
                            width: originalWidth
                            height: originalHeight
                            
                            color: "transparent"
                            radius: 3
                            
                            MouseArea {
                                anchors.fill: parent
                                drag.target: parent
                                drag.axis: Drag.XAndYAxis
                                cursorShape: Qt.SizeAllCursor
                                
                                onPressed: {
                                    var globalPos = windowRect.mapToItem(overlay, 0, 0)
                                    windowRect.width = workspaceThumbnail.width
                                    windowRect.height = workspaceThumbnail.height
                                    windowRect.parent = overlay
                                    windowRect.x = globalPos.x
                                    windowRect.y = globalPos.y
                                    windowRect.z = 10
                                }
                                
                                onPositionChanged: {}
                                
                                onReleased: {
                                    
                                    var globalPos = windowRect.mapToItem(grid, windowRect.width/2, windowRect.height/2)
                                    var targetWorkspaceIndex = -1
                                    
                                    for (var i = 0; i < rep.count; i++) {
                                        var workspaceItem = rep.itemAt(i)
                                        if (workspaceItem && 
                                            globalPos.x >= workspaceItem.x && 
                                            globalPos.x <= workspaceItem.x + workspaceItem.width &&
                                            globalPos.y >= workspaceItem.y && 
                                            globalPos.y <= workspaceItem.y + workspaceItem.height) {
                                            targetWorkspaceIndex = i
                                            break
                                        }
                                    }

                                    
                                    if (targetWorkspaceIndex >= 0) {
                                        var targetWorkspaceId = targetWorkspaceIndex + 1
                                        var currentWorkspaceId = modelData.workspace.id
                                        
                                        if (targetWorkspaceId !== currentWorkspaceId) {
                                            Hyprland.dispatch("movetoworkspacesilent " + targetWorkspaceId + ",address:0x" + modelData.address)
                                        }
                                    }
                                    
                                    windowRect.parent = workspaceThumbnail
                                    windowRect.x = originalX
                                    windowRect.y = originalY
                                    windowRect.width = originalWidth
                                    windowRect.height = originalHeight
                                    windowRect.z = 0
                                }
                            }
                   

                            ScreencopyView{
                                anchors.fill: parent
                                captureSource: modelData.wayland
                                live: true
                                paintCursor: false
                            }
                        }
                    }
                }
            }
        }
    }
}
