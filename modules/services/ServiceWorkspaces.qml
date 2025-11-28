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

    function getWorkspace(index: int): HyprlandWorkspace {
        for(var i = 0; i < workspaces.values.length; i++){
            if(workspaces.values[i].id === index){
                return workspaces.values[i]
            }
        }
        return null
    }
}

