import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.customComponents

RowLayout{
    property string icon:{
        let level = ServiceUPower.powerLevel
        if(level === 1){
            return "battery-full"
        }else if(level < 1 && level > 0.9){
            return "battery-6"
        }else if(level <= 0.9 && level > 0.7){
            return "battery-5"
        }else if(level <= 0.7 && level > 0.5){
            return "battery-4"
        }else if(level <= 0.5 && level > 0.3){
            return "battery-3"
        }else if(level <= 0.3 && level > 0.2){
            return "battery-2"
        }else if(level <= 0.2 && level > 0){
            return "battery-1"
        }
        return "battery-0"
    }

    IconImage {
        implicitSize: 20
        source: IconUtil.getSystemIcon(parent.icon)
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: Colors.surfaceText
            Behavior on colorizationColor{
                ColorAnimation{
                    duration: 200
                }
            }
            brightness: 0
        }
    } 

    CustomText{
        content: Math.floor(ServiceUPower.powerLevel * 100)
        size: 12
    }
}
