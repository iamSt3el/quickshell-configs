import QtQuick
import Quickshell.Io
import qs.util

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
    
    // Configuration - Direct file reading like modern approach
    property int updateInterval: 3000  // 3 seconds
    property var previousCpuStats
    
    // Direct file reading - much more efficient than processes
    FileView { id: fileMeminfo; path: "/proc/meminfo" }
    FileView { id: fileStat; path: "/proc/stat" }
    FileView { id: fileThermal; path: "/sys/class/thermal/thermal_zone0/temp" }
    
    // Single process for disk usage (no /proc equivalent)
    Process {
        id: diskProcess
        command: ["df", "/", "--output=size,used,avail,pcent"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split('\n')
                if (lines.length >= 2) {
                    let parts = lines[1].trim().split(/\s+/)
                    if (parts.length >= 4) {
                        let total = parseFloat(parts[0]) / 1048576 // Convert KB to GB
                        let used = parseFloat(parts[1]) / 1048576
                        let free = parseFloat(parts[2]) / 1048576
                        let usage = parseFloat(parts[3].replace('%', ''))
                        
                        if (!isNaN(usage)) {
                            root.diskUsage = usage
                            root.totalDisk = total
                            root.usedDisk = used
                            root.freeDisk = free
                        }
                    }
                }
            }
        }
    }
    
    // Update timer - reads files directly
    Timer {
        interval: root.updateInterval
        running: true
        repeat: true
        onTriggered: {
            // Reload files
            fileMeminfo.reload()
            fileStat.reload()
            fileThermal.reload()
            
            // Parse memory usage
            const textMeminfo = fileMeminfo.text()
            const memoryTotal = Number(textMeminfo.match(/MemTotal:\s*(\d+)/)?.[1] ?? 1) / 1024 / 1024 // KB to GB
            const memoryFree = Number(textMeminfo.match(/MemAvailable:\s*(\d+)/)?.[1] ?? 0) / 1024 / 1024
            const memoryUsed = memoryTotal - memoryFree
            
            if (memoryTotal > 0) {
                root.totalRam = memoryTotal
                root.usedRam = memoryUsed
                root.ramUsage = (memoryUsed / memoryTotal) * 100
            }
            
            // Parse CPU usage
            const textStat = fileStat.text()
            const cpuLine = textStat.match(/^cpu\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)/)
            if (cpuLine) {
                const stats = cpuLine.slice(1).map(Number)
                const total = stats.reduce((a, b) => a + b, 0)
                const idle = stats[3]
                
                if (previousCpuStats) {
                    const totalDiff = total - previousCpuStats.total
                    const idleDiff = idle - previousCpuStats.idle
                    root.cpuUsage = totalDiff > 0 ? ((totalDiff - idleDiff) / totalDiff) * 100 : 0
                }
                
                previousCpuStats = { total, idle }
            }
            
            // Parse temperature
            const tempText = fileThermal.text().trim()
            if (tempText && tempText !== "") {
                const temp = Number(tempText) / 1000 // millidegrees to degrees
                if (!isNaN(temp) && temp >= 0 && temp <= 150) {
                    root.cpuTemp = temp
                }
            }
            
            // Update disk (less frequently)
            if (diskProcess && !diskProcess.running) {
                diskProcess.running = true
            }
        }
    }
    
    // Initial update
    Component.onCompleted: {
        // Trigger initial readings
        fileMeminfo.reload()
        fileStat.reload()
        fileThermal.reload()
        diskProcess.running = true
    }
}
