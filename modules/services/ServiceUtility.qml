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
            name: "Notifications",
            icon: "notification"
        },
        {
            name: "Dashboard",
            icon: "dashboard"
        }
    ]

    property var theme:[
        {
            name: "Dark",
            icon: "moon"
        },
        {
            name: "Light",
            icon: "sun"
        },
        {
            name: "Wallpaper",
            icon: "wallpaper"
        }
    ]
}
