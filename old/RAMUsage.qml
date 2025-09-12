import QtQuick
import Quickshell.Io

Item {
    id: root
    
    // Public properties
    property real ramUsage: 0.0
    property real totalRam: 0.0
    property real usedRam: 0.0
    
    // Configuration
    property int updateInterval: 1000
    
    // RAM Usage Process
    Process {
        id: ramProcess
        command: ["sh", "-c", `
            awk '/MemTotal:/ {total=$2} 
                 /MemAvailable:/ {available=$2} 
                 END {
                     used = total - available;
                     usage_percent = (used / total) * 100;
                     printf "%.1f %.1f %.1f", usage_percent, total/1024/1024, used/1024/1024
                 }' /proc/meminfo
        `]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(" ");
                if (parts.length >= 3) {
                    let usage = parseFloat(parts[0]);
                    let total = parseFloat(parts[1]);
                    let used = parseFloat(parts[2]);
                    
                    if (!isNaN(usage) && usage >= 0 && usage <= 100) {
                        root.ramUsage = usage;
                        root.totalRam = total;
                        root.usedRam = used;
                    }
                }
            }
        }
    }
    
    // Update timer
    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        onTriggered: ramProcess.running = true
    }
    
    // Initial update
    Component.onCompleted: ramProcess.running = true
}