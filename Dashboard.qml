import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import qs.util

Item{
    id: dashboardItem
    property bool isDashboardVisible: false
    property alias aliasTimer: timer
    
    Colors{
        id: colors
    }

    SystemMonitor{
        id: systemMonitor
    }

    Timer{
        id: timer
        interval: 200
        onTriggered:{
            open()
        }
    }
    
    PopupWindow{
        id: dashboardPanel
        anchor.window: topBar
        implicitWidth: middleRectWrapper.width - 20
        implicitHeight: 600
        color: "transparent"
        visible: isDashboardVisible

        anchor{
            rect.x: middleItem.x + middleRectWrapper.width / 2
            rect.y: middleRectWrapper.height - 20
            gravity: Edges.Bottom
        }

        Item{
            id: dashboardWrapper
            anchors.fill: parent

            transform: Scale{
                id: scaleTransform
                origin.x: dashboardWrapper.width / 2
                origin.y: 0
                yScale: 0
            } 

            Rectangle{
                implicitHeight: parent.height
                implicitWidth: parent.width

                bottomLeftRadius: 20
                bottomRightRadius: 20
                color: colors.surfaceContainer

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
                                    implicitWidth: parent.width / 2

                                    Rectangle{
                                        implicitHeight: parent.height - 10
                                        implicitWidth: parent.width - 10
                                        anchors.centerIn: parent
                                        color: colors.surfaceVariant
                                        radius: 10

                                        Column{
                                            id: user
                                            anchors.fill: parent

                                            Item{
                                                width: parent.width
                                                height: parent.height / 2
                                                Rectangle{
                                                    anchors.centerIn: parent
                                                    implicitWidth: parent.height - 10
                                                    implicitHeight: parent.height - 10
                                                    radius: 10
                                                    color: "#94E2D5"
                                                    Image{
                                                        source: "./assets/dinosaur.png"
                                                        anchors.centerIn: parent
                                                        fillMode: Image.PreserveAspectFit
                                                        width: parent.width - 10
                                                        height: parent.height - 10
                                                        sourceSize: Qt.size(width, height)

                                                    }
                                                }
                                            }
                                            Item{
                                                width: parent.width
                                                height: parent.height / 2
                                                Text{
                                                    anchors.centerIn: parent
                                                    text: "Steel"
                                                    font.pixelSize: 32
                                                    color: colors.surfaceText
                                                }                                                
                                            }
                                        }
                                    }
                                }

                                Item{
                                    id: userStat
                                    implicitHeight: parent.height
                                    implicitWidth: parent.width / 2

                                    Rectangle{
                                        implicitHeight: parent.height - 10
                                        implicitWidth: parent.width - 10
                                        anchors.centerIn: parent
                                        color: colors.surfaceVariant
                                        radius: 10
                                    }
                                }

                            }
                        }
                        Item{
                            id: calendar
                            width: parent.width
                            height: parent.height - parent.height / 3
                            Row{
                                anchors.fill: parent
                                Item{
                                    implicitWidth: parent.width
                                    implicitHeight: parent.height
                                    
                                    Rectangle{
                                        implicitHeight: parent.height - 10
                                        implicitWidth: parent.width - 10
                                        anchors.centerIn: parent
                                        color: colors.surfaceVariant
                                        radius: 10
                                    }
                                }

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

                                    CircularProgressIndicator{
                                        width: parent.width
                                        height: parent.height / 4
                                        progress: systemMonitor.cpuUsage / 100
                                        iconSource: "./assets/cpu.svg"
                                    }
                                    CircularProgressIndicator{
                                        width: parent.width
                                        height: parent.height / 4
                                        progress: systemMonitor.ramUsage / 100
                                        iconSource: "./assets/ram.svg"
                                        fgColor: colors.secondary
                                    }
                                    CircularProgressIndicator{
                                        width: parent.width
                                        height: parent.height / 4
                                        progress: systemMonitor.diskUsage / 100
                                        iconSource: "./assets/disk.svg"
                                        fgColor: colors.tertiary
                                    }
                                    CircularProgressIndicator{
                                        width: parent.width
                                        height: parent.height / 4
                                        progress: systemMonitor.cpuTemp / 100
                                        iconSource: "./assets/temp.svg"
                                        isTemperature: true
                                        fgColor: colors.primaryContainer
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        ParallelAnimation{
            id: openAnimation

            NumberAnimation{
                target: dashboardWrapper
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.2
            }

            NumberAnimation{
                target: scaleTransform
                property: "yScale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.1
            }
        }

        ParallelAnimation{
            id: closeAnimation

            NumberAnimation{
                target: dashboardWrapper
                property: "y"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }
            NumberAnimation{
                target: scaleTransform
                property: "yScale"
                to: 0
                duration: 200
                easing.type: Easing.InCubic
            }

            onFinished:{
                isDashboardVisible = false
                dashboardWrapper.y = 0
                scaleTransform.yScale = 0
            }
        }
    }
    function open(){
        isDashboardVisible = true
        openAnimation.start()
    }
    function close(){
        closeAnimation.start()
    }
}
