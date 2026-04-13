import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents


Item {
    id: toolWidgets
    anchors.centerIn: parent
    width: 300
    height: 300
    signal toogled
    signal settingClicked

    property bool open: false

    Component.onCompleted: Qt.callLater(() => open = true)

    function closeWidget() {
        open = false
        closeTimer.start()
    }

    Timer {
        id: closeTimer
        interval: 350
        onTriggered: toolWidgets.toogled()
    }

    Rectangle {
        id: container
        anchors.fill: parent
        color: "transparent"

        Rectangle {
            implicitHeight: 40
            implicitWidth: 40
            radius: width
            color: Settings.layoutColor
            anchors.centerIn: parent

            MaterialIconSymbol {
                visible: !ServiceTools.isRecording
                iconSize: 30
                content: "close"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (ServiceTools.isRecording) {
                        ServiceTools.stopRecording()
                    } else {
                        toolWidgets.closeWidget()
                    }
                }
            }
        }

        Repeater {
            id: repeater
            model: ServiceTools.tools

            delegate: Rectangle {
                id: icon
                property int iconIndex: index
                property bool showOptions: false
                implicitWidth: 50
                implicitHeight: 50
                radius: width
                color: Settings.layoutColor

                property var pos: Functions.getCirclePosition(
                    index,
                    ServiceTools.tools.length,
                    120 / 2,
                    container.width / 2,
                    container.height / 2
                )

                // Fly out from center on open, fly back on close
                x: toolWidgets.open ? pos.x : (toolWidgets.width - width) / 2
                y: toolWidgets.open ? pos.y : (toolWidgets.height - height) / 2

                Behavior on x {
                    SequentialAnimation {
                        PauseAnimation { duration: toolWidgets.open ? index * 60 : 0 }
                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                    }
                }
                Behavior on y {
                    SequentialAnimation {
                        PauseAnimation { duration: toolWidgets.open ? index * 60 : 0 }
                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                    }
                }

                scale: toolWidgets.open ? 1 : 0
                opacity: toolWidgets.open ? 1 : 0

                Behavior on scale {
                    SequentialAnimation {
                        PauseAnimation { duration: toolWidgets.open ? index * 60 : 0 }
                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                    }
                }
                Behavior on opacity {
                    SequentialAnimation {
                        PauseAnimation { duration: toolWidgets.open ? index * 60 : 0 }
                        NumberAnimation { duration: 200 }
                    }
                }

                MaterialIconSymbol {
                    iconSize: 30
                    anchors.centerIn: parent
                    content: modelData.icon
                }

                Item {
                    anchors.fill: parent
                    Repeater {
                        model: modelData.options
                        delegate: Item {
                            width: 50
                            height: 50

                            property var childPos: Functions.getFixedSpaceCirclePosition(
                                index, 3, 120 / 2,
                                icon.width / 2, icon.height / 2,
                                65, icon.iconIndex - 1
                            )

                            x: icon.showOptions ? childPos.x : icon.width / 2 - width / 2
                            y: icon.showOptions ? childPos.y : icon.height / 2 - height / 2

                            Behavior on x {
                                SequentialAnimation {
                                    PauseAnimation { duration: icon.showOptions ? index * 60 : 0 }
                                    NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                                }
                            }
                            Behavior on y {
                                SequentialAnimation {
                                    PauseAnimation { duration: icon.showOptions ? index * 60 : 0 }
                                    NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                                }
                            }

                            Rectangle {
                                id: innerIcon
                                implicitWidth: 40
                                implicitHeight: 40
                                radius: width
                                anchors.centerIn: parent
                                color: Settings.layoutColor

                                scale: icon.showOptions ? 1 : 0
                                opacity: icon.showOptions ? 1 : 0

                                Behavior on scale {
                                    SequentialAnimation {
                                        PauseAnimation { duration: icon.showOptions ? index * 60 : 0 }
                                        NumberAnimation { duration: 300; easing.type: Easing.OutBack }
                                    }
                                }
                                Behavior on opacity {
                                    SequentialAnimation {
                                        PauseAnimation { duration: icon.showOptions ? index * 60 : 0 }
                                        NumberAnimation { duration: 200 }
                                    }
                                }

                                MaterialIconSymbol {
                                    iconSize: 20
                                    anchors.centerIn: parent
                                    content: modelData.icon
                                }
                               
                                MouseArea {
                                    anchors.fill: parent
                                    enabled: icon.showOptions
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        var parentTool = ServiceTools.tools[icon.iconIndex]
                                        if (parentTool.name === "Record") {
                                            var withAudio = modelData.audio || false
                                            ServiceTools.toggleRecording(modelData.name, withAudio)
                                            toolWidgets.closeWidget()
                                        } else if (modelData.command) {
                                            Quickshell.execDetached(modelData.command)
                                            toolWidgets.closeWidget()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: toolWidgets.open
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (modelData.options) {
                            icon.showOptions = !icon.showOptions
                        } else if (modelData.name === "Setting") {
                            toolWidgets.settingClicked()
                            toolWidgets.closeWidget()
                        }
                    }
                }
            }
        }
    }
}
