import QtQuick
import Quickshell.Io

Item {
    id: root
    
    // Public properties for RAM
    property real ramUsage: 0.0
    property real totalRam: 0.0
    property real usedRam: 0.0
    
    // Public properties for CPU
    property real cpuUsage: 0.0
    
    // Public properties for Temperature
    property real cpuTemp: 0.0
    
    // Public properties for Disk Usage
    property real diskUsage: 0.0
    property real totalDisk: 0.0
    property real usedDisk: 0.0
    property real freeDisk: 0.0
    
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
    
    // CPU Usage Process (btop-style accuracy)
    Process {
        id: cpuProcess
        command: ["sh", "-c", `
            # Read /proc/stat twice with proper interval like btop
            cpu1=$(awk '/^cpu / {print $2+$3+$4, $5+$6}' /proc/stat)
            sleep 0.5
            cpu2=$(awk '/^cpu / {print $2+$3+$4, $5+$6}' /proc/stat)
            
            echo "$cpu1 $cpu2" | awk '{
                # cpu1: active1 idle1, cpu2: active2 idle2
                active1=$1; idle1=$2; active2=$3; idle2=$4;
                
                active_diff = active2 - active1;
                idle_diff = idle2 - idle1;
                total_diff = active_diff + idle_diff;
                
                if (total_diff > 0) {
                    cpu_usage = (active_diff / total_diff) * 100;
                    if (cpu_usage < 0) cpu_usage = 0;
                    if (cpu_usage > 100) cpu_usage = 100;
                    printf "%.1f", cpu_usage;
                } else {
                    print "0.0";
                }
            }'
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
    
    // Temperature Process
    Process {
        id: tempProcess
        command: ["sh", "-c", `
            # Try multiple temperature sources
            if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
                cat /sys/class/thermal/thermal_zone0/temp | awk '{printf "%.1f", $1/1000}'
            elif [ -d /sys/devices/platform/coretemp.0 ]; then
                find /sys/devices/platform/coretemp.0 -name "temp*_input" | head -1 | xargs cat | awk '{printf "%.1f", $1/1000}'
            elif command -v sensors >/dev/null 2>&1; then
                sensors | grep -E "Core 0|Package id 0|Tctl" | head -1 | grep -oE "[0-9]+\.[0-9]+" | head -1
            else
                echo "0.0"
            fi
        `]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let temp = parseFloat(this.text.trim());
                if (!isNaN(temp) && temp >= 0 && temp <= 150) {
                    root.cpuTemp = temp;
                }
            }
        }
    }
    
    // Disk Usage Process
    Process {
        id: diskProcess
        command: ["sh", "-c", `
            df -h / | awk 'NR==2 {
                # Remove units and convert to GB
                gsub(/[KMGT]/, "", $2); gsub(/[KMGT]/, "", $3); gsub(/[KMGT]/, "", $4);
                total = $2; used = $3; free = $4;
                
                # Convert based on original unit
                if (match($2, /T/)) total *= 1024;
                else if (match($2, /G/)) total *= 1;
                else if (match($2, /M/)) total /= 1024;
                else if (match($2, /K/)) total /= 1048576;
                
                if (match($3, /T/)) used *= 1024;
                else if (match($3, /G/)) used *= 1;
                else if (match($3, /M/)) used /= 1024;
                else if (match($3, /K/)) used /= 1048576;
                
                if (match($4, /T/)) free *= 1024;
                else if (match($4, /G/)) free *= 1;
                else if (match($4, /M/)) free /= 1024;
                else if (match($4, /K/)) free /= 1048576;
                
                usage_percent = (used / total) * 100;
                printf "%.1f %.1f %.1f %.1f", usage_percent, total, used, free
            }' | head -1 || df / | awk 'NR==2 {
                total = $2/1048576; used = $3/1048576; free = $4/1048576;
                usage_percent = (used / total) * 100;
                printf "%.1f %.1f %.1f %.1f", usage_percent, total, used, free
            }'
        `]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let parts = this.text.trim().split(" ");
                if (parts.length >= 4) {
                    let usage = parseFloat(parts[0]);
                    let total = parseFloat(parts[1]);
                    let used = parseFloat(parts[2]);
                    let free = parseFloat(parts[3]);
                    
                    if (!isNaN(usage) && usage >= 0 && usage <= 100) {
                        root.diskUsage = usage;
                        root.totalDisk = total;
                        root.usedDisk = used;
                        root.freeDisk = free;
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
        onTriggered: {
            ramProcess.running = true
            cpuProcess.running = true
            tempProcess.running = true
            diskProcess.running = true
        }
    }
    
    // Initial update
    Component.onCompleted: {
        ramProcess.running = true
        cpuProcess.running = true
        tempProcess.running = true
        diskProcess.running = true
    }
}
