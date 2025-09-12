pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton{
    id: root
    
    property var workspaces: Hyprland.workspaces 

    function refreshToplevels(): void{ 
        Hyprland.refreshToplevels()
    }
}
