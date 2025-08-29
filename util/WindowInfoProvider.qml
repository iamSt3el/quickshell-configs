import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: windowInfoProvider
    
    signal appClassRetrieved(string address, string appClass)
    
    function getAppClass(windowAddress) {
        const process = processComponent.createObject(windowInfoProvider, {
            targetAddress: windowAddress
        })
        process.running = true
    }
    
    Component {
        id: processComponent
        
        Process {
            property string targetAddress: ""
            command: ["hyprctl", "clients", "-j"]
            running: false
            
            stdout: StdioCollector {
                onStreamFinished: {
                    try {
                        const clients = JSON.parse(this.text)
                        const fullAddress = "0x" + targetAddress
                        const client = clients.find(c => c.address === fullAddress)
                        if (client) {
                            const appClass = client.class || client.initialClass || "unknown"
                            windowInfoProvider.appClassRetrieved(targetAddress, appClass)
                        } else {
                            console.log(`Client not found for address: ${fullAddress}`)
                            windowInfoProvider.appClassRetrieved(targetAddress, "unknown")
                        }
                    } catch (e) {
                        console.log("Window info error:", e)
                        windowInfoProvider.appClassRetrieved(targetAddress, "unknown")
                    }
                }
            }
            
            Component.onDestruction: {
                this.destroy()
            }
        }
    }
}