import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents
import Quickshell.Widgets

Item {
    id: root
    anchors.fill: parent

    NumberAnimation on scale { from: 0.9; to: 1; duration: 200 }
    NumberAnimation on opacity { from: 0; to: 1; duration: 200 }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // ── Chat Area ─────────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Empty state
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 10
                visible: ServiceAi.chatHistory.length === 0 && !ServiceAi.isLoading && !ServiceAi.isStreaming && !ServiceAi.hasError

                MaterialIconSymbol {
                    Layout.alignment: Qt.AlignHCenter
                    content: "auto_awesome"
                    iconSize: 38
                    color: Colors.outline
                }
                CustomText {
                    Layout.alignment: Qt.AlignHCenter
                    content: "How can I help you today?"
                    size: 15
                    color: Colors.outline
                }
                CustomText {
                    Layout.alignment: Qt.AlignHCenter
                    content: SettingsConfig.googleAiApiKey === "" ? "Add your API key in Settings → AI" : "Ask me anything"
                    size: 12
                    color: Colors.outlineVariant
                }
            }

            // Error state (no messages)
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8
                visible: ServiceAi.hasError && ServiceAi.chatHistory.length === 0 && !ServiceAi.isStreaming

                MaterialIconSymbol {
                    Layout.alignment: Qt.AlignHCenter
                    content: "error_outline"
                    iconSize: 30
                    color: Colors.error
                }
                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 220
                    text: ServiceAi.errorMessage
                    font.pixelSize: 12
                    font.family: Settings.defaultFont
                    color: Colors.error
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Messages scroll area
            Flickable {
                id: scrollArea
                anchors.fill: parent
                clip: true
                contentWidth: width
                contentHeight: Math.max(height, msgCol.y + msgCol.implicitHeight + 8)
                interactive: contentHeight > height

                // Auto-scroll to bottom on new content
                onContentHeightChanged: {
                    scrollArea.contentY = Math.max(0, contentHeight - height)
                }

                Column {
                    id: msgCol
                    width: scrollArea.width - 16
                    x: 8
                    // Push messages to the bottom when few
                    y: Math.max(8, scrollArea.height - implicitHeight - 8)
                    spacing: 10

                    Repeater {
                        model: ServiceAi.chatHistory

                        delegate: Item {
                            required property var modelData
                            required property int index
                            property bool isUser: modelData.role === "user"

                            width: msgCol.width
                            height: bubbleRect.implicitHeight

                            Rectangle {
                                id: bubbleRect
                                anchors.right: isUser ? parent.right : undefined
                                anchors.left: isUser ? undefined : parent.left
                                width: isUser
                                    ? Math.min(msgText.implicitWidth + 24, parent.width * 0.84)
                                    : parent.width * 0.96
                                // contentHeight of the inner Flickable + vertical padding
                                implicitHeight: msgFlick.implicitHeight + 18
                                radius: 18
                                color: isUser ? Colors.primary : Colors.surfaceContainerHigh
                                clip: true

                                opacity: 0
                                Component.onCompleted: fadeIn.start()

                                NumberAnimation {
                                    id: fadeIn
                                    target: bubbleRect
                                    property: "opacity"
                                    from: 0; to: 1
                                    duration: 250
                                    easing.type: Easing.OutQuad
                                }

                                // Flickable allows horizontal scroll for wide code blocks
                                // without breaking the bubble layout
                                Flickable {
                                    id: msgFlick
                                    anchors {
                                        left: parent.left; right: parent.right
                                        top: parent.top
                                        leftMargin: 12; rightMargin: 12; topMargin: 9
                                    }
                                    implicitHeight: msgText.implicitHeight
                                    height: implicitHeight
                                    // contentWidth = natural text width so code blocks can scroll
                                    contentWidth: msgText.implicitWidth
                                    contentHeight: msgText.implicitHeight
                                    clip: true
                                    interactive: contentWidth > width

                                    TextEdit {
                                        id: msgText
                                        // Normal text wraps; code blocks expand contentWidth
                                        width: msgFlick.width
                                        text: modelData.text
                                        textFormat: isUser ? TextEdit.PlainText : TextEdit.MarkdownText
                                        font.pixelSize: 13
                                        font.family: Settings.defaultFont
                                        color: isUser ? Colors.primaryText : Colors.surfaceVariantText
                                        wrapMode: TextEdit.Wrap
                                        readOnly: true
                                        selectByMouse: true
                                        selectedTextColor: isUser ? Colors.primary : Colors.primaryText
                                        selectionColor: isUser ? Colors.primaryText : Colors.primary
                                    }
                                }
                            }
                        }
                    }

                    // Loading dots
                    Rectangle {
                        visible: ServiceAi.isLoading
                        width: 64
                        height: 36
                        radius: 18
                        color: Colors.surfaceContainerHigh

                        Row {
                            anchors.centerIn: parent
                            spacing: 5

                            Repeater {
                                model: 3
                                Rectangle {
                                    required property int index
                                    width: 7; height: 7; radius: 3.5
                                    color: Colors.outline

                                    SequentialAnimation on opacity {
                                        running: ServiceAi.isLoading
                                        loops: Animation.Infinite
                                        PauseAnimation { duration: index * 180 }
                                        NumberAnimation { to: 0.15; duration: 500; easing.type: Easing.InOutSine }
                                        NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutSine }
                                    }
                                }
                            }
                        }
                    }

                    // Streaming / typewriter bubble
                    Rectangle {
                        visible: ServiceAi.isStreaming
                        width: Math.min(streamText.implicitWidth + 24, msgCol.width * 0.84)
                        implicitHeight: streamText.implicitHeight + 18
                        radius: 18
                        color: Colors.surfaceContainerHigh

                        Text {
                            id: streamText
                            anchors {
                                left: parent.left; right: parent.right
                                top: parent.top
                                leftMargin: 12; rightMargin: 12; topMargin: 9
                            }
                            text: ServiceAi.streamingText
                            textFormat: Text.PlainText
                            font.pixelSize: 13
                            font.family: Settings.defaultFont
                            color: Colors.surfaceVariantText
                            wrapMode: Text.WordWrap
                        }

                        // Blinking cursor
                        Rectangle {
                            anchors.left: streamText.left
                            anchors.top: streamText.bottom
                            anchors.topMargin: 2
                            width: 2
                            height: 14
                            radius: 1
                            color: Colors.primary
                            visible: ServiceAi.isStreaming

                            SequentialAnimation on opacity {
                                running: ServiceAi.isStreaming
                                loops: Animation.Infinite
                                NumberAnimation { to: 0; duration: 500 }
                                NumberAnimation { to: 1; duration: 500 }
                            }
                        }
                    }
                }
            }
        }

        // Error banner (with existing messages)
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 30
            radius: 10
            color: Colors.errorContainer
            visible: ServiceAi.hasError && (ServiceAi.chatHistory.length > 0 || ServiceAi.isStreaming)

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6
                MaterialIconSymbol { content: "error_outline"; iconSize: 14; color: Colors.error }
                Text {
                    Layout.fillWidth: true
                    text: ServiceAi.errorMessage
                    font.pixelSize: 11
                    font.family: Settings.defaultFont
                    color: Colors.error
                    elide: Text.ElideRight
                }
            }
        }

        // ── Input Bar (original style) ────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            radius: 20
            color: Colors.surfaceContainerHigh

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 0

                // Greeting text — only when no conversation yet
                TextField {
                    id: inputField
                    Layout.fillWidth: true
                    placeholderText: "Message Gemini..."
                    background: null
                    color: Colors.surfaceVariantText
                    placeholderTextColor: Colors.outline
                    selectionColor: Colors.primary
                    font.pixelSize: 13
                    font.family: Settings.defaultFont
                    verticalAlignment: TextInput.AlignVCenter
                    enabled: !ServiceAi.isLoading && !ServiceAi.isStreaming

                    Keys.onReturnPressed: event => {
                        if (!(event.modifiers & Qt.ShiftModifier)) sendMsg()
                    }
                }

                Item { Layout.fillHeight: true }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    // New chat
                    MaterialIconSymbol {
                        content: ServiceAi.chatHistory.length > 0 || ServiceAi.isStreaming ? "edit_square" : "add"
                        iconSize: 22
                        color: Colors.outline

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: ServiceAi.chatHistory.length > 0 || ServiceAi.isStreaming
                            onClicked: ServiceAi.clearHistory()
                        }
                    }

                    Item { Layout.fillWidth: true }



                    Item { Layout.fillWidth: true }

                    CustomText {
                        content: "gemini-3-flash"
                        size: 12
                        color: Colors.outline
                    }

                    Rectangle {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        radius: 10
                        color: canSend ? Colors.primary : Colors.surfaceContainer

                        property bool canSend: inputField.text.trim() !== "" && !ServiceAi.isLoading && !ServiceAi.isStreaming

                        Behavior on color { ColorAnimation { duration: 150 } }

                        MaterialIconSymbol {
                            anchors.centerIn: parent
                            content: "send"
                            iconSize: 18
                            color: parent.canSend ? Colors.primaryText : Colors.outline
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            enabled: parent.canSend
                            onClicked: sendMsg()
                        }
                    }
                }
            }
        }
    }

    function sendMsg() {
        let msg = inputField.text.trim()
        if (msg === "" || ServiceAi.isLoading || ServiceAi.isStreaming) return
        inputField.text = ""
        ServiceAi.sendMessage(msg)
    }
}
