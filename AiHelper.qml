import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope{
    id: root 
    property var activePanels: Quickshell.globalPanels || (Quickshell.globalPanels = {})
    
    // AI Backend instance
    AiBackend {
        id: aiBackend
        
        onResponseReceived: function(response) {
            aipanel.responseText.text = response
        }
        
        onErrorOccurred: function(errorMessage) {
            aipanel.responseText.text = errorMessage
        }
        
        onLoadingStateChanged: function(loading) {
            if (loading) {
                aipanel.responseText.text = "🤖 Thinking..."
            }
        }
    }

    IpcHandler{
        target: "ai"

        function togglePanel(): void{
            var focusedMonitor = Hyprland.focusedMonitor

            if(focusedMonitor){
                for(var i = 0; i < Quickshell.screens.length; i++){
                    var screen = Quickshell.screens[i];
                    var hyprMonitor = Hyprland.monitorFor(screen);
                    if(hyprMonitor && hyprMonitor.name === focusedMonitor.name){
                        var panel = root.activePanels[screen.name];
                        if(panel){
                            panel.setPosition()
                            //panel.visible = !panel.visible
                            return;
                        }
                    }
                }
            }
        }
    }

    PanelWindow{
        id: aipanel
        visible: false
        property int mouseX: 0
        property int mouseY: 0
        property alias responseText: responseText


       // mask: Region{}
        implicitWidth: 600
        implicitHeight: 400

        Component.onCompleted: {
            // Register panel for all screens
            for(var i = 0; i < Quickshell.screens.length; i++){
                var screen = Quickshell.screens[i];
                root.activePanels[screen.name] = aipanel;
            }
        }


        /*anchor{
            window: topBar
            rect.x: mouseX + 10
            rect.y: mouseY + 10
        }*/

        anchors{
            left: true
            top: true
        }

        margins{
            left: mouseX 
            top: mouseY - 40
        }


        function setPosition(){
            cursorProcess.running = true
        }

        Process{
            id: cursorProcess
            command: ["hyprctl", "cursorpos"]
            running: false

            stdout: StdioCollector{
                onStreamFinished:{
                    let coords = this.text.trim().split(", ")
                    if(coords.length === 2){
                        aipanel.mouseX = parseInt(coords[0])
                        aipanel.mouseY = parseInt(coords[1])
                    }

                    aipanel.visible = !aipanel.visible
                    if (aipanel.visible) {
                        input.forceActiveFocus()
                    }

                }
            }
        }
        color: "transparent" 
        WlrLayershell.keyboardFocus: aipanel.visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        Rectangle{
            anchors.fill: parent
            color: "#11111b"
            radius: 10

            Column{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // Response display area
                Rectangle{
                    id: responseArea
                    width: parent.width
                    height: parent.height - inputArea.height - parent.spacing
                    color: "#1e1e2e"
                    radius: 5
                    border.color: "#45475a"
                    border.width: 1

                    ScrollView{
                        anchors.fill: parent
                        anchors.margins: 10

                        TextArea{
                            id: responseText
                            text: "AI responses will appear here..."
                            color: "#cdd6f4"
                            readOnly: true
                            wrapMode: TextArea.Wrap
                            selectByMouse: true
                            background: Rectangle { color: "transparent" }
                        }
                    }
                }

                // Input area
                Rectangle{
                    id: inputArea
                    width: parent.width
                    height: 50
                    color: "#313244"
                    radius: 5
                    border.color: aiBackend.isLoading ? "#f9e2af" : (input.activeFocus ? "#89b4fa" : "#45475a")
                    border.width: 1

                    TextInput{
                        id: input
                        anchors.fill: parent
                        anchors.margins: 10
                        text: "Type your question..."
                        color: "#ffffff"
                        clip: true
                        selectByMouse: true
                        
                        onActiveFocusChanged: {
                            if (activeFocus && text === "Type your question...") {
                                text = ""
                            }
                        }
                        
                        Keys.onReturnPressed: {
                            if (text.trim() !== "" && text !== "Type your question..." && !aiBackend.isLoading) {
                                aiBackend.sendToGemini(text.trim())
                                text = ""
                            }
                        }
                        
                        enabled: !aiBackend.isLoading
                    }
                }
            }
        }
    }
}
