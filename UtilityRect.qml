import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects

Item{
    id: utilityRectItem
    anchors{
        right: parent.right
    }
    Rectangle{
        id: utilityRectWrapper
        implicitWidth: utilityRect.width + 10
        implicitHeight: 50
        color: "transparent"
        anchors{
            right: parent.right
        }

         Shape{
            ShapePath{
                fillColor: "#06070e"
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
            implicitWidth: utilityRowWrapper.width + 100
            implicitHeight: 40
            color: "#06070e"
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
                    id: wifi
                    implicitHeight: 30
                    implicitWidth: 35
                    color: "#393E46"
                    radius: 10

                    Image{
                        id: wifiIcon
                        anchors.centerIn: parent
                        width: 25
                        height: 25
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
                        onEntered:{
                            utilityPopupWrapper.open()
                            //utilityPopupWrapper.isUtilityPopUpVisible = true
                            utilityPopupWrapper.utility = wifi
                        }
                        onExited:{
                            utilityPopupWrapper.utilityCloseTimer.start()
                            //utilityPopupWrapper.isUtilityPopUpVisible = false
                        }
                        onClicked:{
                            console.log("Pressed")
                            Quickshell.execDetached(["kitty", "--class", "nmtui-popup", "-e", "nmtui"])
                        }
                    }
                }

                Rectangle{
                    id: bt
                    implicitWidth: 35
                    implicitHeight: 30
                    color: "#393E46"
                    radius: 10

                    Image{
                        anchors{
                            //fill: parent
                            centerIn: parent
                        }
                        width: 25
                        height: 25
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
                        onEntered: {
                            utilityPopupWrapper.open()
                            //utilityPopupWrapper.isUtilityPopUpVisible = true
                            utilityPopupWrapper.utility = bt
                        }
                        onExited: {
                            utilityPopupWrapper.utilityCloseTimer.start()
                            //utilityPopupWrapper.isUtilityPopUpVisible = false
                        }
                        onClicked:{
                            console.log("Pressed")
                            Quickshell.execDetached(["blueman-manager"])
                        }
                    }

                }

                 Rectangle{
                    id: battery
                    implicitWidth: batteryChild.implicitWidth + 10
                    implicitHeight: batteryChild.implicitHeight + 5
                    color: "#393E46"
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

                            source: "./assets/battery.svg"
                    
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
                            text: "90%"
                            font.pixelSize: 17
                            
                        }
                    }
                }

                 Rectangle{
                    id: notification
                    implicitWidth: 35
                    implicitHeight: 30
                    color: "#393E46"
                    radius: 10

                    Image{
                        anchors{
                            centerIn: parent
                        }
                        width: 25
                        height: 25
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
                    implicitWidth: 35
                    implicitHeight: 30
                    color: "#393E46"
                    radius: 10

                    Image{
                        anchors{
                            centerIn: parent
                        }
                        width: 25
                        height: 25
                        sourceSize: Qt.size(width, height)
                        source: "./assets/shutdown.svg"
                    
                        layer.enabled: true
                        layer.effect: ColorOverlay{
                           color: "#F5F5F5"
                       }
                   }
               }


                 Rectangle{
                    id: logo
                    implicitWidth: 30
                    implicitHeight: 30
                    color: "transparent"

                    Image{
                        anchors{
                            fill: parent
                        }
                        width: 30
                        height: 30
                        sourceSize: Qt.size(width, height)
                        source: "./assets/arch.svg"
                    }
                }
            }


        }
    
    }
}
