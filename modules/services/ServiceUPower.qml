pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower
import qs.modules.utils

Singleton{
    id: root
    property var powerProfiles:[
        {
            name: "Save",
            icon: "leaf"
        },
        {
            name: "Balance",
            icon: "balance"
        },
        {
            name: "Performance",
            icon: "performace"
        }
    ]
    property var powerProfile: PowerProfiles.profile
    property string powerProfileIconPath: powerProfile === 0 ? "leaf" : "balance" 
    property var powerLevel: UPower.displayDevice.percentage
    property bool isCharging: UPowerDeviceState.Charging === UPower.displayDevice.state 

    function setPowerProfile(value){
        PowerProfiles.profile = value
    }
}


