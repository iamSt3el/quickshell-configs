import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.utils
import QtQuick.Effects
import qs.modules.customComponents

Item {
    id: root
    width: wrapper.width
    height: parent.height
    property var progress: 0.2
    property string icon
    property bool isDragging: handleArea.drag.active
    
    Rectangle {
        id: wrapper
        anchors.centerIn: parent
        implicitWidth: 45
        implicitHeight: parent.height - 20
        radius: 20
        color: Colors.surfaceContainerHighest
        Rectangle {
            id: handler
            implicitWidth: parent.width
            implicitHeight: 40
            radius: 20
            z: 1
            color: Colors.primary
            y: (parent.height - height) * (1 - root.progress)
            
            IconImage {
                visible: !root.isDragging
                anchors.centerIn: parent
                implicitSize: 24
                source: IconUtil.getSystemIcon(root.icon)
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Colors.surface
                    brightness: 0
                }
            }
            
            CustomText {
                visible: root.isDragging
                anchors.centerIn: parent
                content: Math.floor(root.progress * 100)
                color: Colors.surface
                size: 18
            }
            
            MouseArea {
                id: handleArea
                anchors.fill: parent
                drag.target: handler
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: wrapper.height - handler.height
                cursorShape: Qt.PointingHandCursor
                
                onPositionChanged: {
                    if (drag.active) {
                        let percentage = 1 - (handler.y / (wrapper.height - handler.height))
                        root.progress = Math.max(0, Math.min(1, percentage))
                    }
                }
            }
        }
        
        Rectangle {
            anchors.bottom: parent.bottom
            implicitWidth: parent.width
            implicitHeight: parent.height * root.progress
            color: Colors.primary
            radius: parent.radius
        }
    }
}
