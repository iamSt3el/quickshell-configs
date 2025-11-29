pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick


Singleton{
    property var utility:[
        {
            name: "Wifi",
            icon: "wifi"
        },
        {
            name: "Bluetooth",
            icon: "bluetooth"
        },
        {
            name: "PowerProfiles",
            icon: ServiceUPower.powerProfileIconPath
        },
        {
            name: "Notifications",
            icon: "notification"
        }
    ] 
}
