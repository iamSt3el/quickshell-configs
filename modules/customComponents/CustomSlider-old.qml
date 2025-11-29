import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.utils
import QtQuick.Effects
import qs.modules.customComponents

Item{
    id: root
    anchors.fill: parent
    property alias progress: wrapper.progress
    property string icon
    property bool isDragging: false
    Column{
        width: parent.width
        height: parent.height - 20
        anchors.centerIn: parent
        spacing: 10
        Rectangle{
            id: wrapper
            implicitWidth: 30
            implicitHeight: parent.height * 0.8
            color: "transparent"
            radius: 8
            anchors.horizontalCenter: parent.horizontalCenter
            property var progress: 0.2


            Rectangle{
                id: inactiveTrack
                implicitWidth: parent.width
                anchors.top: parent.top
                implicitHeight: (parent.height - 14) * (1 - wrapper.progress)
                color: Qt.alpha(Colors.primary, 0.5)
                topLeftRadius: 8
                topRightRadius: 8
            }


            Rectangle{
                id: activeTrack
                implicitHeight: (parent.height - 14) * wrapper.progress
                implicitWidth: parent.width
                anchors.bottom: parent.bottom
                color: Colors.primary
                bottomLeftRadius: 8
                bottomRightRadius: 8
            }

            Rectangle{
                id: handler
                implicitHeight: 6
                implicitWidth: 44
                color: Colors.primary
                radius: 2
                anchors.horizontalCenter: parent.horizontalCenter
                y: (parent.height - 14) * (1 - wrapper.progress) + 7 - (height / 2)

                MouseArea{
                    id: handleArea
                    anchors.fill: parent
                    drag.target: handler
                    drag.axis: Drag.YAxis
                    drag.minimumY: 0
                    drag.maximumY: wrapper.height - 14
                    cursorShape: Qt.PointingHandCursor


                    onPositionChanged: {
                        if (drag.active) {
                            let percentage = 1 - ((handler.y - 6 + handler.height/2) / (wrapper.height - 14));
                            wrapper.progress = Math.max(0, Math.min(1, percentage));
                           // root.isDragging = true
                        }
                    }
                }
            }
        }
        
        Item{
            height: parent.height * 0.2
            width: parent.width
            Rectangle{
                anchors.centerIn: parent
                implicitWidth: parent.height 
                implicitHeight: parent.height
                radius: 14
                color: Colors.primary

                IconImage{
                    visible: !root.isDragging
                    anchors.centerIn: parent
                    implicitSize: 24
                    source: IconUtil.getSystemIcon(root.icon)
                    layer.enabled: true

                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Colors.primaryText
                        brightness: 1

                    }
                }
            }
        }

    }
}
