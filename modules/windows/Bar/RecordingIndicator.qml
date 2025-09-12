import Quickshell
import Quickshell.Io
import QtQuick
import qs.modules.util
import qs.modules.components
import qs.modules.services
import Quickshell.Widgets
import QtQuick.Effects

StyledRect{
    id: recordingIndicator
    implicitWidth: row.width + 10
    implicitHeight: Dimensions.component.height
    color: Colors.errorContainer

    Row{
        id: row
        height: parent.height
        spacing: 10
        Item{
            width: 20
            height: parent.height

            Rectangle{
                anchors.centerIn: parent
                implicitWidth: 10
                implicitHeight: 10
                radius: 5
                color: Colors.error
                
                SequentialAnimation on opacity {
                    running: true
                    loops: Animation.Infinite
                    PropertyAnimation {
                        to: 0.3
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAnimation {
                        to: 1.0
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item{
            width: 30
            height: parent.height

            StyledText{
                content: ServiceTools.getFormattedRecordingTime()
                anchors.centerIn: parent
                color: Colors.errorContainerText
            }
        }

        Item{
            width: 20
            height: parent.height

            Image{
                width: 20
                height: 20
                source: IconUtils.getSystemIcon("square")
                sourceSize: Qt.size(width, height)
                anchors.centerIn: parent
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Colors.errorContainerText
                    brightness: 1                    
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    ServiceTools.stopRecording()
                }
            }
        }
    }
}
