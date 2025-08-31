import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: root
    
    // Public properties for system information
    property string distro: ""
    property string hostname: ""
    property string kernel: ""
    property string uptime: ""
    property string packages: ""
    property string shell: ""
    property string desktop: ""
    property string cpu: ""
    property string gpu: ""
    property string memory: ""
    property string disk: ""
    property string localIp: ""
    property string locale: ""
    
    // Fastfetch process to get all system info
    Process {
        id: fastfetchProcess
        command: ["fastfetch", "--format", "json"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(this.text)
                    //console.log("data: " + this.text)
                    
                    // Parse fastfetch JSON output
                    data.forEach(item => {
                        if (!item.result || item.error) return
                        
                        switch(item.type) {
                            case "OS":
                                root.distro = item.result.prettyName || item.result.name || ""
                                break
                            case "Title":
                                if (item.result.hostName) {
                                    root.hostname = item.result.hostName
                                }
                                if (item.result.userShell) {
                                    root.shell = item.result.userShell.split('/').pop()
                                }
                                break
                            case "Host":
                                root.hostname = item.result.name || item.result.family || ""
                                break
                            case "Kernel":
                                root.kernel = item.result.release || item.result.name || ""
                                break
                            case "Uptime":
                                if (item.result.uptime) {
                                    const seconds = item.result.uptime / 1000
                                    const hours = Math.floor(seconds / 3600)
                                    const minutes = Math.floor((seconds % 3600) / 60)
                                    root.uptime = `${hours}h ${minutes}m`
                                }
                                break
                            case "Packages":
                                root.packages = item.result.all?.toString() || ""
                                break
                            case "Shell":
                                root.shell = item.result.name || item.result.exe || ""
                                break
                            case "DE":
                            case "WM":
                                root.desktop = item.result.name || item.result.processName || ""
                                break
                            case "CPU":
                                root.cpu = item.result.cpu || item.result.name || ""
                                break
                            case "GPU":
                                root.gpu = item.result.name || ""
                                break
                            case "Memory":
                                if (item.result.used && item.result.total) {
                                    const used = item.result.used / 1024 / 1024 / 1024
                                    const total = item.result.total / 1024 / 1024 / 1024
                                    root.memory = `${used.toFixed(1)} GB / ${total.toFixed(1)} GB`
                                }
                                break
                            case "Disk":
                                if (item.result.used && item.result.total) {
                                    const used = item.result.used / 1024 / 1024 / 1024
                                    const total = item.result.total / 1024 / 1024 / 1024
                                    root.disk = `${used.toFixed(1)} GB / ${total.toFixed(1)} GB`
                                }
                                break
                            case "LocalIp":
                                if (Array.isArray(item.result) && item.result.length > 0) {
                                    // Find the interface with default route
                                    const defaultInterface = item.result.find(iface => iface.defaultRoute && iface.defaultRoute.ipv4)
                                    if (defaultInterface) {
                                        root.localIp = defaultInterface.ipv4.split('/')[0] // Remove subnet mask
                                    } else if (item.result[0].ipv4) {
                                        root.localIp = item.result[0].ipv4.split('/')[0]
                                    }
                                }
                                break
                            case "Locale":
                                root.locale = item.result.name || ""
                                break
                        }
                    })
                } catch (e) {
                    console.log("Failed to parse fastfetch JSON:", e)
                }
            }
        }
    }
    
    
    // Initial data collection
    Component.onCompleted: {
        fastfetchProcess.running = true
    }
}
