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

        UserPanel{
            id: userPanelWrapper
        }

        NotificationPanel{
            id: notificationPanel
        }


        Rectangle{
            id: utilityRect
            implicitWidth: utilityRowWrapper.width + 20
            //implicitWidth: 300
            implicitHeight: 40
            color: colors.surfaceContainer
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
                    property var values: []
                    property int refCount: 1
                    property int barCount: 16
                    property real maxHeight: componentHeight
                    property real barWidth: 6
                    property real barSpacing: 2
                    
                    property var barColors: [
                        "#4ECDC4", "#45B7AF", "#96CEB4", "#FFEAA7",
                        "#DDA0DD", "#FFB6C1", "#98FB98", "#F0E68C",
                        "#87CEEB", "#DDA0DD", "#98FB98", "#4ECDC4",
                        "#99D1DB", "#A6D189", "#E5C890"
                    ]
                    
                    implicitHeight: componentHeight
                    implicitWidth: 135
                    color: "#1E1E2E"
                    radius: 10
                     
                    Process {
                        id: cavaProc
                        running: MprisPlaybackState.Playing
                        command: ["sh", "-c", `printf '[general]\nframerate=60\nbars=16\nsleep_timer=3\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100' | cava -p /dev/stdin`]
                        stdout: SplitParser {
                            onRead: data => {
                                if (musicPlayer.refCount)
                                    musicPlayer.values = data.slice(0, -1).split(";").map(v => parseInt(v, 10));
                            }
                        }
                    }

                    Row {
                        id: barsContainer
                        anchors.centerIn: parent
                        //width: parent.width
                        height: parent.height
                        spacing: musicPlayer.barSpacing
                        
                        Repeater {
                            id: barRepeater
                            model: musicPlayer.barCount
                            
                            Rectangle {
                                id: bar
                                width: musicPlayer.barWidth
                                height: {
                                    var value = index < musicPlayer.values.length ? musicPlayer.values[index] : 0
                                    return Math.max(2, (value / 100) * musicPlayer.maxHeight)
                                }
                                radius: musicPlayer.barWidth / 2
                                color: musicPlayer.barColors[index % musicPlayer.barColors.length]
                                anchors.bottom: parent.bottom

                                Behavior on height {
                                    SmoothedAnimation {
                                        duration: 100
                                        velocity: -1
                                    }
                                }
                            }
                        }
                    }
                    
                }*/

                Rectangle{
                    id: user
                    implicitWidth: componentWidth
                    implicitHeight: componentHeight

                    color: colors.surfaceVariant
                    radius: 10
                    Image{
                        anchors.centerIn: parent
                        width: iconSize
                        height: iconSize
                        sourceSize: Qt.size(width, height)
                        source: "./assets/user.svg"

                        layer.enabled: true
                        layer.effect: ColorOverlay{
                            color: colors.inverseSurface
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
                color: colors.surfaceVariant
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
                            color: colors.surfaceText
                        }
                    }

                    MouseArea{
                        id: monitorArea
                        hoverEnabled: true
                        implicitWidth: iconSize
                        implicitHeight: iconSize
                        anchors.centerIn: parent
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
                           color: "#f38ba8"
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
                            text: Math.round(Pipewire.defaultAudioSink.audio.volume * 100) + "%"
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
