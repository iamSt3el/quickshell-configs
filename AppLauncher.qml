import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util
import Quickshell.Widgets
import QtQuick.Layouts

Scope{
    id: appLauncherRoot
    property var activePanels: Quickshell.globalAppLauncherPanels || (Quickshell.globalAppLauncherPanels = {})
    
    Colors {
        id: colors
    }
    
    FuzzySearch {
        id: fuzzySearch
    }
    
    IpcHandler{
        target: "appLauncher"
        
        function togglePanel(): void{
            var focusedMonitor = Hyprland.focusedMonitor
            
            if(focusedMonitor){
                for(var i = 0; i < Quickshell.screens.length; i++){
                    var screen = Quickshell.screens[i];
                    var hyprMonitor = Hyprland.monitorFor(screen);
                    if(hyprMonitor && hyprMonitor.name === focusedMonitor.name){
                        var panel = appLauncherRoot.activePanels[screen.name];
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
            id: appLauncherWindow
            required property var modelData
            implicitHeight: 600
            implicitWidth: 350
            visible: false
            property string searchText: ""
            property var currentFilteredApps: DesktopEntries.applications ? DesktopEntries.applications.values : []
            property int selectedIndex: 0
            
            onSearchTextChanged: {
                if (DesktopEntries.applications) {
                    currentFilteredApps = fuzzySearch.searchApplications(DesktopEntries.applications, searchText);
                } else {
                    currentFilteredApps = []
                }
                selectedIndex = 0;
            }
            
            Component.onCompleted: {
                appLauncherRoot.activePanels[modelData.name] = this;
            }
            
         
            anchors{
                left: true
            }
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            exclusionMode: ExclusionMode.Normal
            color: "transparent"

            Item{
                id: wrapper
                height: parent.height
                width: 0
                anchors.left: parent.left
                anchors.top: parent.top

                     
                Shape{
                    id: shapeElement
                    preferredRendererType: Shape.CurveRenderer 
                    
                    transform: Scale {
                        id: shapeScale
                        origin.x: 0
                        origin.y:  0
                        xScale: 0
                        //yScale: 1
                    }
                    
                    ShapePath{
                        fillColor: colors.surface
                        strokeWidth: 0
                        startX: wrapper.x
                        startY: wrapper.y


                        PathArc{
                            relativeX: 20
                            relativeY: 20
                            radiusX: 20
                            radiusY: 20
                            direction: PathArc.Counterclockwise
                        }

                        PathLine{
                            relativeY: wrapper.height - 40
                            relativeX: 0
                        }

                        PathArc{
                            relativeX: -20
                            relativeY: 20
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }

                    }
                }

                Rectangle{
                    id: rect
                    width: parent.width
                    height: parent.height - 40
                    color: colors.surface
                    topRightRadius: 20
                    bottomRightRadius: 20
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    Column{
                        anchors.fill: parent
                        visible: rect.width === 300
                        Item{
                            width: parent.width
                            height: 60

                            Rectangle{
                                anchors.centerIn: parent
                                implicitHeight: parent.height - 20
                                implicitWidth: parent.width - 10
                                color: colors.surfaceContainerHigh
                                radius: 10
                                
                               RowLayout{ 
                                   anchors.fill: parent
                                   Rectangle{
                                       color: colors.primaryContainer
                                       topLeftRadius: 20
                                       topRightRadius: 20
                                       bottomRightRadius: 20
                                       Layout.minimumWidth: 40
                                       Layout.minimumHeight: parent.height
                                       Image{
                                           anchors.centerIn: parent
                                           width: 26
                                           height: 26
                                           sourceSize: Qt.size(width, height)
                                           source: "./assets/search.svg"

                                       }
                                   }
                                   TextInput{
                                        id:input
                                        focus: true
                                        clip: true
                                        Layout.fillWidth: true
                                        text: appLauncherWindow.searchText
                                        color: colors.surfaceText
                                        font.pixelSize: 18
                                        font.weight: 800
                                        
                                        onTextChanged: {
                                            appLauncherWindow.searchText = text
                                        }

                                        onAccepted:{
                                            appLauncherWindow.currentFilteredApps[appLauncherWindow.selectedIndex].execute()
                                            text = ""
                                            appLauncherWindow.close()
                                        }
                                        
                                        Keys.onEscapePressed: {
                                            appLauncherWindow.close()
                                        }
                                    }
                                }
                            }
                        }
                    
                        ClippingWrapperRectangle{
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitWidth: parent.width - 10
                            implicitHeight: parent.height - 70
                            radius: 10
                            color: "transparent"
                    ListView{
                        id: list
                        model: appLauncherWindow.currentFilteredApps

                        anchors.fill: parent                        
                        orientation: Qt.Vertical
                        spacing: 10
                        clip: true

                        Behavior on visible{
                            NumberAnimation{
                                duration: 100
                                easing.type: Easing.InQuad
                            }
                        }

                        delegate: Item{
                            id: wrapper
                            width: list.width
                            height: 80

                            Rectangle{
                                anchors.fill: parent
                                color: appLauncherWindow.selectedIndex === index ? colors.primaryContainer: colors.surfaceContainerHigh
                                radius: 10

                                Row{
                                    anchors.fill: parent
                                    Item{
                                        id: image
                                        height: parent.height
                                        width: 60
                                        Image{
                                            anchors.centerIn: parent
                                            width: 50
                                            height: 50
                                            source: Quickshell.iconPath(modelData.icon, true)
                                            sourceSize: Qt.size(width, height)
                                        }
                                    }
                                    Item{
                                        id: details
                                        height: parent.height
                                        width: parent.width - 60

                                        Text{
                                            anchors.left: parent.left
                                            anchors.margins: 10
                                            text: modelData.name
                                            font.pixelSize: 16
                                            color: colors.surfaceText
                                            font.weight: 800
                                        }
                                    }
                                }
                            }
                            MouseArea{
                                id: appIconArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered:{
                                    appLauncherWindow.selectedIndex = index
                                }
                                onClicked:{
                                    modelData.execute()
                                    appLauncherWindow.close()
                                }
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
                    appLauncherWindow.visible = false
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
                
                // Stage 2: Width 30 → 300 (full panel slides out)
                NumberAnimation {
                    target: rect
                    property: "width"
                    from: 30
                    to: 300
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
            
            SequentialAnimation {
                id: closeAnimation
                
                // Reverse: Width 300 → 30
                NumberAnimation {
                    target: rect
                    property: "width"  
                    from: 300
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
                appLauncherWindow.visible = true
                openAnimation.start()
                input.forceActiveFocus()
            }

            function close(){
                closeAnimation.start()
            }
        }
    }
}
