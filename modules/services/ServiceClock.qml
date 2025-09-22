pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton{
    id: root

    SystemClock{
        id: clock
        precision: SystemClock.Seconds
    }
   
    property var date : Qt.formatDateTime(clock.date, "h:mm AP | ddd dd")
    property var time : Qt.formatDateTime(clock.date, "h:mm AP")
    
}
