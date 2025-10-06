import Quickshell
import QtQuick
import qs.modules.util
import qs.modules.components
import qs.modules.services
import QtQuick.Layouts
import QtQuick.Effects
import "./settings"

Item{
    id: root

    property var pages: [
        {
            name: "User",
            icon: "user",
            component: "settings/UserProfileSection.qml"
        },
        {
            name: "Quick",
            icon: "tune",
            component: "settings/QuickSettings.qml"
        },
        {
            name: "Dashboard",
            icon: "dashboard",
            component: "settings/DashboardPreferencesSection.qml"
        },
        {
            name: "Shell",
            icon: "setting",
            component: "settings/QuickShellSection.qml"
        },
        {
            name: "Theme",
            icon: "palette",
            component: "settings/ThemeColorsSection.qml"
        }
    ]
    property int currentPage: 0

    RowLayout{
        anchors.fill: parent
        spacing: 0

        // Navigation rail
        Rectangle{
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            color: Colors.surfaceVariant
            radius: 16

            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                StyledText{
                    Layout.alignment: Qt.AlignHCenter
                    content: "Settings"
                    size: 16
                    font.weight: 600
                    color: Colors.primary
                    Layout.topMargin: 5
                    Layout.bottomMargin: 10
                }

                Repeater{
                    model: root.pages

                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 45
                        radius: 12
                        color: root.currentPage === index ? Colors.primary : "transparent"

                        ColumnLayout{
                            anchors.centerIn: parent
                            spacing: 2

                            Image{
                                Layout.alignment: Qt.AlignHCenter
                                width: 20
                                height: 20
                                source: IconUtils.getSystemIcon(modelData.icon)
                                sourceSize: Qt.size(width, height)
                                layer.enabled: true
                                layer.effect: MultiEffect{
                                    brightness: 1
                                    colorization: 1.0
                                    colorizationColor: root.currentPage === index ? Colors.primaryText : Colors.surfaceVariantText
                                }
                            }

                            StyledText{
                                Layout.alignment: Qt.AlignHCenter
                                content: modelData.name
                                size: 11
                                color: root.currentPage === index ? Colors.primaryText : Colors.surfaceVariantText
                                font.weight: 500
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.currentPage = index

                            Rectangle{
                                anchors.fill: parent
                                color: Qt.alpha(Colors.surfaceVariantText, 0.1)
                                radius: 12
                                visible: parent.containsMouse && root.currentPage !== index
                            }
                        }
                    }
                }

                Item{
                    Layout.fillHeight: true
                }
            }
        }

        // Content area
        Rectangle{
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: Colors.surface
            radius: 16

            StackLayout{
                anchors.fill: parent
                anchors.margins: 10
                currentIndex: root.currentPage

                // User Settings Loader
                Loader{
                    id: userLoader
                    active: root.currentPage === 0
                    source: active ? "settings/UserProfileSection.qml" : ""
                }

                // Quick Settings Loader
                Loader{
                    id: quickLoader
                    active: root.currentPage === 1
                    source: active ? "settings/QuickSettings.qml" : ""
                }

                // Dashboard Settings Loader
                Loader{
                    id: dashboardLoader
                    active: root.currentPage === 2
                    source: active ? "settings/DashboardPreferencesSection.qml" : ""
                }

                // Shell Settings Loader
                Loader{
                    id: shellLoader
                    active: root.currentPage === 3
                    source: active ? "settings/QuickShellSection.qml" : ""
                }

                // Theme Settings Loader
                Loader{
                    id: themeLoader
                    active: root.currentPage === 4
                    source: active ? "settings/ThemeColorsSection.qml" : ""
                }
            }
        }
    }
}
