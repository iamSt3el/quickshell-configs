import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.customComponents

Item{
    implicitWidth: row.implicitWidth
    RowLayout{
        id: row
        anchors.fill: parent
        property string icon:{
            let level = ServiceUPower.powerLevel
            if(ServiceUPower.isCharging){
                return "battery_android_bolt"
            }
            if(level === 1){
                return "battery_android_full"
            }else if(level < 1 && level > 0.9){
                return "battery_android_6"
            }else if(level <= 0.9 && level > 0.7){
                return "battery_android_5"
            }else if(level <= 0.7 && level > 0.5){
                return "battery_android_4"
            }else if(level <= 0.5 && level > 0.3){
                return "battery_android_3"
            }else if(level <= 0.3 && level > 0.2){
                return "battery_android_2"
            }else if(level <= 0.2 && level > 0){
                return "battery_android_1"
            }
            return "battery_android_0"
        }

        MaterialIconSymbol {
            iconSize: 20
            content: parent.icon
        } 

        CustomText{
            content: Math.floor(ServiceUPower.powerLevel * 100)
            size: 12
        }
    }
}
