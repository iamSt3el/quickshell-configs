import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Shapes
import Quickshell.Hyprland
import qs.util


Scope{
    id: appLauncherRoot
    property var activePanels: Quickshell.globalAppLauncherPanels || (Quickshell.globalAppLauncherPanels = {})
    
    Colors {
        id: colors
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
                            panel.visible = !panel.visible;
                            if(panel.visible){
                                panel.searchInput.forceActiveFocus();
                                panel.searchInput.text = "";
                            }
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
            required property var modelData
            implicitHeight: 600
            implicitWidth: 400
            visible: false
            property alias searchInput: input
            property string searchText: ""
            property var currentFilteredApps: DesktopEntries.applications
            property int selectedIndex: 0
            
            onSearchTextChanged: {
                currentFilteredApps = getFilteredApps();
                selectedIndex = 0;
            }
            
            Component.onCompleted: {
                appLauncherRoot.activePanels[modelData.name] = this;
            }
            
            function getFilteredApps() {
                var searchTerm = searchText.toLowerCase().trim();
              
                if (searchTerm === "" || searchTerm === "search.." || searchTerm === "Search..") {
                    return DesktopEntries.applications;
                }

                
                var filtered = [];
                for (var i = 0; i < DesktopEntries.applications.values.length; i++) {
                    var app = DesktopEntries.applications.values[i];
                    var name = app.name ? app.name.toLowerCase() : "";
                    var description = app.description ? app.description.toLowerCase() : "";
                    var exec = app.exec ? app.exec.toLowerCase() : "";
                    
                    // Simple fuzzy matching - check if characters appear in order
                    if (fuzzyMatch(name, searchTerm) || 
                        fuzzyMatch(description, searchTerm) || 
                        fuzzyMatch(exec, searchTerm) ||
                        name.includes(searchTerm)) {
                        filtered.push(app);
                    }
                }
                return filtered;
            }
            
            function fuzzyMatch(text, pattern) {
                var textIndex = 0;
                var patternIndex = 0;
                
                while (textIndex < text.length && patternIndex < pattern.length) {
                    if (text[textIndex] === pattern[patternIndex]) {
                        patternIndex++;
                    }
                    textIndex++;
                }
                
                return patternIndex === pattern.length;
            }
            anchors{
                bottom: true
            }
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            exclusionMode: ExclusionMode.Normal
            color: "transparent"

            Item{
                id: wrapper
                anchors.fill: parent

                Shape{
                    preferredRendererType: Shape.CurveRenderer
                    ShapePath{
                        fillColor: colors.surface
                        strokeWidth: 0

                        startX: wrapper.x
                        startY: wrapper.height

                        PathArc{
                            relativeX: 20
                            relativeY: -20
                            radiusX: 20
                            radiusY: 20
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

                Rectangle{
                    implicitWidth: parent.width - 40
                    implicitHeight: parent.height

                    color: colors.surface
                    topLeftRadius: 20
                    topRightRadius: 20
                    anchors{
                        horizontalCenter: parent.horizontalCenter
                    }

                    Column{
                        anchors.fill: parent

                        Rectangle{
                            implicitWidth: parent.width - 40
                            implicitHeight: 40
                            color: colors.surfaceVariant
                            radius: 10
                            anchors{
                                //top: parent.top
                                topMargin: 20
                                horizontalCenter: parent.horizontalCenter
                            }

                            TextInput{
                                id: input
                                anchors.fill: parent
                                anchors.margins: 10
                                text: "Search.."
                                color: colors.surfaceText
                                clip: true
                                selectByMouse: true
                                
                                onActiveFocusChanged: {
                                    if (activeFocus && text === "Search..") {
                                        text = "";
                                    }
                                }
                                
                                onTextChanged: {
                                    if (text !== "Search..") {
                                        searchText = text;
                                    }
                                }
                                
                                Keys.onReturnPressed: {
                                    if (currentFilteredApps.length > 0) {
                                        currentFilteredApps.values[selectedIndex].execute();
                                        visible = false;
                                    }
                                }
                                
                                Keys.onUpPressed: {
                                    if (selectedIndex > 0) {
                                        selectedIndex--;
                                    }
                                }
                                
                                Keys.onDownPressed: {
                                    if (selectedIndex < currentFilteredApps.values.length - 1) {
                                        selectedIndex++;
                                    }
                                }
                                
                                Keys.onEscapePressed: {
                                    visible = false;
                                }
                            }
                        }

                        GridView{
                            width: parent.width
                            height: parent.height - 60
                            cellWidth: 110
                            cellHeight: 110
                            topMargin: 10
                            leftMargin: 20
                            model: currentFilteredApps
                            z: -1

                            delegate: Rectangle{
                                implicitHeight: 100
                                implicitWidth: 100
                                color: iconArea.containsMouse ? colors.primaryContainer : (index === selectedIndex ? colors.primaryContainer : "transparent")

                                radius: 10

                                Behavior on color{
                                    ColorAnimation{duration: 100}
                                }

                                Image{
                                    anchors.centerIn: parent
                                    width: 60
                                    height: 60
                                    sourceSize: Qt.size(width, height)
                                    source: Quickshell.iconPath(modelData.icon)
                                }

                                MouseArea{
                                    id: iconArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered: {
                                        selectedIndex = index;
                                    }
                                    onClicked:{
                                        modelData.execute();
                                        visible = false;
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
