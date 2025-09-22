import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util
import qs.components
import Quickshell.Widgets
import QtQuick.Layouts


Scope{
    id: appLauncherRoot
    property var activePanels: Quickshell.globalAppLauncherPanels || (Quickshell.globalAppLauncherPanels = {})
    

    
    // Use LazyLoader for non-Item components to save memory
    LazyLoader {
        id: fuzzySearchLoader
        loading: false
        source: "FuzzySearch.qml"
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
            property var currentFilteredApps: []
            property int selectedIndex: 0
            property bool appsLoaded: false
            focusable: true
            
            onSearchTextChanged: {
                if (searchText.length > 0 && !fuzzySearchLoader.loading) {
                    fuzzySearchLoader.loading = true
                }
                
                if (!DesktopEntries.applications) {
                    currentFilteredApps = []
                    selectedIndex = 0
                    return
                }
                
                if (fuzzySearchLoader.item && searchText.length > 0) {
                    currentFilteredApps = fuzzySearchLoader.item.searchApplications(DesktopEntries.applications, searchText);
                } else if (searchText === "") {
                    currentFilteredApps = DesktopEntries.applications.values.slice(0, 20) // Limit to 20 apps initially
                } else {
                    currentFilteredApps = []
                }
                selectedIndex = 0;
                console.log("Filtered apps count:", currentFilteredApps.length)
            }
            
            Component.onCompleted: {
                appLauncherRoot.activePanels[modelData.name] = this;
                // Load initial apps
                if (DesktopEntries.applications) {
                    currentFilteredApps = DesktopEntries.applications.values.slice(0, 20)
                }
            }
            
         
            anchors{
                left: true
            }
            WlrLayershell.layer: WlrLayer.Overlay
            //WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
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
                        fillColor: Colors.surface
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
                    color: Colors.surface
                    topRightRadius: 20
                    bottomRightRadius: 20
                    anchors{
                        verticalCenter: parent.verticalCenter
                    }

                    // Use separate component for better memory management
                    AppLauncherContent {
                        id: launcherContent
                        searchText: appLauncherWindow.searchText
                        filteredApps: appLauncherWindow.currentFilteredApps
                        selectedIndex: appLauncherWindow.selectedIndex
                        
                        onSearchChanged: function(text) {
                            appLauncherWindow.searchText = text
                        }
                        
                        onAppSelected: function(app) {
                            app.execute()
                            appLauncherWindow.close()
                            launcherContent.clearSearch()
                        }
                        
                        onIndexChanged: function(newIndex) {
                            appLauncherWindow.selectedIndex = newIndex
                        }
                        
                        onCloseRequested: {
                            appLauncherWindow.close()
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
                launcherContent.focusSearchInput()
            }

            function close(){
                closeAnimation.start()
            }
        }
    }
}
