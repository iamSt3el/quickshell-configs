pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton{
    id: root

    property var uptime

    function getUptime(){
        uptimeProc.running = true
        return uptime
    }

    Process{
        id: uptimeProc
        command: ["bash", "-c", "uptime -p | sed 's/up //' | sed 's/ hours*/h/' | sed 's/ minutes*/m/' | sed 's/,//g'"]

        property string buffer: ""

        stdout: SplitParser{
            onRead: data => {
                uptimeProc.buffer = data
            }
        }

        onExited: {
            root.uptime = buffer
        }
    }
}



