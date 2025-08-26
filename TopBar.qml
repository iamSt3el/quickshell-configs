import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland

Scope{
    id: topBarRoot
   

    Variants{
        model: Quickshell.screens

        PanelWindow{
            required property var modelData
            screen: modelData
            color: "transparent"


            id: topBar

            implicitHeight: 50
            anchors{
                left: true
                right: true
                top: true
            }

            Process{
                id: cursorProcess
                command: ["hyprctl", "cursorpos"]
                running: false

                stdout: StdioCollector{
                    onStreamFinished:{
                        let coords = this.text.trim().split(", ")
                        if(coords.length === 2){
                            aipanel.mouseX = parseInt(coords[0])
                            aipanel.mouseY = parseInt(coords[1])
                        }

                        console.log(aipanel.mouseX + " " + aipanel.mouseY)
                    }
                }
            }

            /*PopupWindow{
                implicitWidth: 1920
                implicitHeight: 100
                color: "red"
                visible: true
                anchor{
                    window: topBar
                    rect.x: 60
                    rect.y: 0
                }
            }*/

            WorkspaceRect{}
            MiddleRect{}
            UtilityRect{}
            
        }
    }
}
