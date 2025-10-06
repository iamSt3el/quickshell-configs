import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components
import qs.modules.services
import QtQuick.Effects
import QtQuick.Layouts

Item{
    id: root

    Rectangle{
        width: parent.width
        height: quickSection.implicitHeight + 30
        radius: 16
        color: Colors.surfaceContainer

        ColumnLayout{
            id: quickSection
            anchors.fill: parent
            anchors.margins: 15
            spacing: 20

            // Header
            ColumnLayout{
                spacing: 8

                StyledText{
                    content: "Quick Settings"
                    size: 24
                    font.weight: 600
                    color: Colors.primary
                }

                StyledText{
                    content: "Customize your typography and display preferences"
                    size: 14
                    color: Colors.surfaceText
                    opacity: 0.7
                }
            }

            // Typography Section
            ColumnLayout{
                Layout.fillWidth: true
                spacing: 15

                // Section title with accent
                RowLayout{
                    spacing: 10

                    Rectangle{
                        width: 4
                        height: 24
                        radius: 2
                        color: Colors.primary
                    }

                    StyledText{
                        content: "Typography"
                        size: 18
                        font.weight: 600
                        color: Colors.surfaceText
                    }
                }

                // Font Family Setting
                ColumnLayout{
                    Layout.fillWidth: true
                    spacing: 8

                    StyledText{
                        content: "Font Family"
                        size: 14
                        color: Colors.surfaceText
                        font.weight: 500
                    }

                    StyledText{
                        content: "Choose your preferred typeface"
                        size: 12
                        color: Colors.surfaceText
                        opacity: 0.6
                    }

                    Rectangle{
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 36
                        radius: 6
                        color: Colors.surface
                        border.color: Colors.outline
                        border.width: 1

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 6

                            StyledText{
                                Layout.fillWidth: true
                                content: getFontDisplayName(ServiceDashboardSettings.settings.defaultFontFamily)
                                size: 13
                                color: Colors.surfaceText
                            }

                            Image{
                                width: 16
                                height: 16
                                source: IconUtils.getSystemIcon("down")
                                sourceSize: Qt.size(width, height)
                                layer.enabled: true
                                layer.effect: MultiEffect{
                                    brightness: 1
                                    colorization: 1.0
                                    colorizationColor: Colors.surfaceText
                                }
                            }
                        }

                        MouseArea{
                            id: fontFamilyMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: fontFamilyMenu.visible = !fontFamilyMenu.visible

                            Rectangle{
                                anchors.fill: parent
                                color: Qt.alpha(Colors.surfaceText, 0.05)
                                radius: parent.radius
                                visible: parent.containsMouse
                            }
                        }
                    }
                }

                // Font Weight Setting
                ColumnLayout{
                    Layout.fillWidth: true
                    spacing: 8

                    StyledText{
                        content: "Font Weight"
                        size: 14
                        color: Colors.surfaceText
                        font.weight: 500
                    }

                    StyledText{
                        content: "Adjust text thickness"
                        size: 12
                        color: Colors.surfaceText
                        opacity: 0.6
                    }

                    Rectangle{
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 36
                        radius: 6
                        color: Colors.surface
                        border.color: Colors.outline
                        border.width: 1

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 6

                            StyledText{
                                Layout.fillWidth: true
                                content: getWeightDisplayName(ServiceDashboardSettings.settings.defaultTextWeight)
                                size: 13
                                color: Colors.surfaceText
                            }

                            Image{
                                width: 16
                                height: 16
                                source: IconUtils.getSystemIcon("down")
                                sourceSize: Qt.size(width, height)
                                layer.enabled: true
                                layer.effect: MultiEffect{
                                    brightness: 1
                                    colorization: 1.0
                                    colorizationColor: Colors.surfaceText
                                }
                            }
                        }

                        MouseArea{
                            id: fontWeightMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: fontWeightMenu.visible = !fontWeightMenu.visible

                            Rectangle{
                                anchors.fill: parent
                                color: Qt.alpha(Colors.surfaceText, 0.05)
                                radius: parent.radius
                                visible: parent.containsMouse
                            }
                        }
                    }
                }
            }
        }
    }

    // Font Family Dropdown - positioned at root level
    Rectangle{
        id: fontFamilyMenu
        width: 180
        height: fontFamilyColumn.implicitHeight + 12
        radius: 6
        color: Colors.surfaceContainerHigh
        border.color: Colors.outline
        border.width: 1
        visible: false
        z: 10000

        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.3
            shadowOpacity: 0.8
            shadowColor: Qt.alpha(Colors.shadow, 0.5)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
        }

        Column{
            id: fontFamilyColumn
            anchors.fill: parent
            anchors.margins: 6

            Repeater{
                model: [
                    {value: "Super Trend", display: "System Default"},
                    {value: "Iosevka", display: "Iosevka"},
                    {value: "CaskaydiaCove NF", display: "Cascadia Code"},
                    {value: "Digital-7", display: "Digital-7"},
                    {value: "nothing-font-5x7", display: "Nothing Font"},
                    {value: "Orbitron", display: "Orbitron"}
                ]

                Rectangle{
                    width: parent.width
                    height: 28
                    radius: 4
                    color: ServiceDashboardSettings.settings.defaultFontFamily === modelData.value ? Colors.primary : "transparent"

                    StyledText{
                        anchors.centerIn: parent
                        content: modelData.display
                        size: 11
                        color: ServiceDashboardSettings.settings.defaultFontFamily === modelData.value ? Colors.primaryText : Colors.surfaceText
                        font.family: modelData.value
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            ServiceDashboardSettings.settings.defaultFontFamily = modelData.value
                            fontFamilyMenu.visible = false
                        }

                        Rectangle{
                            anchors.fill: parent
                            color: Qt.alpha(Colors.surfaceText, 0.1)
                            radius: parent.radius
                            visible: parent.containsMouse && ServiceDashboardSettings.settings.defaultFontFamily !== modelData.value
                        }
                    }
                }
            }
        }

        // Position this dropdown when it becomes visible
        onVisibleChanged: {
            if (visible && fontFamilyMouseArea.parent) {
                var globalPos = fontFamilyMouseArea.parent.mapToItem(root, 0, fontFamilyMouseArea.parent.height + 4)
                x = globalPos.x
                y = globalPos.y
            }
        }
    }

    // Font Weight Dropdown - positioned at root level
    Rectangle{
        id: fontWeightMenu
        width: 180
        height: Math.min(fontWeightColumn.implicitHeight + 12, 200)
        radius: 6
        color: Colors.surfaceContainerHigh
        border.color: Colors.outline
        border.width: 1
        visible: false
        z: 10000

        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.3
            shadowOpacity: 0.8
            shadowColor: Qt.alpha(Colors.shadow, 0.5)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 4
        }

        Flickable{
            anchors.fill: parent
            anchors.margins: 6
            contentHeight: fontWeightColumn.implicitHeight
            clip: true

            Column{
                id: fontWeightColumn
                width: parent.width

                Repeater{
                    model: [
                        {value: 100, display: "Thin (100)"},
                        {value: 200, display: "Light (200)"},
                        {value: 300, display: "Light (300)"},
                        {value: 400, display: "Regular (400)"},
                        {value: 500, display: "Medium (500)"},
                        {value: 600, display: "Bold (600)"},
                        {value: 700, display: "Bold (700)"},
                        {value: 800, display: "Heavy (800)"},
                        {value: 900, display: "Heavy (900)"}
                    ]

                    Rectangle{
                        width: parent.width
                        height: 28
                        radius: 4
                        color: ServiceDashboardSettings.settings.defaultTextWeight === modelData.value ? Colors.primary : "transparent"

                        StyledText{
                            anchors.centerIn: parent
                            content: modelData.display
                            size: 11
                            color: ServiceDashboardSettings.settings.defaultTextWeight === modelData.value ? Colors.primaryText : Colors.surfaceText
                            font.weight: modelData.value
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ServiceDashboardSettings.settings.defaultTextWeight = modelData.value
                                fontWeightMenu.visible = false
                            }

                            Rectangle{
                                anchors.fill: parent
                                color: Qt.alpha(Colors.surfaceText, 0.1)
                                radius: parent.radius
                                visible: parent.containsMouse && ServiceDashboardSettings.settings.defaultTextWeight !== modelData.value
                            }
                        }
                    }
                }
            }
        }

        // Position this dropdown when it becomes visible
        onVisibleChanged: {
            if (visible && fontWeightMouseArea.parent) {
                var globalPos = fontWeightMouseArea.parent.mapToItem(root, 0, fontWeightMouseArea.parent.height + 4)
                x = globalPos.x
                y = globalPos.y
            }
        }
    }

    // Helper functions
    function getFontDisplayName(fontFamily) {
        switch(fontFamily) {
            case "Super Trend": return "System Default"
            case "Iosevka": return "Iosevka"
            case "CaskaydiaCove NF": return "Cascadia Code"
            case "Digital-7": return "Digital-7"
            case "nothing-font-5x7": return "Nothing Font"
            case "Orbitron": return "Orbitron"
            default: return "System Default"
        }
    }

    function getWeightDisplayName(weight) {
        switch(weight) {
            case 100: return "Thin (100)"
            case 200: return "Light (200)"
            case 300: return "Light (300)"
            case 400: return "Regular (400)"
            case 500: return "Medium (500)"
            case 600: return "Bold (600)"
            case 700: return "Bold (700)"
            case 800: return "Heavy (800)"
            case 900: return "Heavy (900)"
            default: return "Regular (400)"
        }
    }
}