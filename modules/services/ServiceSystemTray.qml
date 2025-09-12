pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import Quickshell.Services.SystemTray

Singleton{
    id: root
    
    property var items : SystemTray.items

    Component.onCompleted:{
        console.log("Data: " + SystemTray.items.values.length)
    }

    property bool isActive : items && items.values.length > 0
       
}
