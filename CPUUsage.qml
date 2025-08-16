// CpuMonitor.qml - Simple CPU usage monitor
import QtQuick
import Quickshell.Io

Item {
    id: root
    
    // Public property - CPU usage percentage (0-100)
    property real cpuUsage: 0.0
    
    // Configuration
    property int updateInterval: 1000  // Update every 2 seconds
    
    // CPU Usage Process
    Process {
        id: cpuProcess
        command: ["sh", "-c", `
            # Read CPU stats twice with a small delay for accurate calculation
            read1=$(grep 'cpu ' /proc/stat)
            sleep 0.1
            read2=$(grep 'cpu ' /proc/stat)
            
            # Calculate CPU usage percentage
            echo "$read1" | awk '{idle1=$5; total1=$2+$3+$4+$5+$6+$7+$8; print idle1, total1}' > /tmp/cpu1
            echo "$read2" | awk '{idle2=$5; total2=$2+$3+$4+$5+$6+$7+$8; print idle2, total2}' > /tmp/cpu2
            
            awk 'BEGIN {usage=0}
                 NR==1 {idle1=$1; total1=$2}
                 NR==2 {
                     idle2=$1; total2=$2;
                     idle_diff = idle2 - idle1;
                     total_diff = total2 - total1;
                     if (total_diff > 0) {
                         usage = (1 - idle_diff/total_diff) * 100;
                         if (usage < 0) usage = 0;
                         if (usage > 100) usage = 100;
                     }
                 }
                 END {printf "%.1f", usage}' /tmp/cpu1 /tmp/cpu2
            
            # Cleanup
            rm -f /tmp/cpu1 /tmp/cpu2
        `]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let usage = parseFloat(this.text.trim());
                if (!isNaN(usage) && usage >= 0 && usage <= 100) {
                    root.cpuUsage = usage;
                }
            }
        }
    }
    
    // Update timer
    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        onTriggered: cpuProcess.running = true
    }
    
    // Initial update
    Component.onCompleted: cpuProcess.running = true
}
