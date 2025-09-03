import Quickshell
import QtQuick
import Quickshell.Io
import qs.util

Item {
    id: root
    
    // Properties passed from parent Dashboard
    property bool isDashboardVisible: false
    property var colors
    property var systemMonitor  
    property var sysInfo

    Colors{
        id: colors
    }

    SystemMonitor{
        id: systemMonitor
    }
    
    SystemInfo{
        id: sysInfo
    }

    Row{
        anchors.fill: parent

        Column{
            width: parent.width - parent.width / 3
            height: parent.height
            
            Item{
                width: parent.width
                height: parent.height / 3
                
                Row{
                    anchors.fill: parent
                    
                    Item{
                        implicitHeight: parent.height
                        implicitWidth: parent.width - parent.width / 3

                        Rectangle{
                            implicitHeight: parent.height - 10
                            implicitWidth: parent.width - 10
                            anchors.centerIn: parent
                            color: colors.surfaceVariant
                            radius: 10

                            Item{
                                width: parent.width
                                height: parent.height
                
                                    Column{
                                        anchors.fill: parent
                                        anchors.margins: 10

                                        Item{
                                            implicitWidth: parent.width
                                            implicitHeight: parent.height / 5
                                    
                                            Row{
                                            anchors.fill: parent
                                            spacing: 10
                                        
                                                Image{
                                                    width: 25
                                                    height: 25
                                                    sourceSize: Qt.size(width, height)
                                                    source: "./assets/linux-platform.png"
                                                }

                                                Text{
                                                    text: sysInfo.distro
                                                    font.pixelSize: 18
                                                    color: colors.surfaceText
                                                    font.weight: 800
                                                }
                                            }
                                        }
                                
                                    Item{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height / 5

                                        Row{
                                            anchors.fill: parent
                                            spacing: 10
                                        
                                            Image{
                                                width: 25
                                                height: 25
                                                sourceSize: Qt.size(width, height)
                                                source: "./assets/clock.svg"
                                            }
                                        
                                            Text{
                                                anchors.leftMargin: 10
                                                text: sysInfo.uptime
                                                font.pixelSize: 18
                                                color: colors.surfaceText
                                                font.weight: 800
                                            }
                                        }
                                    }
                                
                                Item{
                                    implicitWidth: parent.width
                                    implicitHeight: parent.height / 5

                                    Row{
                                        anchors.fill: parent
                                        spacing: 10

                                        Image{
                                            width: 25
                                            height: 25
                                            sourceSize: Qt.size(width, height)
                                            source: "./assets/network.svg"
                                        }
                                        
                                        Text{
                                            text: sysInfo.localIp
                                            font.pixelSize: 18
                                            color: colors.surfaceText
                                            font.weight: 800
                                        }
                                    }
                                }
                                
                                Item{
                                    implicitWidth: parent.width
                                    implicitHeight: parent.height / 5
                                    
                                    Row{
                                        anchors.fill: parent
                                        spacing: 10

                                        Image{
                                            width: 25
                                            height: 25
                                            sourceSize: Qt.size(width, height)
                                            source: "./assets/cpu.svg"
                                        }

                                        Text{
                                            text: sysInfo.cpu
                                            font.pixelSize: 18
                                            color: colors.surfaceText
                                            font.weight: 800
                                        }
                                    }
                                }

                                Item{
                                    implicitWidth: parent.width
                                    implicitHeight: parent.height / 5
                                    
                                    Row{
                                        anchors.fill: parent
                                        spacing: 10
                                        
                                        Image{
                                            width: 25
                                            height: 25
                                            sourceSize: Qt.size(width, height)
                                            source: "./assets/setting.svg"
                                        }
                                        
                                        Text{
                                            anchors.leftMargin: 10
                                            text: sysInfo.kernel
                                            font.pixelSize: 18
                                            color: colors.surfaceText
                                            font.weight: 800
                                        }
                                    }
                                }
                            }
                        }
                     }
                }

                    Item{
                        id: userStat
                        implicitHeight: parent.height
                        implicitWidth: parent.width / 3

                        Rectangle{
                            implicitHeight: parent.height - 10
                            implicitWidth: parent.width - 10
                            anchors.centerIn: parent
                            color: colors.surfaceVariant
                            radius: 10

                            Row{
                                anchors.fill: parent
                                spacing: 40

                                CustomSlider{
                                    id: volumeslider
                                    icon: "music.svg"
                                    sliderType: "volume"
                                }

                                CustomSlider{
                                    id: brightnessslider
                                    icon: "sun.svg"
                                    sliderType: "brightness" 
                                }            
                            }
                        }
                    }
                }
            }
            
            Item{ 
                id: calendar
                width: parent.width
                height: parent.height - parent.height / 3
                
                Calendar {
                    anchors.fill: parent
                    anchors.margins: 5
                }
            }
        }
        
        Item{
            id: stats
            width: parent.width / 3
            height: parent.height

            Item{
                implicitHeight: parent.height
                implicitWidth: parent.width

                Rectangle{
                    implicitHeight: parent.height - 10
                    implicitWidth: parent.width - 10
                    anchors.centerIn: parent
                    color: colors.surfaceVariant
                    radius: 10

                    Column{
                        anchors.fill: parent
                        anchors.topMargin: 10 
                        spacing: 10

                        Rectangle{
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitHeight: parent.height / 4 - 10
                            implicitWidth: parent.width
                            color: "transparent"
                            radius: parent.width
                            
                            CircularProgressIndicator{
                                anchors.left: parent.left
                                width: parent.width
                                height: parent.height
                                progress: systemMonitor.cpuUsage / 100
                                iconSource: "./assets/cpu.svg"
                            }
                        }
                        
                        Rectangle{
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitHeight: parent.height / 4 - 10
                            implicitWidth: parent.width
                            color: "transparent"
                            
                            CircularProgressIndicator{
                                anchors.centerIn: parent
                                width: parent.width
                                height: parent.height
                                progress: systemMonitor.ramUsage / 100
                                iconSource: "./assets/ram.svg"
                                fgColor: "#9ccfd8"
                            }
                        }
                        
                        Rectangle{
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitHeight: parent.height / 4 - 10
                            implicitWidth: parent.width
                            color: "transparent"
                            radius: parent.width
                            
                            CircularProgressIndicator{
                                anchors.centerIn: parent
                                width: parent.width 
                                height: parent.height
                                progress: systemMonitor.diskUsage / 100
                                iconSource: "./assets/disk.svg"
                                fgColor: "#fab387"
                            }
                        }
                        
                        Rectangle{
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitHeight: parent.height / 4 - 10
                            implicitWidth: parent.width
                            color:"transparent"
                            radius: parent.width
                            
                            CircularProgressIndicator{
                                width: parent.width
                                height: parent.height
                                progress: systemMonitor.cpuTemp / 100
                                iconSource: "./assets/temp.svg"
                                isTemperature: true
                                fgColor: "#a6e3a1"
                            }
                        }
                    }
                }
            }
        }
    }
}
