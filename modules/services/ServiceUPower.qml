pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

Singleton{
    id: root    
    
    property var powerLevel: UPower.displayDevice.percentage
    property bool isCharging: UPowerDeviceState.Charging === UPower.displayDevice.state 
}

