import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

Item{
    id: utilityRectItem
    
    // Size configuration
    readonly property int componentHeight: 30
    readonly property int componentWidth: 40
    readonly property int cpuUsageWidth: 135
    readonly property int wrapperHeight: 50
    readonly property int iconSize: 20
    
    //implicitWidth: utilityRectWrapper.width
    anchors{
        right: parent.right
    }

    CPUUsage{
        id: cpuMonitor
    }
    
    RAMUsage{
        id: ramMonitor
    } 
    Rectangle{
        id: utilityRectWrapper
        implicitWidth: utilityRect.width + 10
        //implicitWidth: 310
        implicitHeight: wrapperHeight
        color: "transparent"
        anchors{
            right: parent.right
        }

         Shape{
            ShapePath{
                fillColor: "#11111b"
                //strokeColor: "blue"
                strokeWidth: 0
                startX: utilityRectWrapper.width
                startY: utilityRectWrapper.height

                PathArc{
                    relativeX: -20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: -(utilityRectWrapper.width - 30) 
                    relativeY: -(utilityRectWrapper.height - 20)
                }
                

                PathArc{
                    relativeX: -20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    direction: PathArc.Counterclockwise
                }
                
                PathLine{
                    relativeX: utilityRectWrapper.width + 10
                    relativeY: 0

                }
            }
        }
        UtilityPopupWindow{
              id: utilityPopupWrapper 
        }

        MonitorPopup{
            id: monitorPopupWrapper
        }

        UserPanel{
            id: userPanelWrapper
        }

        Rectangle{
            id: utilityRect
            implicitWidth: utilityRowWrapper.width + 20
            //implicitWidth: 300
            implicitHeight: 40
            color: "#11111b"
            bottomLeftRadius: 20

          
            anchors{
                right: parent.right
            }

            Row{
                id: utilityRowWrapper
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: 10
                }
                spacing: 10

                /*Rectangle{
                    id: musicPlayer
                    implicitHeight: componentHeight
                    implicitWidth: 135
                    color: "#1E1E2E"
                    radius: 10

                    Text{
                        text: Pipewire.PwNode.description
                    }
                }*/

                Rectangle{
                    id: user
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight

                    color: "#313244"
                    radius: 10
                    Image{
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/user.svg"

                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            color: "#74c7ec"
                        }
                    }

                    MouseArea{
                        id: userArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked:{
                            if(userPanelWrapper.userPanelVisible){
                                userPanelWrapper.userPanelVisible = false
                            }else{
                                userPanelWrapper.userPanelVisible = true
                            }
                        }
                    }
                }

             
            Rectangle{
                implicitWidth: monitor.width + bt.width + wifi.width + notification.width + power.width
                implicitHeight: componentHeight
                color: "#313244"
                radius: 10
                Row{
                    anchors{
                        fill: parent
                    }
                Rectangle{
                    id: monitor
                    implicitHeight: componentHeight
                    implicitWidth: componentWidth
                    //color: monitorArea.containsMouse ? "#a6da95" : "#1E1E2E"
                    color:"transparent"
                    //radius: 10
                    //border.color: monitorArea.containsMouse ? "#1E1E2E" : "transparent"

                    Behavior on color{
                        ColorAnimation{duration: 200}
                    }

                    Image{
                        id: monitorIcon
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/monitor.svg"

                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            //color: "#F5F5F5"
                            color: "#94e2d5"
                        }
                    }

                    MouseArea{
                        id: monitorArea
                        hoverEnabled: true
                        anchors.fill: parent
                        onEntered: {
                            monitorPopupWrapper.timer.stop()
                            monitorPopupWrapper.isMonitorVisible= true
                        }

                        onExited:{
                            monitorPopupWrapper.timer.start()
                        }

                    }
                }
                Rectangle{
                    id: wifi
                    implicitHeight: componentHeight
                    implicitWidth: componentWidth
                    //color: "#1E1E2E"
                    //radius: 10
                    objectName: "wifi"
                    //border.color: "#45475A"
                    color: "transparent"
                    
                    Image{
                        id: wifiIcon
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/wifi.svg"

                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            color: "#F5F5F5"
                        }
                    }

                    MouseArea{
                        id: wifiArea
                        anchors{
                            fill: parent
                        }
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            /*if(utilityPopupWrapper.isUtilityPopUpVisible){
                                utilityPopupWrapper.close()
                            }else{
                                 utilityPopupWrapper.open()
                             }*/
                           Quickshell.execDetached(["kitty", "--class", "nmtui-popup", "-e", "nmtui"])
                        }
                    }
                }

                Rectangle{
                    id: bt
                    property bool isActive: false
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
                    //color: isActive ? "#fab387" : "#1E1E2E"
                    //radius: 10
                    //objectName: "bt"
                    //border.color: "#45475A"
                    //border.width: 1
                    color: "transparent"

                    Behavior on color{
                        ColorAnimation{duration: 200}
                    }


                    Image{
                        anchors{
                            //fill: parent
                            centerIn: parent
                        }
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)

                        source: "./assets/bluetooth.svg"
                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            color: bt.isActive ? "#fab387" : "#F5F5F5"
                        }
                    }

                    MouseArea{
                        id: btArea
                        anchors{
                            fill: parent
                        }
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            if(utilityPopupWrapper.isUtilityPopUpVisible){
                                bt.isActive = false
                                utilityPopupWrapper.close()
                            }else{
                                utilityPopupWrapper.utility = bt
                                bt.isActive = true
                                utilityPopupWrapper.open()
                            }

                            //Quickshell.execDetached(["blueman-manager"])
                        }
                    }

                }

               
                 Rectangle{
                    id: notification
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
                    //color: "#1E1E2E"
                    //radius: 10
                    //border.color: "#45475A"
                    color: "transparent"
                    Image{
                        anchors{
                            centerIn: parent
                        }
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/notification.svg"
                    
                        layer.enabled: true
                        layer.effect: ColorOverlay{
                           color: "#F5F5F5"
                       }
                   }
               }
                 Rectangle{
                    id: power
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
                    //color: "#1E1E2E"
                    //radius: 10
                    //border.color: "#45475A"
                    color: "transparent"
                    Image{
                        anchors{
                            centerIn: parent
                        }
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/shutdown.svg"
                    
                        layer.enabled: true
                        layer.effect: ColorOverlay{
                           color: "#F5F5F5"
                       }
                   }
               }
           }
       }

                 Rectangle{
                    id: battery
                    //implicitWidth: batteryChild.implicitWidth + 15
                    //implicitHeight: batteryChild.implicitHeight + 5
                    implicitWidth: componentWidth + 4
                    implicitHeight: componentHeight 
                    //border.color: "#45475A"
                    /*color: {
                        //if (UPower.displayDevice.state === UPowerDeviceState.Charging) return "#08CB00"
                        //if (UPower.displayDevice.state === UPowerDeviceState.Discharging) return "#FFB22C"
                        //return "#45475A"
                    }*/
                    radius: 10
                    color: "transparent"
                    
                    Rectangle{
                        id: wrapper
                        implicitWidth: parent.width - 10
                        implicitHeight: parent.height - 10
                        color: "#45475A"
                        radius: 5
                        anchors{
                            left: parent.left
                            verticalCenter: parent.verticalCenter

                        }
                            Rectangle{
                                implicitHeight: parent.height
                                implicitWidth: (parent.width * UPower.displayDevice.percentage)
                                color: {
                                    if (UPower.displayDevice.state === UPowerDeviceState.Charging) return "#A6E3A1"
                                    if (UPower.displayDevice.state === UPowerDeviceState.Discharging) return "#FFB22C"
                                    return "#A6E3A1"
                                }
                                radius: 5
                                

                                anchors{
                                    //leftMargin: 5
                                    //verticalCenter: parent.verticalCenter
                                    left: parent.left 
                                }
                            }

                            Text{ 
                                anchors{
                                    centerIn: parent
                                }
                                color: "#FFFFFF"
                                text: Math.round(UPower.displayDevice.percentage * 100)
                                font.pixelSize: 16
                        }
                    }
                

                    Rectangle{
                        implicitHeight: 10
                        implicitWidth: 6
                        color: "#45475A"
                        topRightRadius: 5
                        bottomRightRadius: 5
                        anchors{
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }

            }
        }    
    }
}
