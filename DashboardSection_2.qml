import Quickshell
import QtQuick
import qs.util
import Quickshell.Services.Mpris
import Quickshell.Widgets

Item{

    Colors{
        id: colors
    }

    Rectangle{
        implicitWidth: parent.width - 10
        implicitHeight: parent.height - 10
        anchors.centerIn: parent
        radius: 10
        color: colors.surfaceVariant
        
        Row{
            anchors.fill: parent
            Repeater{
                model: Mpris.players

                delegate: Item{
                    width: parent.width
                    height: parent.height

                    readonly property var activePlayer:{
                        if(modelData.playbackState === MprisPlaybackState.Playing){
                            return modelData
                        }
                    }

                    Timer{
                        id: positionTimer
                        running: activePlayer && activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing
                        interval: 1000
                        repeat: true
                        triggeredOnStart: true
                        onTriggered:{
                            if(activePlayer){
                                activePlayer.positionChanged()
                            }
                        }
                    }

                        function formatTimer(seconds){
                            if(!seconds || seconds <= 0) return "0:00"
                            const mins = Math.floor(seconds / 60)
                            const secs = Math.floor(seconds % 60)
                            return mins + ":" + (secs < 10 ? "0" : "") + secs
                        }

                        Row{
                            anchors.fill: parent
                            Item{
                                width: parent.width / 3
                                height: parent.height
                                
                                ClippingRectangle{
                                    implicitHeight: 200
                                    implicitWidth: 200
                                    radius: 40
                                    color: "transparent"
                                    anchors.centerIn: parent
                                    clip: true
                                    Image{
                                        anchors.fill: parent
                                        fillMode: Image.PreserveAspectCrop
                                        source: modelData.trackArtUrl || ""
                                        sourceSize: Qt.size(width, height)
                                    }
                                }
                            }

                            Item{
                                implicitWidth: parent.width - parent.width / 3
                                implicitHeight: parent.height

                                Column{
                                    anchors.fill: parent

                                    Item{
                                        implicitHeight: parent.height / 5
                                        implicitWidth: parent.width
                                        clip: true
                                        Text{
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: activePlayer.trackTitle || "No Title"
                                            font.pixelSize: 36
                                            color: colors.primaryText
                                            font.family: nothingFonts.name
                                            font.weight: 800
                                        }
                                    }

                                    Item{
                                        implicitHeight: parent.height / 5
                                        implicitWidth: parent.width
                                        clip: true

                                        Text{
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: activePlayer.trackArtist || "No Artist"
                                            font.pixelSize: 26
                                            color: colors.secondaryText
                                            font.family: nothingFonts.name
                                            font.weight: 800
                                        }
                                    }

                                    Item{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height / 5

                                        Text{
                                            anchors.left: parent.left
                                            anchors.verticalCenter: parent.verticalCenter
                                            text: formatTimer(activePlayer.position)
                                            font.pixelSize: 24
                                            font.family: nothingFonts.name
                                        }

                                        Text{
                                            anchors.right: parent.right
                                            anchors.verticalCenter: parent.verticalCenter
                                            anchors.rightMargin: 10
                                            text: formatTimer(activePlayer.length)
                                            font.pixelSize: 24
                                            font.family: nothingFonts.name
                                        }
                                    }

                                        Item{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height / 5

                                        Rectangle{
                                            anchors.left: parent.left
                                            implicitWidth: parent.width - 10
                                            implicitHeight: 10
                                            radius: 5
                                            color: colors.tertiary

                                            Rectangle{
                                                anchors.left: parent.left
                                                implicitWidth: Math.max(parent.width * (activePlayer.position / activePlayer.length), 0)
                                                implicitHeight: parent.height
                                                radius: 5
                                                color: colors.surface

                                                Behavior on implicitWidth{
                                                    NumberAnimation{
                                                        duration: 100;
                                                        easing.type: Easing.OutQuad
                                                    }
                                                }
                                            }
                                        }
                                    }
                                     // Control Buttons
                                        Item{
                                            implicitHeight: parent.height / 5
                                            implicitWidth: parent.width

                                            Row{
                                                width: parent.width
                                                height: 70

                                                anchors.centerIn: parent

                                                Rectangle{
                                                    implicitWidth: parent.width / 3
                                                    implicitHeight: parent.height
                                                    color: "transparent"
                                                    
                                                    Image{
                                                        anchors.centerIn: parent
                                                        source: "./assets/back.svg"
                                                        width: 40
                                                        height: 40
                                                        sourceSize: Qt.size(width, height)
                                                    }
                                                    MouseArea{
                                                        id: backArea
                                                        implicitWidth: 40
                                                        implicitHeight: 40
                                                        anchors.centerIn: parent
                                                        cursorShape: Qt.PointingHandCursor

                                                        onClicked:{
                                                            modelData.previous()
                                                        }
                                                    }
                                                }

                                                  Rectangle{
                                                    implicitWidth: parent.width / 3
                                                    implicitHeight: parent.height
                                                    color: "transparent"
                                                    
                                                    Image{
                                                        anchors.centerIn: parent
                                                        source: modelData.isPlaying ? "./assets/pause.svg" : "./assets/play.svg"
                                                        width: 50
                                                        height: 50
                                                        sourceSize: Qt.size(width, height)
                                                    }

                                                    MouseArea{
                                                        id: playPauseArea
                                                        implicitWidth: 50
                                                        implicitHeight: 50
                                                        anchors.centerIn: parent
                                                        cursorShape: Qt.PointingHandCursor

                                                        onClicked:{
                                                            modelData.togglePlaying()
                                                        }
                                                    }
                                                }

                                                  Rectangle{
                                                    implicitWidth: parent.width / 3
                                                    implicitHeight: parent.height
                                                    color: "transparent"
                                                    
                                                    Image{
                                                        anchors.centerIn: parent
                                                        source: "./assets/next.svg"
                                                        width: 40
                                                        height: 40
                                                        sourceSize: Qt.size(width, height)
                                                    } 
                                                    MouseArea{
                                                        id: nextArea
                                                        implicitWidth: 40
                                                        implicitHeight: 40
                                                        anchors.centerIn: parent
                                                        cursorShape: Qt.PointingHandCursor

                                                        onClicked:{
                                                            modelData.next()
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

}
