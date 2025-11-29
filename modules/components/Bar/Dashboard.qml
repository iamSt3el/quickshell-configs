import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services
import QtQuick.Effects

Item{
    anchors.fill: parent
    Column{
        anchors.fill: parent
        Item{
            width: parent.width
            height: 40
        }
        Rectangle{
            anchors.horizontalCenter: parent.horizontalCenter
            implicitWidth: parent.width - 20
            implicitHeight: 200 
            radius: 30
            color: Colors.surfaceContainer

            Row{
                anchors.fill: parent

                Item{
                    width: parent.width * 0.6
                    height: parent.height

                    Column{
                        anchors.fill: parent

                        Item{
                            width: parent.width
                            height: parent.height / 3

                            Rectangle{
                                id: wifi
                                implicitWidth: parent.width - 20
                                implicitHeight: parent.height - 10
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                anchors.horizontalCenter: parent.horizontalCenter 
                                radius: 20
                                color: Colors.surfaceContainerHighest
                                
                                Row{
                                    width: parent.width - 10
                                    height: parent.height - 10
                                    anchors.centerIn: parent

                                    Rectangle{
                                        implicitWidth: parent.width * 0.4
                                        implicitHeight: parent.height
                                        radius: 15
                                        color: Colors.tertiary

                                        IconImage {
                                            anchors.centerIn: parent
                                            implicitSize: 28
                                            source: IconUtil.getSystemIcon("wifi")
                                            layer.enabled: true
                                            layer.effect: MultiEffect {
                                                colorization: 1.0
                                                colorizationColor: Colors.tertiaryText
                                                Behavior on colorizationColor{
                                                    ColorAnimation{
                                                        duration: 200
                                                    }
                                                }
                                                brightness: 0
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Item{
                            width: parent.width
                            height: parent.height / 3
                            Rectangle{
                                implicitWidth: parent.width - 20
                                implicitHeight: parent.height - 10
                                anchors.top: parent.top
                                anchors.topMargin: 10
                                anchors.horizontalCenter: parent.horizontalCenter 
                                radius: 20
                                color: Colors.surfaceContainerHighest

                                Row{
                                    width: parent.width - 10
                                    height: parent.height - 10
                                    anchors.centerIn: parent

                                    Rectangle{
                                        implicitWidth: parent.width * 0.4
                                        implicitHeight: parent.height
                                        radius: 15
                                        color: Colors.tertiary

                                        IconImage {
                                            anchors.centerIn: parent
                                            implicitSize: 28
                                            source: IconUtil.getSystemIcon("bluetooth")
                                            layer.enabled: true
                                            layer.effect: MultiEffect {
                                                colorization: 1.0
                                                colorizationColor: Colors.tertiaryText
                                                Behavior on colorizationColor{
                                                    ColorAnimation{
                                                        duration: 200
                                                    }
                                                }
                                                brightness: 0
                                            }
                                        }
                                    }
                                }


                            }
                        }
                        Item{
                            width: parent.width
                            height: parent.height / 3
                            Rectangle{
                                id: powerProfile
                                implicitWidth: parent.width - 20
                                implicitHeight: parent.height - 20
                                anchors.centerIn: parent
                                radius: 20
                                color: Colors.surfaceContainerHighest

                                Row{
                                    width: parent.width - 5
                                    height: parent.height - 5
                                    anchors.centerIn: parent

                                    Repeater{
                                        model: ServiceUPower.powerProfiles

                                        delegate: Item{
                                            height: parent.height
                                            width: parent.width / 3

                                            Rectangle{
                                                implicitWidth: parent.width - 5
                                                implicitHeight: parent.height - 5
                                                anchors.centerIn: parent
                                                radius: 15
                                                color: ServiceUPower.powerProfile === index ?Colors.tertiary : "transparent"

                                                Behavior on color{
                                                    ColorAnimation{
                                                        duration: 200
                                                    }
                                                }


                                                IconImage {
                                                    anchors.centerIn: parent
                                                    implicitSize: 20
                                                    source: IconUtil.getSystemIcon(modelData.icon)
                                                    layer.enabled: true
                                                    layer.effect: MultiEffect {
                                                        colorization: 1.0
                                                        colorizationColor: ServiceUPower.powerProfile === index ? Colors.tertiaryText : Colors.surfaceText
                                                        Behavior on colorizationColor{
                                                            ColorAnimation{
                                                                duration: 200
                                                            }
                                                        }
                                                        brightness: 0
                                                    }
                                                }

                                                MouseArea{
                                                    id: iconArea
                                                    anchors.fill: parent
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked:{
                                                        ServiceUPower.setPowerProfile(index)
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
                Item{
                    width: parent.width * 0.4
                    height: parent.height

                    Row{
                        anchors.fill: parent
                        Item{
                            width: parent.width * 0.5
                            height: parent.height

                            CustomSlider{
                                id: volumeSlider
                                progress: 0.8
                                icon: "volume"
                            }
                        }
                        Item{
                            width: parent.width * 0.5
                            height: parent.height

                            CustomSlider{
                                id: brightnessSlider
                                progress: 0.5
                                icon: "brightness"
                            }
                        }
                    }

                }
            }

        }
    }
}
