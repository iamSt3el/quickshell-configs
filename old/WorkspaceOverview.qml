import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.util
import QtQuick.Shapes

Scope {
    id: workspaceOverviewRoot
    property var activePanels: Quickshell.globalWorkspaceOverviewPanels || (Quickshell.globalWorkspaceOverviewPanels = {})
    
    IpcHandler {
        target: "workspaceOverview"
        
        function togglePanel(): void {
            var focusedMonitor = Hyprland.focusedMonitor
            
            if(focusedMonitor){
                for(var i = 0; i < Quickshell.screens.length; i++){
                    var screen = Quickshell.screens[i];
                    var hyprMonitor = Hyprland.monitorFor(screen);
                    if(hyprMonitor && hyprMonitor.name === focusedMonitor.name){
                        var panel = workspaceOverviewRoot.activePanels[screen.name];
                        if(panel){
                            if(!panel.visible) {
                                panel.open()
                            } else {
                                panel.close()
                            }
                            return;
                        }
                    }
                }
            }
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: testpanel
            required property var modelData
            implicitWidth: grid.width + 60
            implicitHeight: grid.height + 60
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            visible: false
            color: "transparent"

            anchors{
                bottom: true
            }
            
            Component.onCompleted: {
                workspaceOverviewRoot.activePanels[modelData.name] = this;
            }
   
        Colors {
            id: colors
        }
        
        Timer{
            id: timer
            interval: 100
            onTriggered:{
                testpanel.visible = false
            }
        }

        SequentialAnimation {
            id: openAnimation
            
            // Stage 1: Height 0 → 30 AND Shape scales up (parallel)
            ParallelAnimation {
                NumberAnimation {
                    target: wrapper
                    property: "height"
                    from: 0
                    to: 30
                    duration: 400
                    easing.type: Easing.OutQuad
                }
                
                NumberAnimation {
                    target: shapeScale
                    property: "yScale"
                    from: 0
                    to: 1.0
                    duration: 400
                    easing.type: Easing.OutQuad
                }
            }
            
            // Stage 2: Height 30 → full height (panel slides out)
            NumberAnimation {
                target: wrapper
                property: "height"
                from: 30
                to: 470
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
        
        SequentialAnimation {
            id: closeAnimation
            
            // Reverse: Height full → 30
            NumberAnimation {
                target: wrapper
                property: "height"  
                from: 470
                to: 30
                duration: 200
                easing.type: Easing.InQuad
            }
            
            ParallelAnimation {
                // Shape scales down
                NumberAnimation {
                    target: shapeScale
                    property: "yScale"
                    from: 1.0
                    to: 0
                    duration: 400
                    easing.type: Easing.InQuad
                }
                
                // Height 30 → 0
                NumberAnimation {
                    target: wrapper
                    property: "height"
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
                    Hyprland.refreshToplevels()
                }
            }
        }

        Item{
            id: wrapper
            width: parent.width
            height: 0
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Shape{
                id: shapeElement
                preferredRendererType: Shape.CurveRenderer
                
                transform: Scale {
                    id: shapeScale
                    origin.x: wrapper.width / 2
                    origin.y: wrapper.height
                    yScale: 0
                }
                ShapePath{
                    fillColor: colors.surface
                    strokeWidth: 0

                    startX: wrapper.x
                    startY: wrapper.height

                    PathArc{
                        relativeX:20
                        relativeY: -20
                        radiusY: 15
                        radiusX: 20
                        direction: PathArc.Counterclockwise
                    }

                    PathLine{
                        relativeX: wrapper.width - 40
                        relativeY: 0
                    }

                    PathArc{
                        relativeX: 20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 15
                        direction: PathArc.Counterclockwise
                    }

                }
            }
        Rectangle {
            id: workspaceOverview
            width: parent.width - 40
            height: parent.height
            color: colors.surface
            topLeftRadius: 20
            topRightRadius: 20
            clip: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle{
                id: overlay
                focus: true
                z: 1
                color: "transparent"
                anchors.fill: parent

            }

            
            Grid{
                id:grid
                visible: wrapper.height === 470
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
                            color: colors.surfaceContainer
                            radius: 10
                            border.width: (Hyprland.focusedWorkspace && (index + 1) === Hyprland.focusedWorkspace.id) ? 3 : 1
                            border.color: (Hyprland.focusedWorkspace && (index + 1) === Hyprland.focusedWorkspace.id) ? colors.primary : colors.outline
                            
                            // Workspace label
                            Text {
                                anchors.centerIn: parent
                                text: `WS ${index + 1}`
                                color: colors.surfaceText
                                font.pixelSize: 16
                                font.weight: Font.Bold
                            }

                            Repeater{
                                model: Hyprland.workspaces.values.find(ws => ws.id === index + 1)?.toplevels ?? []
                                onItemRemoved:{
                                    console.log("changed")
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
                                    
                                    //color: colors.primary
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
        }
        
        function open(){
            testpanel.visible = true
            openAnimation.start()
        }

        function close(){
            closeAnimation.start()
        }
        }
    }
}
