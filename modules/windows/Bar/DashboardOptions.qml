import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import qs.modules.services
import Quickshell.Widgets
import QtQuick.Layouts


Item{
    id: root
    implicitWidth: parent.width / 2
    implicitHeight: parent.height - 10


    function formatTime(seconds) {
        if (!seconds || seconds <= 0) return "0:00"
        const mins = Math.floor(seconds / 60)
        const secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }

    Timer {
        running: ServiceMusic.activePlayer?.isPlaying ?? false
        interval: 1000
        repeat: true
        onTriggered: {
            if (ServiceMusic.activePlayer) {
                ServiceMusic.activePlayer.positionChanged()
            }
        }
    }

    // ServiceFilePicker handles updating ServiceUserSettings directly

    function openImagePicker() {
        ServiceFilePicker.pickImageFile("Choose User Image")
    }

    Column{
        anchors.fill: parent
        spacing: 10

        Item{
            implicitWidth: parent.width
            implicitHeight: 50

            StyledText{
                anchors.centerIn: parent
                content: ServiceClock.time
                size: 44
            }
        }

        Row{
            width: parent.width
            height: 120
            spacing: 10

            Rectangle{
                id: user
                implicitHeight: parent.height
                implicitWidth: parent.width / 2 - 10
                radius: 20
                color: Colors.surfaceVariant
                
                Column{
                    anchors.fill: parent

                    Item{
                        implicitWidth: parent.width
                        implicitHeight: parent.height * 0.8

                        ClippingRectangle{
                            id: imageContainer
                            anchors.centerIn: parent
                            width: Math.min(parent.width - 30, parent.height - 20)
                            height: width
                            radius: 20
                            color: Qt.alpha(Colors.surface, 0.5)
                            clip: true

                            Image{
                                id: userImage
                                anchors.fill: parent
                                source: ServiceUserSettings.settings.userImagePath ? Qt.resolvedUrl(ServiceUserSettings.settings.userImagePath) : ""
                                fillMode: Image.PreserveAspectCrop
                                visible: ServiceUserSettings.settings.userImagePath !== ""
                                sourceSize: Qt.size(height, width)
                                smooth: true
                            }

                            Image{
                                id: placeholderIcon
                                anchors.centerIn: parent
                                width: parent.width * 0.4
                                height: width
                                source: IconUtils.getSystemIcon("user")
                                visible: ServiceUserSettings.settings.userImagePath === ""
                                sourceSize: Qt.size(width, height)

                                layer.enabled: true
                                layer.effect: MultiEffect{
                                    brightness: 1
                                    colorization: 1.0
                                    colorizationColor: Colors.primary
                                }
                            }

                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    openImagePicker()
                                }
                            }

                            layer.enabled: true
                            layer.effect: MultiEffect{
                                shadowEnabled: true
                                shadowBlur: 0.2
                                shadowOpacity: 0.3
                                shadowColor: Qt.alpha(Colors.shadow, 0.5)
                                shadowHorizontalOffset: 0
                                shadowVerticalOffset: 2
                            }
                        }
                    }

                    Item{
                        implicitWidth: parent.width
                        implicitHeight: parent.height * 0.2

                        StyledText{
                            content: ServiceUserSettings.settings.userName
                            size: 22
                            anchors.centerIn: parent
                        }
                    }

                }

                layer.enabled: true
                layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }
            }
            Rectangle{
                id: weather
                implicitHeight: parent.height
                implicitWidth: parent.width / 2
                color: Colors.surfaceVariant
                radius: 20

                layer.enabled: true
                layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }

                Column{
                    anchors.fill: parent
                    anchors.margins: 5

                    Item{
                        width: parent.width
                        height: parent.height * 0.2

                        StyledText{
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            content: ServiceWeather.cityName
                            size: 18
                            color: Colors.surfaceText
                            opacity: 0.8
                            font.weight: 500
                        }
                    }

                    Item{
                        width: parent.width
                        height: parent.height * 0.4

                        StyledText{
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            content: ServiceWeather.temperature
                            size: 36
                            font.weight: 600
                        }
                    }

                    Item{
                        width: parent.width
                        height: parent.height * 0.4

                        Image{
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 66
                            height: 66
                            sourceSize: Qt.size(width, height)
                            source: ServiceWeather.weatherIconPath
                            layer.enabled: true
                            layer.effect: MultiEffect{
                                brightness: 1
                                colorization: 1.0
                                colorizationColor: Colors.primary
                            }
                        }
                    }
                }
            }
        }
   
            Rectangle{
                implicitWidth: parent.width
                implicitHeight: 100
                color: Colors.surfaceVariant
                radius: 20
            
                Column{
                    anchors.fill: parent
                    spacing: 15
                    anchors.margins: 15

                    SystemStatsBar{
                        progress: ServiceSystemInfo.cpuPerc
                        width: parent.width
                        height: parent.height * 0.2
                        color: Colors.primary
                        icon: IconUtils.getSystemIcon("cpu")
                    }

                    SystemStatsBar{
                        progress: ServiceSystemInfo.memPerc
                        width: parent.width
                        height: parent.height * 0.2
                        color: Colors.error
                        icon: IconUtils.getSystemIcon("ram")

                    }

                     SystemStatsBar{
                        progress: ServiceSystemInfo.storagePerc
                        width: parent.width
                        height: parent.height * 0.2
                        color: Colors.tertiary
                        icon: IconUtils.getSystemIcon("disk")

                    }

                }

                layer.enabled: true
                    layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }
            }


        Row{
            width: parent.width
            height: 110
            spacing: 10
            ClippingRectangle{
                implicitHeight: parent.height
                implicitWidth: parent.width - parent.width / 4 - 10
                radius: 20
                color: Colors.surfaceVariant
                clip: true

                Image{
                    id: albumArt
                    anchors.fill: parent
                    source: ServiceMusic.activeTrack?.artUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    visible: source != ""

                    layer.enabled: true
                    layer.effect: MultiEffect{
                        blurEnabled: true
                        blur: 0.4
                        blurMax: 64
                        brightness: -0.2
                        saturation: 0.8
                    }
                }


                Column{
                    anchors.fill: parent

                    ClippingRectangle{
                        anchors.horizontalCenter: parent.horizontalCenter
                        implicitWidth: parent.width - 20
                        implicitHeight: parent.height * 0.4
                        clip: true
                        color: "transparent"
                        radius: 20
                        StyledText{
                            anchors.verticalCenter: parent.verticalCenter
                            content: ServiceMusic.activeTrack.title || "unkown"
                            size: 22
                            color: Colors.secondary
                        }
                    }

                    ClippingRectangle{
                        anchors.horizontalCenter: parent.horizontalCenter
                        implicitWidth: parent.width - 20
                        implicitHeight: parent.height * 0.2
                        clip: true
                        color: "transparent"
                        radius: 20
                        StyledText{
                            anchors.verticalCenter: parent.verticalCenter
                            content: ServiceMusic.activeTrack.artist || unkown
                            size: 16
                        }
                    }

                    Item{
                        implicitHeight: parent.height * 0.4
                        implicitWidth: parent.width

                        Column{
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 5

                            Item{
                                width: parent.width
                                height: 15

                                StyledText{
                                    anchors.verticalCenter: parent.verticalCenter
                                    content: formatTime(ServiceMusic.activePlayer?.position ?? 0)
                                    size: 12
                                    color: Colors.surfaceText
                                }


                                StyledText{
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.right: parent.right
                                    content: formatTime(ServiceMusic.activePlayer?.length ?? 0)
                                    size: 12
                                    color: Colors.surfaceText
                                }
                            }

                            Rectangle{
                                width: parent.width
                                height: 6
                                radius: 3
                                color: Qt.alpha(Colors.primary, 0.2)

                                Rectangle{
                                    id: progressBar
                                    width: parent.width * (ServiceMusic.activePlayer?.position / Math.max(ServiceMusic.activePlayer?.length, 1) || 0)
                                    height: parent.height
                                    radius: parent.radius
                                    color: Colors.primary

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 300
                                            easing.type: Easing.OutCubic
                                        }
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: (mouse) => {
                                        if (ServiceMusic.activePlayer && ServiceMusic.activePlayer.canSeek) {
                                            const position = (mouse.x / width) * ServiceMusic.activePlayer.length
                                            ServiceMusic.activePlayer.position = position
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                layer.enabled: true
                layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }
            }
            Rectangle{
                implicitHeight: parent.height
                implicitWidth: parent.width / 4
                radius: 20
                color: Colors.surfaceVariant

                Column{
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8

                    Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 25
                        height: 25
                        sourceSize: Qt.size(width, height)
                        source: IconUtils.getSystemIcon("next")

                         layer.enabled: true
                            layer.effect: MultiEffect{
                                brightness: 1
                                colorization: 1.0
                                colorizationColor: Colors.primary
                        }
                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked:{
                                ServiceMusic.next()
                            }
                        }
                    }

                    Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 30
                        height: 30
                        sourceSize: Qt.size(width, height)
                        property string icon : ServiceMusic.isPlaying ? "pause" : "play"
                        source: IconUtils.getSystemIcon(icon)
                        layer.enabled: true
                        layer.effect: MultiEffect{
                            brightness: 1
                            colorization: 1.0
                            colorizationColor: Colors.primary
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked:{
                                ServiceMusic.togglePlaying()
                            }
                        }
                    }

                     Image{
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: 25
                        height: 25
                        sourceSize: Qt.size(width, height)
                        source: IconUtils.getSystemIcon("back")
                         layer.enabled: true
                            layer.effect: MultiEffect{
                                brightness: 1
                                colorization: 1.0
                                colorizationColor: Colors.primary
                        }
                         MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked:{
                                ServiceMusic.previous()
                            }
                        }
                    }
                }

                layer.enabled: true
                    layer.effect: MultiEffect{
                    shadowEnabled: true
                    shadowBlur: 0.4
                    shadowOpacity: 1.0
                    shadowColor: Qt.alpha(Colors.shadow, 1)
                    shadowHorizontalOffset: 0
                    shadowVerticalOffset: 0
                }
            }
        }
    }
}
