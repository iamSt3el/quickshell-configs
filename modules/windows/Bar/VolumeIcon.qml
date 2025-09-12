import Quickshell
import QtQuick
import qs.modules.components
import Quickshell.Widgets
import qs.modules.services
import qs.modules.util
import QtQuick.Effects


StyledRect{
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: Dimensions.component.height
    implicitWidth: Dimensions.component.interactive

    StyledText{
        anchors.leftMargin: 5
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        content: ServicePipewire.volume
        weight: Typography.weight.bold
    }

    Rectangle{
        anchors.right: parent.right
        anchors.rightMargin: -5
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: Dimensions.component.width
        implicitHeight: Dimensions.component.height + 5
        radius: Dimensions.component.height 
        color: Colors.primaryContainer 

        Image{
            anchors.centerIn: parent
            width: Dimensions.icon.medium
            height: Dimensions.icon.medium
            sourceSize: Qt.size(width, height)
            property string icon:{
                if(ServicePipewire.isMuted) return "speaker-muted"
                if(ServicePipewire.volume > 60) return "speaker"
                if(ServicePipewire.volume > 20) return "speaker-medium"
                if(ServicePipewire.volume <= 20) return "speaker-low"
                return "speaker"
            }
            source: IconUtils.getSystemIcon(icon)
            cache: true
            layer.enabled: true
            layer.effect: MultiEffect{
                colorization: 1.0
                colorizationColor: Colors.surfaceText
                brightness: 1
            }
        }

        MouseArea{
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: ServicePipewire.updateState()

            onWheel: function(whell){
                ServicePipewire.updateVolume(whell.angleDelta.y / 120 * 0.01)
            }
        }
    }
}
