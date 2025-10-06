import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import QtQuick.Layouts

Flickable{
    id: root
    contentHeight: themeSection.implicitHeight + 50
    clip: true

    Rectangle{
        width: parent.width
        height: themeSection.implicitHeight + 30
        radius: 16
        color: Colors.surfaceContainer

        ColumnLayout{
            id: themeSection
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12

        // Section header
        RowLayout{
            spacing: 8
            Image{
                width: 24
                height: 24
                source: IconUtils.getSystemIcon("clear")
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                layer.effect: MultiEffect{
                    brightness: 1
                    colorization: 1.0
                    colorizationColor: Colors.primary
                }
            }
            StyledText{
                content: "Theme Colors"
                size: 18
                font.weight: 600
                color: Colors.primary
            }
        }

        // Color palette
        Flow{
            Layout.fillWidth: true
            spacing: 12

            Repeater{
                model: [
                    {color: Colors.primary, name: "Primary"},
                    {color: Colors.secondary, name: "Secondary"},
                    {color: Colors.tertiary, name: "Tertiary"},
                    {color: Colors.error, name: "Error"},
                    {color: Colors.surface, name: "Surface"},
                    {color: Colors.surfaceVariant, name: "Surface Variant"}
                ]

                RowLayout{
                    spacing: 8

                    Rectangle{
                        width: 32
                        height: 32
                        radius: 16
                        color: modelData.color
                        border.color: Colors.outline
                        border.width: 1

                        layer.enabled: true
                        layer.effect: MultiEffect{
                            shadowEnabled: true
                            shadowBlur: 0.2
                            shadowOpacity: 0.2
                            shadowColor: Qt.alpha(Colors.shadow, 0.5)
                            shadowHorizontalOffset: 0
                            shadowVerticalOffset: 2
                        }
                    }

                    StyledText{
                        content: modelData.name
                        size: 12
                        color: Colors.surfaceText
                        opacity: 0.8
                    }
                }
            }
        }

        StyledText{
            content: "Colors are automatically generated from system theme"
            size: 11
            color: Colors.surfaceText
            opacity: 0.6
            Layout.topMargin: 4
        }
        }
    }
}