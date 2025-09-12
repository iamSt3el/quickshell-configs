import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland
import QtQuick.Effects
import qs.modules.util
import qs.modules.services

PanelWindow {
    id: panel
    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal
    color: "transparent"

    function getCirclePosition(index, total, radiusValue, centerXValue, centerYValue) {
        var angle = (index * 2 * Math.PI) / total - Math.PI / 2
        var x = centerXValue + radiusValue * Math.cos(angle) - 50 / 2
        var y = centerYValue + radiusValue * Math.sin(angle) - 50 / 2
        
        return { x: x, y: y }
    }

    function getFixedSpaceCirclePosition(index, total, radiusValue, centerXValue, centerYValue, fixedAngleDegrees, parentIndex) {
        var parentOffset = parentIndex * 90 * (Math.PI / 180) 
        var totalAngle = (total - 1) * fixedAngleDegrees * (Math.PI / 180)
        var startAngle = parentOffset - totalAngle / 2 
        var angle = startAngle + (index * fixedAngleDegrees * (Math.PI / 180))
        
        var x = centerXValue + radiusValue * Math.cos(angle) - 25 
        var y = centerYValue + radiusValue * Math.sin(angle) - 25 
        
        return { x: x, y: y }
    }

    function closeAllOptions() {
        for (let i = 0; i < repeater.count; i++) {
            let item = repeater.itemAt(i)
            if (item) {
                item.showOptions = false
            }
        }
    }



    Item {
        anchors.centerIn: parent
        width: 300
        height: 300
        z: 1

        Rectangle {
            id: wrapper
            anchors.centerIn: parent
            implicitWidth: parent.width
            implicitHeight: parent.height
            color: "transparent"

            Repeater {
                id: repeater
                anchors.centerIn: parent
                model: ServiceTools.tools

                delegate: Rectangle {
                    id: icons
                    property int iconIndex: index 
                    implicitWidth: 50
                    implicitHeight: 50
                    radius: width
                    property bool showOptions: false
                    border {
                        color: Colors.outline
                        width: 1
                    }
                    color: Colors.secondary
                    scale: 0

                    property var pos: panel.getCirclePosition(
                        index,
                        ServiceTools.tools.length,
                        120 / 2,
                        wrapper.width / 2,
                        wrapper.height / 2
                    )

                    x: pos.x
                    y: pos.y

                    Image {
                        width: 30
                        height: 30
                        anchors.centerIn: parent
                        sourceSize: Qt.size(height, width)
                        source: IconUtils.getSystemIcon(modelData.icon)
                    }

                    Item {
                        anchors.fill: parent
                        visible: icons.showOptions

                        Repeater {
                            anchors.fill: parent
                            model: modelData.options

                            delegate: Rectangle {
                                implicitHeight: 50
                                implicitWidth: 50
                                radius: width
                                color: Colors.secondary
                                scale: 0

                                property var childPos: panel.getFixedSpaceCirclePosition(
                                    index,      
                                    3,   
                                    120 / 2,                                                          
                                    icons.width / 2,
                                    icons.height / 2,
                                    65,  
                                    icons.iconIndex - 1 
                                )
                                x: childPos.x
                                y: childPos.y

                                Image {
                                    width: 30
                                    height: 30
                                    anchors.centerIn: parent
                                    sourceSize: Qt.size(height, width)
                                    source: IconUtils.getSystemIcon(modelData.icon)
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        ServiceIpcHandler.isToolWidgetVisible = false
                                        
                                        if (modelData.type === "recording") {
                                            // Handle recording with state management
                                            if (ServiceTools.isRecording) {
                                                ServiceTools.stopRecording()
                                            } else {
                                                ServiceTools.startRecording(modelData.name)
                                            }
                                        } else if (modelData.command) {
                                            // Handle regular commands
                                            Quickshell.execDetached(modelData.command)
                                        }
                                    }
                                }

                                Timer {
                                    interval: icons.showOptions ? (index * 100 + 200) : 0
                                    running: icons.showOptions
                                    onTriggered: parent.scale = 1
                                }
                                
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 300
                                        easing.type: Easing.OutBack
                                    }
                                }

                                onVisibleChanged: {
                                    if (!visible) scale = 0
                                }
                            }
                        }
                    }

                    MouseArea {
                        id: iconArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
        
                        onClicked: {
                            let wasOpen = icons.showOptions
                            panel.closeAllOptions()
                            if (!wasOpen) {
                                icons.showOptions = true
                            }
                        }
                    }
           
                    Timer {
                        interval: index * 150
                        running: true
                        onTriggered: parent.scale = 1
                    }
                    
                    Behavior on scale {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutBack
                        }
                    }
                }
            }

            Rectangle {
                anchors.centerIn: parent
                implicitWidth: 50
                implicitHeight: 50
                radius: width
                color: Colors.primary

                Image {
                    width: 30
                    height: 30
                    anchors.centerIn: parent
                    sourceSize: Qt.size(height, width)
                    source: IconUtils.getSystemIcon("close")
                }

                MouseArea {
                    id: closeArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        ServiceIpcHandler.isToolWidgetVisible = false
                    }
                }
            }
        }
    }
}
