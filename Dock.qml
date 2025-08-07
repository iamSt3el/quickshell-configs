import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes

Scope{
    id: root
    Variants{
        model: Quickshell.screens

        PanelWindow{
            required property var modelData
            screen: modelData

            // Id
            id: dock

            property var openWindows: []
            property bool isVisible: true
            property int hoveredIconIndex: -1
            property var winData: null
            property bool isIconHovered: false

            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            implicitHeight: isVisible ? 60 : 20
            implicitWidth: Math.max(60, (openWindows.length * 60) + 35)
            color: "transparent"
            visible: true

            anchors{
                bottom:true
            }

            // It will run the hyprctl cmd when the panel window is completed building
            Component.onCompleted:{
                hyprctlProcess.running = true
            }

            // Timer to hide the dock after mouse leaves
            Timer{
                id: dockHideTimer
                interval: 1000
                running: true
                onTriggered: {
                    dock.isVisible = false
                }
            }

            // Timer to show popup after hovering for 300ms
            Timer{
                id: popupShowTimer
                interval: 300
                running: false
                property int targetIndex: -1
                property var targetData: null

                onTriggered: {
                    if(popupWin){
                        popupWin.iconIndex = targetIndex
                        popupWin.windowData = targetData
                        popupWin.popupVisible = true
                        popupWin.popup_hideTimer.stop();
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    dock.isVisible = true
                    dockHideTimer.stop();
                }

                onExited: {
                    dockHideTimer.start();
                }
            }

            // Function for getting the window details
            function parseWindowDetails(data){
                let parts = data.split(",")
                return {
                    address: parts[0] || "",
                    workspace: parts[1] ||  "",
                    windowClass: parts[2] || "",
                    windowTitle: parts[3] || ""
                }
            }
            
            // Function to add a window
            function addWindow(windowData){
                let details = parseWindowDetails(windowData)
                let className = details.windowClass
                
                let groupIndex = -1;
                let newOpenWindows = openWindows.slice();
                for(let i = 0; i < newOpenWindows.length; i++){
                    if(newOpenWindows[i].className === className){
                        groupIndex = i;
                        break;
                    }
                }

                if(groupIndex === -1){
                    newOpenWindows.push({
                        className: className,
                        windows: [details],
                        count: 1
                    })
                }else{
                    newOpenWindows[groupIndex].windows.push(details);
                    newOpenWindows[groupIndex].count = newOpenWindows[groupIndex].windows.length;
                }
                
                openWindows = newOpenWindows;

            }
            
            // Function to remove a window
            
            function removeWindow(address){
                let newOpenWindows = openWindows
                for(let i = 0; i < newOpenWindows.length; i++){
                    let group = newOpenWindows[i]
                    for(let j = 0; j < group.windows.length; j++){
                        if(group.windows[j].address === address){
                            group.windows.splice(j, 1);
                            group.count = group.windows.length;

                            if(group.windows.length === 0){
                                newOpenWindows.splice(i, 1)
                            }
                            openWindows = newOpenWindows;
                            return;
                        }
                    }
                }
            }


            // Process to get the window Data when started
            Process {
                id: hyprctlProcess
                command: ["hyprctl", "clients", "-j"]
                running: false

                stdout: StdioCollector{
                    onStreamFinished:{
                        try{
                            var windowData = JSON.parse(this.text)

                            for(let i = 0; i < windowData.length; i++){
                                var window = windowData[i]
                                if(window.title === "" || window.workspace.id < 0){
                                    continue;
                                }

                                let add = window.address.replace(/^0x/, "")
                                let windowString = `${add},${window.workspace.id},${window.class},${window.title}`
                                addWindow(windowString)
                            }
                        }catch(e){
                            console.warn("Error parsing hyprctl output:", e)
                        }
                    }
                }
            }

            // connection to get live window data when running

            Connections{
                target: Hyprland

                function onRawEvent(event){
                    if(event.name === "openwindow"){
                        addWindow(event.data)
                        console.log(event.data)
                    }
                    if(event.name === "closewindow"){
                        const address = event.data.split(", ")[0]
                        removeWindow(address)
                        console.log(address)
                    }
                }
            }

            function setHovering(iconIndex, data, hovered){
                hoveredIconIndex = iconIndex
                winData = data
                isIconHovered = hovered
            }

            // Panel for the preview
            PopupWin {
                id: popupWin
                dockRect: dockRect
            }

            Rectangle{
                id: dockRect
                implicitHeight: 50
                implicitWidth: Math.max(60, openWindows.length * 60)
                color: "#06070e"
                topLeftRadius: 10
                topRightRadius: 10
                visible: dock.isVisible

                anchors{
                    horizontalCenter: parent.horizontalCenter
                }

                Row{
                    spacing: 5 
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                    }

                    Repeater{
                        model: dock.openWindows

                        delegate: Rectangle{
                            width: 40
                            height: 40
                            color: "transparent"
                            radius: 10
                        
                            
                            property var groupData: modelData
                            property string className: groupData.className
                            property var windows: groupData.windows
                            property int windowCount: groupData.count
                            
                            Image{
                                source: IconUtils.getIconPath(className)
                                width: 32
                                height: 32
                                opacity: iconMouseArea.containsMouse ? 1.0 : 0.7

                                Behavior on opacity {
                                    NumberAnimation{
                                        duration: 200
                                    }
                                }
                            }

                            Rectangle{
                                visible: windowCount > 1
                                width: 16
                                height: 16
                                radius: 8
                                color: "blue"

                                anchors{
                                    top: parent.top
                                    right: parent.right
                                    topMargin: -4
                                    rightMargin: -4
                                }
                                
                                Text{
                                    anchors{
                                        centerIn: parent
                                    }
                                    text: windowCount
                                    color: "white"
                                    font.pixelSize: 10

                                }
                            }

                            MouseArea{
                                id: iconMouseArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onEntered: {
                                    popupShowTimer.targetIndex = index
                                    popupShowTimer.targetData = groupData
                                    popupShowTimer.start()
                                }
                                onExited:{
                                    popupShowTimer.stop()
                                    if(popupWin && popupWin.popup_hideTimer){
                                            popupWin.popup_hideTimer.start();
                                    }
                                }

                                onClicked: {
                                    let addr = windows[0].address
                                    if(!addr.startsWith("0x")){
                                        addr = "0x" + addr;
                                    }
                                    Hyprland.dispatch("focuswindow address:" + addr)
                                }
                            }
                        }
                    }

                }

            }

            Shape{
                visible: dockRect.visible
                ShapePath{
                    fillColor: "#06070e"
                    strokeWidth: 0

                    startX: 0
                    startY: dock.height

                    PathArc{
                        relativeX: 18
                        relativeY: -10
                        radiusX: 20
                        radiusY: 15
                        direction: PathArc.Counterclockwise
                    }

                    PathLine{
                        relativeX: dock.width - 35
                        relativeY: 0
                    }

                    PathArc{
                        relativeX: 20
                        relativeY: 10
                        radiusX: 20
                        radiusY: 15
                        direction: PathArc.Counterclockwise
                    }

                    PathLine{
                        relativeX: -(dock.width)
                        relativeY: 0
                    }

                }
            }
        }
    }
}





