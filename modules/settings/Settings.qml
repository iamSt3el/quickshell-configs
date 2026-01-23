pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.utils

Item{
    id: settings

    property string layoutColor: Colors.surface
    property string activeTheme: "Wallpaper"
    property string profile: "/home/steel/Downloads/DANDADAN.jpg"
    property int dashboardHeight: 400
    property string defaultFont: "Rubik"
    property string wallpaper: Colors.wallpaper
    property string matugenTheme: "Default"
    property string matugenSetting: "Light"
    property string currentDisplayMode: "Extended"

    // Workspace configuration per monitor
    property var monitorWorkspaces: ({
        "eDP-1": { // Your HDMI monitor name - adjust this
            workspaces: [1, 2, 3, 4, 5],
            type: "external"
        }
            //,
        // "eDP-1": { // Your laptop display name - adjust this
        //     workspaces: [6, 7, 8, 9, 10],
        //     type: "laptop"
        // }
    })

    property var quickIcons:[
        {
            name: "Airplane",
            icon: "travel",
            iconActive: "airplanemode_inactive"

        },
        {
            name: "Notification",
            icon: "notifications",
            iconActive: "notifications_off"
        },
        {
            name: "Speaker",
            icon: "volume_up",
            iconActive: "volume_off"
        },
        {
            name: "Mic",
            icon: "mic",
            iconActive: "mic_off"
        }

    ]
    property var themeModes:[
        {
            name: "Dark",
            icon: "bedtime"
        },
        {
            name: "Light",
            icon: "sunny"
        },
        {
            name: "Wallpaper",
            icon: "wallpaper"
        }
    ]

    property var pages:[
        {
            name: "General",
            icon: "tune",
        },
        {
            name: "Theme",
            icon: "palette",
        },
        {
            name: "Display",
            icon: "monitor"
        },
        {
            name: "About",
            icon: 'info'
        }
    ]

    property var displayModes:[
        {
            name: "Extended",
            icon: "pan_zoom"
        },
        {
            name: "Mirror",
            icon: "tv_displays"
        },
        {
            name: "Single",
            icon: "monitor"
        }
    ]

    property var fonts:[
        { 
            name: "Noto Sans"
        },

        {
           name:"Fira Sans"
        },
        {
            name:"Readex Pro"
        },
        {
            name:"Cantarell"
        },
        {
            name: "Rubik"
        }
    ]

    property var matugen:[
        {
            name: "default",
            cmd: "scheme-tonal-spot"
        },
        {
            name: "Content",
            cmd: "scheme-content"
        },
        {
            name: "Expressive",
            cmd: "scheme-expressive"
        },
        {
            name: "Fidelity",
            cmd: "scheme-fidelity"
        },
        {
            name: "Fruit Salad",
            cmd: "scheme-fruit-salad"
        },
        {
            name: "Monochrome",
            cmd:"scheme-monochrome"
        },
        {
            name: "Neutral",
            cmd:"scheme-neutral"
        },
        {
            name: "Rainbow",
            cmd: "scheme-rainbow"
        }    
    ]

    function setActiveTheme(theme): void{
        settings.activeTheme = theme
    }

    function setDefaultFont(font): void{
        settings.defaultFont = font
    }

    function setMatugenTheme(theme): void{
        settings.matugenTheme = theme
    }

    function setMatugenSetting(type): void{
        settings.matugenSetting = type
    }

    // Get workspaces for a specific monitor
    function getWorkspacesForMonitor(monitorName): var {
        if (monitorWorkspaces[monitorName]) {
            return monitorWorkspaces[monitorName].workspaces
        }
        // Fallback: return 1-5 if monitor not found
        return [1, 2, 3, 4, 5]
    }

    // Get all workspaces NOT assigned to this monitor (for other screen indicator)
    function getOtherScreenWorkspaces(monitorName): var {
        var otherWorkspaces = []
        for (var monitor in monitorWorkspaces) {
            if (monitor !== monitorName) {
                otherWorkspaces = otherWorkspaces.concat(monitorWorkspaces[monitor].workspaces)
            }
        }
        return otherWorkspaces
    }
}
