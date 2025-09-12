import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland
import Qt5Compat.GraphicalEffects
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import Quickshell.Services.Mpris
import qs.util
import Quickshell.Services.SystemTray
import QtQuick.Effects

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
    
    Colors {
        id: colors
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

        
        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          blurMax: 15
          shadowColor: Qt.alpha(colors.shadow, 1)
        }
          


        Shape{
            preferredRendererType: Shape.CurveRenderer
            ShapePath{
                fillColor: colors.surfaceContainer
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

        // Conditional loading - only create when needed
        // NotificationPanel{
        //     id: notificationPanel
        // }

        // PowerPanel{
        //     id: powerPanel
        // } 


        Rectangle{
            id: utilityRect
            implicitWidth: utilityRowWrapper.width + 20
            //implicitWidth: 300
            implicitHeight: 40
            color: colors.surfaceContainer
            bottomLeftRadius: 20

            Behavior on implicitWidth{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutCirc
                }
            }

          
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
                    id: sysTray
                    implicitWidth: sysTrayRow.width + 10
                    implicitHeight: componentHeight
                    color: colors.surfaceVariant
                    visible: sysTrayRow.width != 0
                    radius: 10

                    Row{
                        id: sysTrayRow
                        anchors.centerIn: parent
                        spacing: 8
                        Repeater{
                            model: SystemTray.items

                            delegate: Item{
                                id: sysTrayIcon
                                implicitWidth: 25
                                implicitHeight: 25

                                Image{
                                    anchors.centerIn: parent
                                    width: parent.width
                                    height: parent.height
                                    sourceSize: Qt.size(width, height)
                                    source: modelData.icon
                                }

                                MouseArea{
                                    id: iconArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: function(mouse) {

                                        console.log(modelData.icon)
                                        if(mouse.button === Qt.RightButton && modelData.hasMenu){ 
                                            modelData.display(topBar, utilityRectItem.x - utilityRectWrapper.width , 40)
                                        }

                                        if(mouse.button === Qt.LeftButton){
                                            modelData.activate()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Music player visualization removed to reduce memory usage



             
            Rectangle{
                implicitWidth:  bt.width + wifi.width + notification.width + power.width
                implicitHeight: componentHeight
                color: colors.surfaceVariant
                radius: 10
                Row{
                    anchors{
                        fill: parent
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
                            color: colors.surfaceText
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
                 
                           Quickshell.execDetached(["kitty", "--class", "nmtui-popup", "-e", "nmtui"])
                        }
                    }
                }

                Rectangle{
                    id: bt
                    property bool isActive: false
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
            
                    color: "transparent"

                    Behavior on color{
                        ColorAnimation{duration: 200}
                    }


                    Image{
                        anchors{
                            centerIn: parent
                        }
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)

                        source: "./assets/bluetooth.svg"
                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            color: bt.isActive ? "#fab387" : colors.surfaceText
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

                        }
                    }

                }

               
                 Rectangle{
                    id: notification
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
                
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
                           color: colors.surfaceText
                       }
                   }

                   MouseArea{
                       id: notifArea
                       hoverEnabled: true
                       anchors.fill: parent
                       cursorShape: Qt.PointingHandCursor
                       onClicked:{
                           if(notificationPanel.isNotifVisible){
                               notificationPanel.close()
                           }else{
                               notificationPanel.open()
                           }

                       }
                   }
               }
                 Rectangle{
                    id: power
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight
            
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
                           color: "#f38ba8"
                       }
                   }

                   MouseArea{
                       id: powerArea
                       anchors.fill: parent
                       cursorShape: Qt.PointingHandCursor 
                       hoverEnabled: true
                       onClicked:{
                          Quickshell.execDetached(["bash", "/home/steel/.config/ml4w/scripts/wlogout.sh"])
                       }
                   }

               }
           }
       }

Row {
                    spacing: 18
                    
                    Rectangle{
                        id: speaker
                       
                        implicitWidth: componentWidth + 40
                        implicitHeight: componentHeight 
                    
                        radius: 10
                        color: colors.surfaceVariant

                    
                        Text{
                            anchors.leftMargin: 8
                            text: Pipewire.defaultAudioSink && Pipewire.defaultAudioSink.audio 
                                ? Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%" 
                                : "0%"
                            font.pixelSize: 16
                            anchors.left: parent.left
                            font.weight: 900
                            anchors.verticalCenter: parent.verticalCenter
                            color: colors.surfaceText
                        }

                        Rectangle{
                            anchors.rightMargin: -10
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            implicitWidth: 36
                            implicitHeight: 36
                            radius: 30
                            color: colors.primaryContainer
                            property string icon: {
                                if (!Pipewire.defaultAudioSink || !Pipewire.defaultAudioSink.audio) return "./assets/speaker-muted.svg"
                                if (Pipewire.defaultAudioSink.audio.muted) return "./assets/speaker-muted.svg"
                                if (Pipewire.defaultAudioSink.audio.volume > 0.6) return "./assets/speaker.svg"
                                if (Pipewire.defaultAudioSink.audio.volume > 0.2) return "./assets/speaker-medium.svg"
                                if (Pipewire.defaultAudioSink.audio.volume > 0) return "./assets/speaker-low.svg"
                                return "./assets/speaker-muted.svg"
                            }

                            Image{
                                anchors.centerIn: parent
                                width: 20
                                height: 20
                                sourceSize: Qt.size(width,height)
                                source: parent.icon
                                layer.enabled: true
                                layer.effect: ColorOverlay{
                                    color: colors.primaryContainerText
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
                                }
                                onWheel: function(wheel) {
                                    var delta = wheel.angleDelta.y / 120 * 0.01
                                    Pipewire.defaultAudioSink.audio.volume = Math.max(0, Math.min(1, Pipewire.defaultAudioSink.audio.volume + delta))
                                }
                            }
                        }
                    }

                    Rectangle{
                        id: battery
                        implicitWidth: componentWidth + 40
                        implicitHeight: componentHeight 
                      
                        radius: 10
                        color: colors.surfaceVariant

                
                    Text{
                        anchors.leftMargin: 8
                        text: UPower.displayDevice.percentage * 100 + "%"
                        font.pixelSize: 16
                        anchors.left: parent.left
                        font.weight: 900
                        anchors.verticalCenter: parent.verticalCenter
                        color: colors.surfaceText
                    }

                    Rectangle{
                        anchors.rightMargin: -10
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth: 36
                        implicitHeight: 36
                        radius: 30
                        color: colors.primaryContainer
                        property string icon: {
                            if (UPower.displayDevice.state === UPowerDeviceState.Charging) return "./assets/battery-charging.svg"
                            if(UPower.displayDevice.percentage < 0.5) return "./assets/battery-medium.svg"
                            if(UPower.displayDevice.percentage == 0.3) return "./assets/battery-low.svg"
                            return "./assets/battery.svg"
                        }

                        Image{
                            anchors.centerIn: parent
                            width: 20
                            height: 20
                            sourceSize: Qt.size(width,height)
                            source: parent.icon
                            rotation: -90
                            layer.enabled: true
                            layer.effect: ColorOverlay{
                                color: "#FFFFFF"
                            }
                        }
                    }
                }
                }
            }
        }    
    }
}
