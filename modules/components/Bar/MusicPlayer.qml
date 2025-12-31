import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services

Rectangle{
    radius: 20
    color: Colors.surfaceContainer
    ColumnLayout{
        anchors.fill: parent
        spacing: 0
        Rectangle{
            color: Colors.surfaceContainerHigh
            radius: 20
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                ClippingWrapperRectangle{
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    radius: 10
                    color: Colors.surfaceContainerHighest
                    Image{
                        anchors.fill: parent
                        sourceSize: Qt.size(width, height)
                        source: ServiceMusic.activeTrack?.artUrl ?? ""
                    }
                }


                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    CustomText{
                        Layout.fillWidth: true
                        content: ServiceMusic.activeTrack?.title ?? "Unknown Title"
                        size: 14
                    }

                    CustomText{
                        Layout.fillWidth: true
                        content: ServiceMusic.activeTrack?.artist ?? "Unknown Artist"
                        color: Colors.outline
                        size: 12
                    }

                    Item{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.bottomMargin: 5

                        ColumnLayout{
                            anchors.fill: parent
                            RowLayout{
                                Layout.fillWidth: true
                                CustomText{
                                    Layout.fillWidth: true
                                    content: ServiceMusic.formatTime(ServiceMusic.activePlayer?.position ?? 0)
                                    size: 12
                                }

                                CustomText{
                                    content: ServiceMusic.formatTime(ServiceMusic.activePlayer?.length ?? 0)
                                    horizontalAlignment: Text.AlignHCenter
                                    size: 12
                                }
                            }

                            CustomProgressBar{
                                value: (ServiceMusic.activePlayer?.position / Math.max(ServiceMusic.activePlayer?.length, 1) || 0)
                                valueBarWidth: parent.width
                                sperm: true
                                animateSperm: ServiceMusic.isPlaying
                            }
                        }
                    }
                }

            }
        }
        Item{
            Layout.fillHeight: true
            Layout.fillWidth: true

            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5



                Rectangle{
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    radius: 20
                    color: loopArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
                    Behavior on color{
                        ColorAnimation{
                            duration: 200
                        }
                    }
                    Behavior on scale{
                        NumberAnimation{
                            duration: 100
                        }
                    }
                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: "loop"
                        size: 24
                        color: loopArea.containsMouse ? Colors.primaryText : Colors.surfaceText
                    }
         
                    
                    CustomMouseArea{
                        id: loopArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:{
                            ServiceMusic.togglePlaying()
                        }
                    }
                }

                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.fillHeight: true
                    radius: 20
                    color: sArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
                    Behavior on color{
                        ColorAnimation{
                            duration: 200
                        }
                    }
                    Behavior on scale{
                        NumberAnimation{
                            duration: 100
                        }
                    }
                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: "shuffle"
                        size: 24
                        color: sArea.containsMouse ? Colors.primaryText : Colors.surfaceText
                    }
      
                    CustomMouseArea{
                        id: sArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:{
                            ServiceMusic.togglePlaying()
                        }
                    }
                }


                Rectangle{
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    radius: 20
                    color: lArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
                    Behavior on color{
                        ColorAnimation{
                            duration: 200
                        }
                    }

                    Behavior on scale{
                        NumberAnimation{
                            duration: 100
                        }
                    }
                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: "last"
                        size: 24
                        color: lArea.containsMouse ? Colors.primaryText : Colors.surfaceText
                    }
                    CustomMouseArea{
                        id: lArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:{
                            ServiceMusic.previous()
                        }
                    }
                }
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.fillHeight: true
                    radius: 20
                    color: pArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
                    Behavior on scale{
                        NumberAnimation{
                            duration: 100
                        }
                    }
                    Behavior on color{
                        ColorAnimation{
                            duration: 200
                        }
                    }
                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: ServiceMusic.isPlaying ? "pause" : "play"
                        size: 24
                        color: pArea.containsMouse ? Colors.primaryText : Colors.surfaceText
                    }



                    CustomMouseArea{
                        id: pArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:{
                            ServiceMusic.togglePlaying()
                        }
                    }

                }
                Rectangle{
                    Layout.preferredWidth: 50
                    Layout.fillHeight: true
                    radius: 20
                    color: nArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
                    Behavior on color{
                        ColorAnimation{
                            duration: 200
                        }
                    } 
                    Behavior on scale{
                        NumberAnimation{
                            duration: 100
                        }
                    }

                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: "next"
                        size: 24
                        color: nArea.containsMouse ? Colors.primaryText : Colors.surfaceText


                    }


                    CustomMouseArea{
                        id: nArea
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked:{
                            ServiceMusic.next()
                        }
                    }

                }
            }
        }
    }
}
