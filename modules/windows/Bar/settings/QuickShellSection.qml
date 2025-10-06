import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import QtQuick.Layouts

Flickable{
    id: root
    contentHeight: quickshellSection.implicitHeight + 50
    clip: true

    Rectangle{
        width: parent.width
        height: quickshellSection.implicitHeight + 30
        radius: 16
        color: Colors.surfaceContainer

        ColumnLayout{
            id: quickshellSection
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12

        // Section header
        RowLayout{
            spacing: 8
            Image{
                width: 24
                height: 24
                source: IconUtils.getSystemIcon("setting")
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                layer.effect: MultiEffect{
                    brightness: 1
                    colorization: 1.0
                    colorizationColor: Colors.primary
                }
            }
            StyledText{
                content: "QuickShell"
                size: 18
                font.weight: 600
                color: Colors.primary
            }
        }

        // Info rows
        ColumnLayout{
            Layout.fillWidth: true
            spacing: 6

            // Version
            RowLayout{
                Layout.fillWidth: true
                StyledText{
                    content: "Version"
                    size: 13
                    color: Colors.surfaceText
                    Layout.preferredWidth: 80
                }
                StyledText{
                    content: "QuickShell 0.3.0"
                    size: 13
                    color: Colors.surfaceText
                    opacity: 0.8
                    Layout.fillWidth: true
                }
            }

            // Config path
            RowLayout{
                Layout.fillWidth: true
                StyledText{
                    content: "Config"
                    size: 13
                    color: Colors.surfaceText
                    Layout.preferredWidth: 80
                }
                StyledText{
                    content: Quickshell.shellPath("")
                    size: 13
                    color: Colors.surfaceText
                    opacity: 0.8
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }
            }

            // Shell path
            RowLayout{
                Layout.fillWidth: true
                StyledText{
                    content: "Shell"
                    size: 13
                    color: Colors.surfaceText
                    Layout.preferredWidth: 80
                }
                StyledText{
                    content: Quickshell.shellPath("")
                    size: 13
                    color: Colors.surfaceText
                    opacity: 0.8
                    elide: Text.ElideMiddle
                    Layout.fillWidth: true
                }
            }
        }

        // Action buttons
        Flow{
            Layout.fillWidth: true
            spacing: 8

            Rectangle{
                width: 140
                height: 36
                radius: 18
                color: Colors.primary

                RowLayout{
                    anchors.centerIn: parent
                    spacing: 6

                    Image{
                        width: 16
                        height: 16
                        source: IconUtils.getSystemIcon("reload")
                        sourceSize: Qt.size(width, height)
                        layer.enabled: true
                        layer.effect: MultiEffect{
                            brightness: 1
                            colorization: 1.0
                            colorizationColor: Colors.primaryText
                        }
                    }

                    StyledText{
                        content: "Reload Shell"
                        size: 13
                        color: Colors.primaryText
                        font.weight: 500
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.reload(false)

                    Rectangle{
                        anchors.fill: parent
                        color: Qt.alpha(Colors.primaryText, 0.1)
                        radius: 18
                        visible: parent.containsMouse
                    }
                }
            }

            Rectangle{
                width: 120
                height: 36
                radius: 18
                color: Colors.surfaceVariant
                border.color: Colors.outline
                border.width: 1

                RowLayout{
                    anchors.centerIn: parent
                    spacing: 6

                    Image{
                        width: 16
                        height: 16
                        source: IconUtils.getSystemIcon("setting")
                        sourceSize: Qt.size(width, height)
                        layer.enabled: true
                        layer.effect: MultiEffect{
                            brightness: 1
                            colorization: 1.0
                            colorizationColor: Colors.surfaceVariantText
                        }
                    }

                    StyledText{
                        content: "Open Config"
                        size: 13
                        color: Colors.surfaceVariantText
                        font.weight: 500
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // Open config directory
                        Qt.openUrlExternally(Quickshell.shellPath(""))
                    }

                    Rectangle{
                        anchors.fill: parent
                        color: Qt.alpha(Colors.surfaceVariantText, 0.1)
                        radius: 18
                        visible: parent.containsMouse
                    }
                }
            }
        }
        }
    }
}