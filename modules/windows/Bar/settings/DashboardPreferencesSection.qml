import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components
import qs.modules.services
import QtQuick.Effects
import QtQuick.Layouts

Flickable{
    id: root
    contentHeight: prefsSection.implicitHeight + 50
    clip: true

    Rectangle{
        width: parent.width
        height: prefsSection.implicitHeight + 30
        radius: 16
        color: Colors.surfaceContainer

        ColumnLayout{
            id: prefsSection
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
                content: "Dashboard Preferences"
                size: 18
                font.weight: 600
                color: Colors.primary
            }
        }

        // Settings options
        ColumnLayout{
            Layout.fillWidth: true
            spacing: 10

            // Show components toggles
            RowLayout{
                Layout.fillWidth: true
                spacing: 15

                // Notifications toggle
                RowLayout{
                    spacing: 8
                    Rectangle{
                        width: 20
                        height: 20
                        radius: 10
                        color: ServiceDashboardSettings.settings.showNotifications ? Colors.primary : Colors.surfaceVariant
                        border.color: Colors.outline
                        border.width: 1

                        Rectangle{
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            radius: 6
                            color: Colors.surface
                            visible: ServiceDashboardSettings.settings.showNotifications
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ServiceDashboardSettings.setShowNotifications(!ServiceDashboardSettings.settings.showNotifications)
                            }
                        }
                    }

                    StyledText{
                        content: "Show Notifications"
                        size: 13
                        color: Colors.surfaceText
                    }
                }

                // System stats toggle
                RowLayout{
                    spacing: 8
                    Rectangle{
                        width: 20
                        height: 20
                        radius: 10
                        color: ServiceDashboardSettings.settings.showSystemStats ? Colors.primary : Colors.surfaceVariant
                        border.color: Colors.outline
                        border.width: 1

                        Rectangle{
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            radius: 6
                            color: Colors.surface
                            visible: ServiceDashboardSettings.settings.showSystemStats
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ServiceDashboardSettings.setShowSystemStats(!ServiceDashboardSettings.settings.showSystemStats)
                            }
                        }
                    }

                    StyledText{
                        content: "Show System Stats"
                        size: 13
                        color: Colors.surfaceText
                    }
                }
            }

            // Music player and weather toggles
            RowLayout{
                Layout.fillWidth: true
                spacing: 15

                // Music player toggle
                RowLayout{
                    spacing: 8
                    Rectangle{
                        width: 20
                        height: 20
                        radius: 10
                        color: ServiceDashboardSettings.settings.showMusicPlayer ? Colors.primary : Colors.surfaceVariant
                        border.color: Colors.outline
                        border.width: 1

                        Rectangle{
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            radius: 6
                            color: Colors.surface
                            visible: ServiceDashboardSettings.settings.showMusicPlayer
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ServiceDashboardSettings.setShowMusicPlayer(!ServiceDashboardSettings.settings.showMusicPlayer)
                            }
                        }
                    }

                    StyledText{
                        content: "Show Music Player"
                        size: 13
                        color: Colors.surfaceText
                    }
                }

                // Weather toggle
                RowLayout{
                    spacing: 8
                    Rectangle{
                        width: 20
                        height: 20
                        radius: 10
                        color: ServiceDashboardSettings.settings.showWeather ? Colors.primary : Colors.surfaceVariant
                        border.color: Colors.outline
                        border.width: 1

                        Rectangle{
                            anchors.centerIn: parent
                            width: 12
                            height: 12
                            radius: 6
                            color: Colors.surface
                            visible: ServiceDashboardSettings.settings.showWeather
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                ServiceDashboardSettings.setShowWeather(!ServiceDashboardSettings.settings.showWeather)
                            }
                        }
                    }

                    StyledText{
                        content: "Show Weather"
                        size: 13
                        color: Colors.surfaceText
                    }
                }
            }

            // Layout selection
            ColumnLayout{
                Layout.fillWidth: true
                spacing: 8

                StyledText{
                    content: "Dashboard Layout"
                    size: 13
                    color: Colors.surfaceText
                    opacity: 0.8
                }

                Flow{
                    Layout.fillWidth: true
                    spacing: 8

                    Repeater{
                        model: [
                            {value: "default", name: "Default"},
                            {value: "compact", name: "Compact"},
                            {value: "detailed", name: "Detailed"}
                        ]

                        Rectangle{
                            width: 80
                            height: 30
                            radius: 15
                            color: ServiceDashboardSettings.settings.dashboardLayout === modelData.value ? Colors.primary : Colors.surfaceVariant
                            border.color: Colors.outline
                            border.width: 1

                            StyledText{
                                anchors.centerIn: parent
                                content: modelData.name
                                size: 11
                                color: ServiceDashboardSettings.settings.dashboardLayout === modelData.value ? Colors.primaryText : Colors.surfaceVariantText
                                font.weight: 500
                            }

                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    ServiceDashboardSettings.setDashboardLayout(modelData.value)
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