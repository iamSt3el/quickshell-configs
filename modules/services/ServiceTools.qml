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
                    icon: "screen",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave output"]

                },
                {
                    name: "Window",
                    icon: "window",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave active"]

                },
                {
                    name: "Area",
                    icon: "select",
                    command: ["sh", "-c", "sleep 0.5 && grimblast --notify copysave area"]

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
                    icon: "power",
                    command: ["systemctl", "poweroff"]


                },
                {
                    name: "Restart",
                    icon: "restart",
                    command: ["systemctl", "reboot"]

                },
                {
                    name: "Logout",
                    icon: "logout",
                    command: ["hyprctl", "dispatch", "exit"]

                }
            ]
        }
    ]


}
