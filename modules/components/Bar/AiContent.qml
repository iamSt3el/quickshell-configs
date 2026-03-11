import Quickshell
import Quickshell.Widgets
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
    Rectangle{
        anchors.fill: parent
        anchors.margins: 10
        radius: 20
        color: Colors.surfaceContainer
        ColumnLayout{
            anchors.fill: parent
            spacing: 16
            Item{
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                RowLayout{
                    anchors.fill: parent
                    anchors.margins: 10
                   
                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 90
                        topLeftRadius: 10
                        bottomLeftRadius: 10
                        topRightRadius: 5
                        bottomRightRadius: 5
                        color: Colors.primary
                        CustomText{
                            anchors.centerIn: parent
                            content: "Chat History"
                            size: 14
                            color: Colors.primaryText
                        }
                    }

                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        topLeftRadius: 5
                        bottomLeftRadius: 5
                        topRightRadius: 10
                        bottomRightRadius: 10
                        color: Colors.primary
                        MaterialIconSymbol{
                            anchors.centerIn: parent
                            content: "settings"
                            iconSize: 20
                            color: Colors.primaryText
                        }
                    }
                    Item{
                        Layout.fillWidth: true
                    }

                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: row.implicitWidth + 10
                        radius: 10
                        color: Colors.primary
                        RowLayout{
                            id: row
                            anchors.centerIn: parent
                            MaterialIconSymbol{
                                content: "add"
                                iconSize: 20
                                color: Colors.primaryText
                            }
                            CustomText{
                                content: "New Chat"
                                size: 14
                                color: Colors.primaryText
                            }
                        }

                    }
                }
            }

            
            // Messages scroll area
            ClippingWrapperRectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.bottomMargin: Math.min(200, 70 + inputField.implicitHeight) + 4
                radius: 20
                color: "transparent"
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
                        visible: !ServiceAi.hasError

                        Repeater {
                            model: ScriptModel{
                                values:  ServiceAi.chatHistory
                            }

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
                                    topLeftRadius: 20
                                    topRightRadius: 20
                                    bottomLeftRadius: 20
                                    bottomRightRadius: 5
                                    color: isUser ? Colors.primary : "transparent"
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
                            width: msgCol.width * 0.96
                            implicitHeight: streamText.implicitHeight + 18
                            radius: 18
                            color: "transparent"

                            Text {
                                id: streamText
                                x: 12
                                y: 9
                                width: parent.width - 24
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
        }
        // Centered error overlay
        Column {
            anchors.centerIn: parent
            spacing: 8
            visible: ServiceAi.hasError
            width: 220

            MaterialIconSymbol {
                anchors.horizontalCenter: parent.horizontalCenter
                content: "error_outline"
                iconSize: 30
                color: Colors.error
            }
            CustomText {
                width: parent.width
                content: ServiceAi.errorMessage
                size: 12
                color: Colors.error
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
            }
        }

        Rectangle{
            implicitWidth: parent.width
            implicitHeight:Math.min(200, 70 + inputField.implicitHeight)
            anchors.bottom: parent.bottom
            radius: 15
            color: Colors.surfaceContainerHigh
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10
                TextField{
                    id: inputField
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    font.pixelSize: 16
                    wrapMode: TextArea.Wrap
                    background: null
                    color: Colors.surfaceText
                    font.family: Settings.defaultFont
                    verticalAlignment: TextInput.AlignVCenter
                    placeholderText: "ask anything...."
                    enabled: !ServiceAi.isLoading && !ServiceAi.isStreaming
                    Keys.onReturnPressed: event => {
                        if (!(event.modifiers & Qt.ShiftModifier)) sendMsg()
                    }
                }
                RowLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 5
                    spacing: 15
                    MaterialIconSymbol{
                        content: "attachment"
                        iconSize: 20
                        color: Colors.outline
                    }
                    MaterialIconSymbol{
                        content: "image"
                        iconSize: 20
                        color: Colors.outline
                    }
                    MaterialIconSymbol{
                        content: "language"
                        iconSize: 20
                        color: Colors.outline
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    CustomText{
                        content: "gemini-3-flash"
                        size: 14
                        color: Colors.outline
                    }
                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 30
                        radius: 10
                        color: canSend ? Colors.primary : Colors.outline
                        property bool canSend: inputField.text.trim() !== "" && !ServiceAi.isLoading && !ServiceAi.isStreaming
                        MaterialIconSymbol{
                            anchors.centerIn: parent
                            content: "send"
                            iconSize: 20
                            color: Colors.primaryText
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
