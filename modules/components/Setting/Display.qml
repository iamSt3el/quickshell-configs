import Quickshell
import Quickshell.Widgets
import Quickshell.Hyprland
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: root
    anchors.fill: parent
    anchors.margins: 5
    property var list: ServiceDisplay.monitorList
    property string selectedMonitor: list.length > 0 ? list[0].name : ""

    // Get the selected monitor object by name
    property var selectedMonitorData: {
        if (!list || list.length === 0) return null
        return list.find(m => m.name === selectedMonitor) || null
    }

    Flickable{
        id: flickable
        anchors.fill: parent
        contentHeight: column.implicitHeight
        contentWidth: width
        clip: true

        
        MouseArea{
            anchors.fill: parent
            onClicked:{
                list1.isListClicked = false
                list2.isListClicked = false
                flickable.clip = true
            }
        }

        ColumnLayout{
            id: column
            width: parent.width
            spacing: 10


            RowLayout{
                Layout.margins: 5
                IconImage {
                    implicitSize: 26
                    Layout.alignment: Qt.AlignVCenter
                    source: IconUtil.getSystemIcon("display")
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Colors.primary
                        Behavior on colorizationColor{
                            ColorAnimation{
                                duration: 200
                            }
                        }
                        brightness: 0
                    } 
                }

                CustomText{
                    content: "Display"
                    size: 20
                    color: Colors.primary
                }

            }

            ColumnLayout{
                Layout.margins: 5
                spacing: 10

                CustomText{
                    content: "Display Arrangment"
                    size: 18
                    color: Colors.secondary
                }
                RowLayout{
                    spacing: 5
                    Rectangle{
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 150
                        radius: 10
                        color: Colors.surfaceContainerHigh

                        Item {
                            id: monitorContainer
                            anchors.fill: parent
                            anchors.margins: 10

                            property var monitors: root.list || []

                            property real minX: {
                                if (monitors.length === 0) return 0
                                return Math.min(...monitors.map(m => m.x))
                            }
                            property real minY: {
                                if (monitors.length === 0) return 0
                                return Math.min(...monitors.map(m => m.y))
                            }
                            property real maxX: {
                                if (monitors.length === 0) return 1920
                                return Math.max(...monitors.map(m => m.x + m.width))
                            }
                            property real maxY: {
                                if (monitors.length === 0) return 1080
                                return Math.max(...monitors.map(m => m.y + m.height))
                            }

                            property real totalWidth: maxX - minX
                            property real totalHeight: maxY - minY

                            property real scaleX: totalWidth > 0 ? width / totalWidth : 1
                            property real scaleY: totalHeight > 0 ? height / totalHeight : 1
                            property real displayScale: Math.min(scaleX, scaleY) * 0.9

                            property real scaledWidth: totalWidth * displayScale
                            property real scaledHeight: totalHeight * displayScale
                            property real offsetX: (width - scaledWidth) / 2
                            property real offsetY: (height - scaledHeight) / 2

                            Repeater {
                                model: monitorContainer.monitors

                                Rectangle {
                                    property var monitor: modelData
                                    property bool isActive: modelData.name === root.selectedMonitor || false

                                    x: (monitor.x - monitorContainer.minX) * monitorContainer.displayScale + monitorContainer.offsetX
                                    y: (monitor.y - monitorContainer.minY) * monitorContainer.displayScale + monitorContainer.offsetY
                                    width: monitor.width * monitorContainer.displayScale
                                    height: monitor.height * monitorContainer.displayScale

                                    radius: 8
                                    color: isActive ? Colors.primary : Colors.surfaceContainer
                                    border.width: 2
                                    border.color: isActive ? Colors.primaryText : Colors.outline

                                    Behavior on color {
                                        ColorAnimation { duration: 200 }
                                    }

                                    ColumnLayout {
                                        anchors.centerIn: parent
                                        spacing: 2

                                        CustomText {
                                            Layout.alignment: Qt.AlignHCenter
                                            content: monitor.name || "Monitor"
                                            size: 10
                                            color: isActive ? Colors.primaryText : Colors.surfaceVariantText
                                        }

                                        CustomText {
                                            Layout.alignment: Qt.AlignHCenter
                                            content: monitor.resolution || ""
                                            size: 8
                                            color: isActive ? Colors.primaryText : Colors.surfaceVariantText
                                        }
                                    }

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        hoverEnabled: true

                                        onEntered: parent.opacity = 0.8
                                        onExited: parent.opacity = 1.0

                                        onClicked:{
                                            root.selectedMonitor = modelData.name
                                        }
                                    }
                                }
                            }
                        }

                    } 

                    ColumnLayout{
                        Layout.fillWidth: true
                        spacing: 5

                        Repeater {
                            model: Settings.displayModes

                            Rectangle{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                property bool active: Settings.currentDisplayMode === modelData.name
                                color: active ? Colors.primary : Colors.surfaceContainerHigh
                                radius: active ? 20 : 10

                                Behavior on radius{
                                    NumberAnimation{
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                    }
                                }

                                Behavior on color{
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }

                                RowLayout{
                                    anchors.fill: parent
                                    anchors.margins: 10
                                    spacing: 10

                                    CustomIconImage{
                                        icon: modelData.icon
                                        size: 20
                                        color: active ? Colors.primaryText : Colors.surfaceVariantText
                                    }

                                    CustomText{
                                        Layout.fillWidth: true
                                        content: modelData.name
                                        size: 14
                                        color: active ? Colors.primaryText : Colors.surfaceVariantText
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        Settings.currentDisplayMode = modelData.name
                                        console.log("Selected mode:", modelData.name)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout{
                Layout.margins: 5
                Layout.topMargin: 15
                spacing: 10
                RowLayout{
                    ColumnLayout{
                        Layout.fillWidth: true
                        CustomText{
                            Layout.fillWidth: true
                            content: "Configure Display"
                            size: 14
                        }
                        CustomText{
                            Layout.fillWidth: true
                            content: root.selectedMonitor
                            size: 12
                            color: Colors.outline
                        }
                    }

                    
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: col.implicitHeight + 15
                    radius: 10
                    color: Colors.surfaceContainerHigh

                    ColumnLayout{
                        id: col
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 20

                        RowLayout{
                            spacing: 10
                            Layout.fillWidth: true
                            ColumnLayout{
                                Layout.fillWidth: true
                                spacing: 10
                                CustomText{
                                    content: "Resolution    "
                                    size: 12
                                }

                                CustomList{
                                    id: list1
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30
                                    currentVal: root.selectedMonitorData ? root.selectedMonitorData.resolution : ""
                                    list: root.selectedMonitorData ? root.selectedMonitorData.availableResolutions : []
                                }
                            }

                            ColumnLayout{
                                spacing: 10
                                Layout.fillWidth: true
                                CustomText{
                                    content: "Refresh Rate"
                                    size: 12
                                }

                                CustomList{
                                    id: list2
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 30                                    
                                    currentVal: root.selectedMonitorData ? root.selectedMonitorData.refreshRate : ""
                                    list: root.selectedMonitorData ? root.selectedMonitorData.availableRefreshRates : []
                                }
                            }
                        }

                        ColumnLayout{
                            spacing: 10
                            RowLayout{
                                CustomIconImage{
                                    icon: "sun"
                                    size: 16
                                }
                                CustomText{
                                    Layout.fillWidth: true
                                    content: "Brightness"
                                    size: 12
                                }
                                CustomText{
                                    content: Math.floor(slider.progress * 100) +"%"
                                    size: 12
                                }
                            }

                            CustomSliderNew{
                                id: slider
                                Layout.fillWidth: true
                                Layout.preferredHeight: 10
                                progress: 0.3
                            }
                        }

                        RowLayout{
                            CustomIconImage{
                                icon: "zap"
                                size: 16
                            }

                            CustomText{
                                Layout.fillWidth: true
                                content: "Variable Refresh Rate (VRR)"
                                size: 12
                            }

                            CustomToogle{
                                isToggleOn: root.selectedMonitorData.vrr
                            }                            
                        }
                    }
                }
            }
        }

    }
}


