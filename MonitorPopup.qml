import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import QtQuick.Shapes

Item{
    id: monitorPopupItem

    property bool isMonitorVisible: false
    property var timer: monitorPopupTimer

    SystemMonitor{
        id: systemMonitor
    }
    
    Timer{
        id: monitorPopupTimer
        interval: 600

        onTriggered:{
            isMonitorVisible = false
        }
    }

    PopupWindow{
        id: monitorPopupWrapper
        anchor.window: topBar
        //implicitWidth: 200
        //implicitHeight: 150
        implicitHeight: monitorPopupRectAnimation.height
        implicitWidth: monitorPopupRectAnimation.width
        color: "transparent"
        visible: isMonitorVisible

        anchor{
            rect.x: utilityRectItem.x-utilityRect.width + 220
            rect.y: utilityRect.height + 5

            gravity: Edges.Bottom
        }

        Rectangle{
            id: monitorPopupRectAnimation
            color: "transparent"
            //color: "red"
            implicitWidth: column.width + column.spacing / 2 + 20
            implicitHeight: column.height + column.spacing / 2 + 20
            anchors{
                centerIn: parent 
            }

            Rectangle{
                id: monitorPopupRect
                color: "#11111B"

                implicitHeight: parent.height
                implicitWidth: parent.width

                anchors{
                    centerIn: parent
                }
                radius: 10


                Column{
                    id: column
                    width: firstRow.width + firstRow.spacing / 2
                    height: firstRow.height + secondRow.height + firstRow.spacing / 2 + secondRow.spacing / 2
                    spacing: 10
                    anchors.centerIn: parent

                    Row{
                        id: firstRow
                        width: ramUsage.width + cpuUsage.width + 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10 

                        Rectangle{
                            id: ramUsage
                            implicitHeight: 30 
                            implicitWidth: 135
                            color: "#1E1E2E"
                            radius: 10
                            Row{
                                spacing: 10
                                anchors{
                                    centerIn: parent
                                }

                                Image{
                                    id: ramIcon
                                    source: "./assets/ram.svg"
                                    width: 20
                                    height: 20
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
                                    text: Math.floor(systemMonitor.ramUsage) + "%"
                                    color: "#CDD6F4"
                                    font.pixelSize: 14
                                }

                                Rectangle{
                                    id: ramBar
                                    implicitWidth: 50
                                    implicitHeight: 8
                                    radius: 5
                                    color: "#6c7086"
                                    clip: true
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle{
                                        implicitHeight: parent.height
                                        implicitWidth: Math.floor(systemMonitor.ramUsage * parent.width / 100) + 5
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
                            implicitHeight: 30 
                            implicitWidth: 135
                            color: "#1E1E2E"
                            radius: 10
                            Row{
                                spacing: 10
                                anchors{
                                    centerIn: parent
                                }

                                Image{
                                    id: cpuIcon
                                    source: "./assets/cpu.svg"
                                    width: 20
                                    height: 20
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
                                    text: Math.floor(systemMonitor.cpuUsage) + "%"
                                    color: "#CDD6F4"
                                    font.pixelSize: 14
                                }

                                Rectangle{
                                    id: cpuBar
                                    implicitWidth: 50
                                    implicitHeight: 8
                                    radius: 5
                                    color: "#6c7086"
                                    clip: true
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle{
                                        implicitHeight: parent.height
                                        implicitWidth: Math.floor(systemMonitor.cpuUsage * parent.width / 100) + 5
                                        radius: 5
                                        color: "#eba0ac"
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
                    }

                    Row{
                        id: secondRow
                        width: diskUsage.width + tempUsage.width + 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        spacing: 10 

                        Rectangle{
                            id: diskUsage
                            implicitHeight: 30 
                            implicitWidth: 135
                            color: "#1E1E2E"
                            radius: 10
                            Row{
                                spacing: 10
                                anchors{
                                    centerIn: parent
                                }

                                Image{
                                    id: diskIcon
                                    source: "./assets/disk.svg"
                                    width: 20
                                    height: 20
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
                                    text: Math.floor(systemMonitor.diskUsage) + "%"
                                    color: "#CDD6F4"
                                    font.pixelSize: 14
                                }

                                Rectangle{
                                    id: diskBar
                                    implicitWidth: 50
                                    implicitHeight: 8
                                    radius: 5
                                    color: "#6c7086"
                                    clip: true
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle{
                                        implicitHeight: parent.height
                                        implicitWidth: Math.floor(systemMonitor.diskUsage * parent.width / 100) + 5
                                        radius: 5
                                        color: "#fab387"
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
                            id: tempUsage
                            implicitHeight: 30 
                            implicitWidth: 135
                            color: "#1E1E2E"
                            radius: 10
                            Row{
                                spacing: 10
                                anchors{
                                    centerIn: parent
                                }

                                Image{
                                    id: tmepIcon
                                    source: "./assets/temp.svg"
                                    width: 20
                                    height: 20
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
                                    text: Math.floor(systemMonitor.cpuTemp) + "°C"
                                    color: "#CDD6F4"
                                    font.pixelSize: 14
                                }

                                Rectangle{
                                    id: tempBar
                                    implicitWidth: 50
                                    implicitHeight: 8
                                    radius: 5
                                    color: "#6c7086"
                                    clip: true
                                    anchors{
                                        verticalCenter: parent.verticalCenter
                                    }

                                    Rectangle{
                                        implicitHeight: parent.height
                                        implicitWidth: Math.floor(systemMonitor.cpuTemp * parent.width / 100) + 5
                                        radius: 5
                                        color: "#f5c2e7"
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
                    }
                }
            }
        }
    }
}
