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
        content: ServiceUPower.powerLevel
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
            //implicitSize: Dimensions.icon.medium
            width: Dimensions.icon.medium
            height: Dimensions.icon.medium
            sourceSize: Qt.size(width, height)
            property string icon:{
                if(ServiceUPower.isCharging) return "battery-charging"
                if(ServiceUPower.powerLevel < 60) return "battery-medium"
                if(ServiceUPower.powerLevel < 30) return "battery-low"
                return "battery"
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

    }
}
