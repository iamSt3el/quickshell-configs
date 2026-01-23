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
            icon: "energy_savings_leaf"
        },
        {
            name: "Balance",
            icon: "balance"
        },
        {
            name: "Performance",
            icon: "rocket_launch"
        }
    ]
    property var powerProfile: PowerProfiles.profile
    property string powerProfileIcon: powerProfile === 0 ? "leaf" : "balance" 
    property real powerLevel: UPower.displayDevice.percentage
    property bool isCharging: UPowerDeviceState.Charging === UPower.displayDevice.state 
    property real health: UPower.displayDevice.energyCapacity / 52.976
    property string timeToFull: formatTime(UPower.displayDevice.timeToFull)
    property real changeRate: UPower.displayDevice.changeRate
    function setPowerProfile(value){
        PowerProfiles.profile = value
    }

    function formatTime(seconds) {
        var h = Math.floor(seconds / 3600);
        var m = Math.floor((seconds % 3600) / 60);
        if (h > 0)
        return `${h}h, ${m}m`;
        else
        return `${m}m`;
    }
}


