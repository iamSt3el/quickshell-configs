pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.settings

Singleton {
    id: root

    property bool isLoading: false
    property bool isStreaming: false
    property bool hasError: false
    property string errorMessage: ""
    property string streamingText: ""
    property var chatHistory: []

    readonly property string apiKey: SettingsConfig.ai.googleApiKey
    readonly property string model: "gemini-3-flash-preview"
    readonly property string apiUrl: "https://generativelanguage.googleapis.com/v1beta/models/" + model + ":generateContent"

    // private typing state
    property string _fullResponse: ""
    property int _streamIdx: 0

    Timer {
        id: typeTimer
        interval: 12
        repeat: true
        onTriggered: {
            let end = Math.min(root._streamIdx + 4, root._fullResponse.length)
            root.streamingText = root._fullResponse.substring(0, end)
            root._streamIdx = end
            if (end >= root._fullResponse.length) {
                typeTimer.stop()
                root.isStreaming = false
                root.chatHistory = [...root.chatHistory, { role: "model", text: root._fullResponse }]
                root.streamingText = ""
                root._streamIdx = 0
                root._fullResponse = ""
            }
        }
    }

    function sendMessage(userMessage) {
        if (isLoading || isStreaming || userMessage.trim() === "") return

        if (apiKey === "") {
            root.hasError = true
            root.errorMessage = "No API key set. Add your Google AI key in Settings → AI."
            return
        }

        root.isLoading = true
        root.hasError = false
        root.errorMessage = ""

        root.chatHistory = [...root.chatHistory, { role: "user", text: userMessage }]

        let contents = root.chatHistory.map(msg => ({
            role: msg.role === "model" ? "model" : "user",
            parts: [{ text: msg.text }]
        }))

        let bodyStr = JSON.stringify({ contents: contents })
        let escapedBody = bodyStr.replace(/'/g, "'\\''")
        let cmd = "printf '%s' '" + escapedBody + "' | curl -s -X POST '" + root.apiUrl + "' -H 'Content-Type: application/json' -H 'x-goog-api-key: " + root.apiKey + "' -d @-"
        aiProcess.command[2] = cmd
        aiProcess.running = true
    }

    function clearHistory() {
        typeTimer.stop()
        root.chatHistory = []
        root.hasError = false
        root.errorMessage = ""
        root.streamingText = ""
        root.isStreaming = false
        root.isLoading = false
        root._streamIdx = 0
        root._fullResponse = ""
    }

    Process {
        id: aiProcess
        command: ["bash", "-c", ""]

        stdout: StdioCollector {
            onStreamFinished: {
                root.isLoading = false
                if (text.length === 0) {
                    root.hasError = true
                    root.errorMessage = "Empty response from API."
                    root.chatHistory = root.chatHistory.slice(0, -1)
                    return
                }

                try {
                    const data = JSON.parse(text)

                    if (data.error) {
                        root.hasError = true
                        root.errorMessage = data.error.message || "API error"
                        root.chatHistory = root.chatHistory.slice(0, -1)
                        return
                    }

                    if (data.candidates && data.candidates.length > 0) {
                        const responseText = data.candidates[0].content.parts[0].text
                        root._fullResponse = responseText
                        root._streamIdx = 0
                        root.streamingText = ""
                        root.isStreaming = true
                        typeTimer.start()
                    } else {
                        root.hasError = true
                        root.errorMessage = "No response candidates returned."
                        root.chatHistory = root.chatHistory.slice(0, -1)
                    }
                } catch (e) {
                    root.hasError = true
                    root.errorMessage = "Failed to parse API response."
                    root.chatHistory = root.chatHistory.slice(0, -1)
                    console.error("ServiceAi parse error:", e.message, "\nRaw:", text)
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {}
        }
    }
}
