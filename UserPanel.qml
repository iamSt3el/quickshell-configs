import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import Quickshell.Services.Mpris

Item{
    id: userPanelItem
    property bool userPanelVisible: true

    PopupWindow{
        id: userPanelWrapper
        anchor.window: topBar
        implicitHeight: 400
        implicitWidth: 300
        
        color: "transparent"

        visible: userPanelVisible

        anchor{
            rect.x: utilityRectItem.x
            rect.y: utilityRect.height + 5

            gravity: Edges.Bottom
        }

        Column{
            anchors.fill: parent
            spacing: 10

            Rectangle{
                id: firstPanel
                implicitWidth: parent.width
                implicitHeight: parent.height - 230 

                color: "#11111B"
                radius: 10

                Row{
                    anchors.fill: parent
                    Rectangle{
                        implicitWidth: firstPanel.width / 2
                        implicitHeight: firstPanel.height - 10

                        color: "transparent"
                        Column{
                            anchors.fill: parent
                                Rectangle{
                                    implicitHeight: parent.height / 2
                                    implicitWidth: parent.width

                                    color: "transparent"

                                Rectangle{
                                    implicitWidth: 60
                                    implicitHeight: 60
                                    color: "#94E2D5"
                                    radius: 20
                                    anchors{
                                        centerIn: parent
                                    }
                                    Image{
                                        anchors.centerIn: parent
                                        width: 40
                                        height: 40
                                        sourceSize: Qt.size(width, height)
                                        source: "./assets/user.svg"

                                        layer.enabled: true
                                        layer.effect: ColorOverlay{
                                            color: "black"
                                        }    
                                    }
                                }
                            }

                            Rectangle{
                                implicitHeight: parent.height / 2
                                implicitWidth: parent.width

                                color: "transparent"

                                Column{
                                    anchors.fill: parent

                                    Text{
                                        anchors{
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                        text: "STEEL"
                                        color: "#FFFFFF"
                                        font.pixelSize: 24
                                    }

                                    Text{
                                        anchors{
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                        text: "Uptime: 2h 30min"
                                        color: "#FFFFFF"
                                        font.pixelSize: 16
                                    }
                                }
                            }    
                        }
                    }
                    Rectangle{
                        id: secondHalf
                        implicitWidth: parent.width / 2
                        implicitHeight: parent.height

                        color: "transparent"
                        Row{
                            anchors.fill: parent
                            anchors.leftMargin: 40
                            CustomSlider{
                                id: brightnessslider
                                icon: "sun.svg"
                                sliderType: "brightness"
                            }
                            CustomSlider{
                                id: volumeSlider
                                icon: "music.svg"
                                sliderType: "volume"
                            }
                        }
                    }
                }
            }

            Rectangle{
                id: secondPanel
                implicitHeight: parent.height / 2 + 20
                implicitWidth: parent.width

                color: "#11111B"
                radius: 10
                    Rectangle{
                        implicitWidth: parent.width
                        implicitHeight: parent.height

                        color: "transparent"

                        Row{
                            anchors.fill: parent
                            spacing: 10
                            Repeater{
                                model: Mpris.players

                                delegate: Rectangle{
                                        implicitHeight: parent.height / 3
                                        implicitWidth: parent.width
                                        //clip: true
                                        //border.color: "#F9E2AF"
                                        color: "transparent"
                                    

                                    Column{
                                        anchors.fill: parent
                                        Row{
                                            width: parent.width
                                            height: parent.height
                                            Rectangle{
                                                implicitWidth: parent.width / 2 - 50
                                                implicitHeight: parent.height
                                                color: "transparent"
                                                Image{
                                                    anchors.centerIn: parent
                                                    width: 80
                                                    height: 60
                                                    source:modelData.trackArtUrl
                                                }
                                            }

                                            Rectangle{
                                                implicitWidth: parent.width / 2 + 50
                                                implicitHeight: parent.height
                                                color: "transparent"

                                                Column{
                                                    anchors.fill: parent

                                                    Rectangle{
                                                        implicitHeight: parent.height / 2
                                                        implicitWidth: parent.width
                                                        color: "transparent"
                                                        Text{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            text: modelData.trackTitle
                                                            color: "#CBA6F7"
                                                            font.pixelSize: 16
                                                        }
                                                    }

                                                    Rectangle{
                                                        implicitWidth: parent.width
                                                        implicitHeight: parent.height / 2
                                                        color: "transparent"
                                                        Text{
                                                            //anchors.verticalCenter: parent.verticalCenter
                                                            text: modelData.trackArtist || "Unknown Artist"
                                                            color: "#CBA6F7"
                                                            font.pixelSize: 12
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        Rectangle{
                                            implicitHeight: parent.height - 20
                                            implicitWidth: parent.width
                                            color: "transparent"

                                            Rectangle{
                                                implicitWidth: parent.width - 20
                                                implicitHeight: 10
                                                radius: 10
                                                color: "#D9D9D9"
                                                anchors{
                                                    centerIn: parent
                                                }

                                                Rectangle{
                                                    implicitHeight: parent.height
                                                    implicitWidth: {
                                                        console.log("Position: " + modelData.position / 360 )
                                                        return parent.width 
                                                    }
                                                    radius: 10
                                                    color: "#89DCEB"
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
}
