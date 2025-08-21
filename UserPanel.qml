import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import Quickshell.Services.Mpris

Item{
    id: userPanelItem
    property bool userPanelVisible: false

    PopupWindow{
        id: userPanelWrapper
        anchor.window: topBar
        implicitHeight: 360
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
                implicitHeight: parent.height / 2 - 30

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
                implicitHeight: parent.height / 2
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
                                        implicitHeight: parent.height / 3 + 20
                                        implicitWidth: parent.width
                                        color: "transparent"

                                    // Use the currently active player data instead of modelData
                                    readonly property var activePlayer: {
                                        // Check if this is the active/currently playing player
                                        if (modelData.playbackState === MprisPlaybackState.Playing) {
                                            return modelData;
                                        }
                                        // If no player is playing, use this player
                                        let hasPlayingPlayer = false;
                                        for (let i = 0; i < Mpris.players.length; i++) {
                                            if (Mpris.players[i].playbackState === MprisPlaybackState.Playing) {
                                                hasPlayingPlayer = true;
                                                break;
                                            }
                                        }
                                        return hasPlayingPlayer ? null : modelData;
                                    }
                                    
                                    // Timer to update position every second - only for active player
                                    Timer {
                                        id: positionTimer
                                        running: activePlayer && activePlayer.playbackState === MprisPlaybackState.Playing
                                        interval: 1000
                                        repeat: true
                                        triggeredOnStart: true
                                        onTriggered: {
                                            if (activePlayer) {
                                                activePlayer.positionChanged()
                                            }
                                        }
                                    }

                                    // Function to format time
                                    function formatTime(seconds) {
                                        if (!seconds || seconds <= 0) return "0:00"
                                        const mins = Math.floor(seconds / 60)
                                        const secs = Math.floor(seconds % 60)
                                        return mins + ":" + (secs < 10 ? "0" : "") + secs
                                    }

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
                                                    source: modelData.trackArtUrl || ""
                                                    fillMode: Image.PreserveAspectFit
                                                    
                                                    // Fallback if no image
                                                    Rectangle {
                                                        anchors.fill: parent
                                                        color: "#333"
                                                        radius: 5
                                                        visible: parent.status !== Image.Ready
                                                        
                                                        Text {
                                                            anchors.centerIn: parent
                                                            text: "♪"
                                                            color: "#CBA6F7"
                                                            font.pixelSize: 24
                                                        }
                                                    }
                                                }
                                            }

                                            Rectangle{
                                                implicitWidth: parent.width / 2 + 50
                                                implicitHeight: parent.height
                                                color: "transparent"

                                                Column{
                                                    anchors.fill: parent

                                                    Rectangle{
                                                        implicitHeight: parent.height / 3
                                                        implicitWidth: parent.width
                                                        color: "transparent"
                                                        Text{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            text: modelData.trackTitle || "No Title"
                                                            color: "#CBA6F7"
                                                            font.pixelSize: 16
                                                            elide: Text.ElideRight
                                                            width: parent.width - 10
                                                        }
                                                    }

                                                    Rectangle{
                                                        implicitWidth: parent.width
                                                        implicitHeight: parent.height / 3
                                                        color: "transparent"
                                                        Text{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            text: modelData.trackArtist || "Unknown Artist"
                                                            color: "#CBA6F7"
                                                            font.pixelSize: 12
                                                            elide: Text.ElideRight
                                                            width: parent.width - 10
                                                        }
                                                    }

                                                    // Time display
                                                    Rectangle{
                                                        implicitWidth: parent.width
                                                        implicitHeight: parent.height / 3
                                                        color: "transparent"
                                                        Text{
                                                            anchors.verticalCenter: parent.verticalCenter
                                                            text: {
                                                                let playerData = activePlayer || modelData;
                                                                return formatTime(playerData.position) + " / " + formatTime(playerData.length);
                                                            }
                                                            color: "#94E2D5"
                                                            font.pixelSize: 10
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        // Progress Bar
                                        Rectangle{
                                            implicitHeight: 30
                                            implicitWidth: parent.width
                                            color: "transparent"

                                            Rectangle{
                                                implicitWidth: parent.width - 20
                                                implicitHeight: 8
                                                radius: 4
                                                color: "#45475A"
                                                anchors{
                                                    centerIn: parent
                                                }

                                                Rectangle{
                                                    id: progressBar
                                                    implicitHeight: parent.height
                                                    implicitWidth: {
                                                        // Use activePlayer data for more reliable updates
                                                        let playerData = activePlayer || modelData;
                                                        let length = playerData.length || 1;
                                                        let position = playerData.position || 0;
                                                        let progress = length > 0 ? Math.min(position / length, 1.0) : 0;
                                                        //console.log("Player:", playerData.trackTitle, "Position:", position, "Length:", length, "Progress:", progress);
                                                        return Math.max(parent.width * progress, 0);
                                                    }
                                                    radius: 4
                                                    color: "#89DCEB"
                                                    
                                                    Behavior on implicitWidth {
                                                        NumberAnimation { duration: 200 }
                                                    }
                                                }

                                                // Make progress bar clickable for seeking
                                                MouseArea {
                                                    anchors.fill: parent
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: function(mouse) {
                                                        if (modelData.canSeek && modelData.positionSupported) {
                                                            let clickProgress = mouse.x / width
                                                            let newPosition = clickProgress * modelData.length
                                                            modelData.position = newPosition
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        // Control Buttons
                                        Rectangle{
                                            implicitHeight: parent.height
                                            implicitWidth: parent.width
                                            color: "transparent"

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
}
