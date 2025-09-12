import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import qs.util

Scope{
    id: root 
    property var activePanels: Quickshell.globalPanels || (Quickshell.globalPanels = {})
    property bool isResponeVisible: false
    ListModel {
        id: chatList
    }
    
    Colors {
        id: colors
    }
    
    // AI Backend instance
    AiBackend {
        id: aiBackend
        
        onResponseReceived: function(response) {
            //aipanel.responseArea.visible= true
            root.isResponeVisible = true
            chatList.append({from: "AI", text: response})
            console.log(chatList)
            aipanel.responseText.text = response
        }
        
        onErrorOccurred: function(errorMessage) {
            root.isResponeVisible = true
            chatList.append({from: "AI", text: "Error: " + errorMessage})
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
        implicitWidth: 500
        implicitHeight: isResponeVisible ? 600 : 70

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
            implicitHeight: parent.height
            implicitWidth: parent.width
            color: colors.surface
            radius: 10

            Behavior on implicitHeight{
                NumberAnimation{duration: 300; easing.type: Easing.OutCubic}
            }

            Column{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // Response display area
                Rectangle{
                    id: responseArea
                    width: parent.width
                    height: parent.height - inputArea.height - parent.spacing
                    color: colors.surfaceContainer
                    radius: 5
                    border.color: colors.outline
                    border.width: 1

                    visible: isResponeVisible



                    ListView{
                        id: chatListView
                        anchors.fill: parent
                        anchors.margins: 10
                        model: chatList
                        clip: true
                            
                            delegate: Item {
                                width: chatListView.width
                                height: messageContent.height + 20
                                Rectangle {
                                    id: messageBubble
                                    anchors.fill: parent
                                    anchors.margins: 5
                                    color: model.from === "You" ? colors.surfaceVariant : colors.surfaceContainer
                                    radius: 8
                                    border.color: model.from === "You" ? colors.outlineVariant : colors.outline
                                    border.width: 1

                                    Column {
                                        id: messageContent
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.top
                                        anchors.margins: 10
                                        spacing: 5
                                        
                                        Text {
                                            text: model.from + ":"
                                            color: model.from === "You" ? colors.primary : colors.tertiary
                                            font.bold: true
                                            font.pixelSize: 12
                                        }
                                        
                                        TextArea {
                                            width: parent.width
                                            text: model.text || "No text"
                                            color: colors.surfaceText
                                            textFormat: TextArea.MarkdownText
                                            wrapMode: TextArea.Wrap
                                            readOnly: true
                                            selectByMouse: true
                                            background: Rectangle { color: "transparent" }
                                            padding: 0
                                        }
                                    }
                                }
                            }
                            
                            // Auto-scroll to bottom when new messages are added
                            onCountChanged: {
                                Qt.callLater(function() {
                                    if (count > 0) {
                                        positionViewAtEnd()
                                    }
                                })
                            }
                        }
                        
                        // Hidden TextArea for compatibility (referenced by backend)
                        TextArea {
                            id: responseText
                            visible: false
                            text: ""
                        }
                }

                // Input area
                Rectangle{
                    id: inputArea
                    width: parent.width
                    height: 50
                    color: colors.surfaceVariant
                    radius: 10
                    border.color: aiBackend.isLoading ? colors.tertiary : (input.activeFocus ? colors.primary : colors.outline)
                    border.width: 1

                    TextInput{
                        id: input
                        anchors.fill: parent
                        anchors.margins: 10
                        text: "Type your question..."
                        color: colors.surfaceText
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
                                chatList.append({from: "You", text: text.trim()})
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
