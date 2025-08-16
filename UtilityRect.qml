import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower

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

                 Rectangle{
                    id: ramUsage
                    implicitHeight: componentHeight
                    implicitWidth: cpuUsageWidth
                    color: "#1E1E2E"
                    radius: 10
                    border.color: "#45475A"
                    Row{
                        spacing: 8
                        anchors{
                            centerIn: parent
                        }
                        Image{
                            id: ramIcon
                            source: "./assets/ram.svg"
                            width: iconSize
                            height: iconSize
                            sourceSize: Qt.size(width, height)
                            layer.enabled: true
                            layer.effect: ColorOverlay{
                                color: "#F5F5F5"
                            }
                        }

                        Text{
                            anchors{
                                verticalCenter: parent.verticalCenter
                            }
                            text: Math.floor(ramMonitor.ramUsage) + "%"
                            color: "#CDD6F4"
                            font.pixelSize: 14
                        }

                        Rectangle{
                            id: ramBar
                            implicitWidth: 50
                            implicitHeight: 8
                            radius: 5
                            color: "#ccd0da"
                            anchors{
                                verticalCenter: parent.verticalCenter
                            }
                            clip: true

                            Rectangle{
                                implicitHeight: parent.height
                                implicitWidth: Math.floor(ramMonitor.ramUsage * parent.width / 100) + 5
                                radius: 5
                                color: "#A6E3A1"
                                anchors{
                                    verticalCenter: parent.verticalCenter 
                                }

                                Behavior on implicitWidth{
                                    NumberAnimation{duration: 100; easing.type: Easing.InCubic}
                                }
                            }
                        }
                    }
                }
                Rectangle{
                    id: cpuUsage
                    implicitHeight: componentHeight
                    implicitWidth: cpuUsageWidth
                    color: "#1E1E2E"
                    radius: 10
                    border.color: "#45475A"
                    Row{
                        spacing: 8
                        anchors{
                            centerIn: parent
                        }
                        Image{
                            id: cpuIcon
                            source: "./assets/cpu.svg"
                            width: iconSize
                            height: iconSize
                            sourceSize: Qt.size(width, height)
                            layer.enabled: true
                            layer.effect: ColorOverlay{
                                color: "#F5F5F5"
                            }
                        }

                        Text{
                            anchors{
                                verticalCenter: parent.verticalCenter
                            }
                            text: Math.floor(cpuMonitor.cpuUsage) + "%"
                            color: "#CDD6F4"
                            font.pixelSize: 14
                        }

                        Rectangle{
                            id: cpuBar
                            implicitWidth: 50
                            implicitHeight: 8
                            radius: 5
                            color: "#ccd0da"
                            anchors{
                                verticalCenter: parent.verticalCenter
                            }
                            clip: true

                            Rectangle{
                                implicitHeight: parent.height
                                implicitWidth: Math.floor(cpuMonitor.cpuUsage * parent.width / 100) + 5
                                radius: 5
                                color: "#EBA0AC"
                                anchors{
                                    verticalCenter: parent.verticalCenter 
                                }

                                Behavior on implicitWidth{
                                    NumberAnimation{duration: 100; easing.type: Easing.InCubic}
                                }
                            }
                        }
                    }
                }
                Rectangle{
                    id: wifi
                    implicitHeight: componentHeight
                    implicitWidth: componentWidth
                    color: "#1E1E2E"
                    radius: 10
                    objectName: "wifi"
                    border.color: "#45475A"

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
                    color: isActive ? "#fab387" : "#1E1E2E"
                    radius: 10
                    objectName: "bt"
                    border.color: "#45475A"
                    border.width: 1

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
                            color: "#F5F5F5"
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
                    id: battery
                    implicitWidth: batteryChild.implicitWidth + 15
                    implicitHeight: batteryChild.implicitHeight + 5
                    border.color: "#45475A"
                    color: {
                        if (UPower.displayDevice.state === UPowerDeviceState.Charging) return "#08CB00"
                        if (UPower.displayDevice.state === UPowerDeviceState.Discharging) return "#FFB22C"
                        return "#1E1E2E"
                    }
                    radius: 10
                    
                    Row{
                        id: batteryChild
                        spacing: 5
                        anchors{
                            centerIn: parent
                        }
                        Image{
                            width: 25
                            height: 25
                            sourceSize: Qt.size(width, height)

                            source: {
                                if(UPower.displayDevice.state === UPowerDeviceState.Charging){
                                    return "./assets/battery-charging.svg"
                                }
                                if(UPower.displayDevice.percentage < 0.70){
                                    return "./assets/battery-medium.svg"
                                }
                                if(UPower.displayDevice.percentage < 0.30){
                                    return "./assets/battery-low.svg"
                                }
                                return "./assets/battery.svg"
                            }
                    
                            layer.enabled: true
                            layer.effect: ColorOverlay{
                                color: "#F5F5F5"
                            }
                        }
                        Text{
                            anchors{
                                //centerIn: parent
                            
                            }
                            color: "#FFFFFF"
                            text: Math.round(UPower.displayDevice.percentage * 100) + "%"
                            font.pixelSize: 17
                            
                        }
                    }
                }

                 Rectangle{
                    id: notification
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
                    color: "#1E1E2E"
                    radius: 10
                    border.color: "#45475A"

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
                    color: "#1E1E2E"
                    radius: 10
                    border.color: "#45475A"

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
    }
}
