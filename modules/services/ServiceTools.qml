pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick


Singleton{
    property var tools: [
        {
            name: "Record",
            icon: "video",
            options:[
                {
                    name: "Screen",
                    icon: "screen"
                },
                {
                    name: "Window",
                    icon: "window"
                },
                {
                    name: "Area",
                    icon: "select"
                }
            ]
        },
        {
            name: "Screenshot",
            icon: "camera",
            options:[
                {
                    name: "Screen",
                    icon: "screen"
                },
                {
                    name: "Window",
                    icon: "window"
                },
                {
                    name: "Area",
                    icon: "select"
                }
            ]
        },
        {
            name: "Setting",
            icon: "setting"
        },
        {
            name: "Power",
            icon: "power",
            options:[
                {
                    name: "Shutdown",
                    icon: "power"

                },
                {
                    name: "Restart",
                    icon: "restart"
                },
                {
                    name: "Logout",
                    icon: "logout"
                }
            ]
        }
    ]
}
