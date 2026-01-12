import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.settings
import qs.modules.services

PopupWindow{
    id: root
    implicitWidth: 240
    implicitHeight: 180 //child.implicitHeight
    visible: true
    color: "transparent"
    signal close

    anchor{
        window: layout
        rect.x: utility.x
        rect.y: utility.y + utility.height + 2
    }

    HyprlandFocusGrab{
        id: focusGrab
        active: true
        windows: [QsWindow.window]
        onCleared: root.close()
    }

    Rectangle{
        id: child
        implicitWidth: parent.width
        implicitHeight: parent.height//col.implicitHeight + 20
        scale: 0.8
        opacity: 0

        NumberAnimation on opacity{
            from: 0
            to: 1
            duration: 100
            running: true
        }

        NumberAnimation on scale{
            from: 0.8
            to: 1
            duration: 100
            running: true
        }

        color: Settings.layoutColor
        radius: 20

        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 20

            RowLayout{
                Layout.fillWidth: true
                Layout.rightMargin: 20

                ColumnLayout{
                    spacing: 2
                    CustomText{
                        content: ServiceWeather.temperature
                        size: 24
                    }
                    CustomText{
                        content: ServiceWeather.description
                        size: 16
                        color: Colors.outline
                    }

                    CustomText{
                        content: "Feels like " + ServiceWeather.feelsLike
                        size: 14
                        color: Colors.outline
                    }

                }
                Item{
                    Layout.fillWidth: true
                }
                CustomIconImage{
                    icon: ServiceWeather.weatherIconPath
                    size: 50
                    bright: 1
                } 
            }

            Item{
                Layout.fillHeight: true
            }
            

            RowLayout{
                Layout.fillWidth: true
                spacing: 0

                ColumnLayout{
                    Layout.fillWidth: true
                    CustomText{
                        content: "Humidity"
                        size: 12
                        color: Colors.outline
                        weight: 600
                    }

                    CustomText{
                        Layout.alignment: Qt.AlignCenter
                        content: ServiceWeather.humidity
                        size: 14
                    }
                }

                Item{
                    Layout.fillWidth: true
                }

                ColumnLayout{
                    Layout.fillWidth: true
                    CustomText{
                        content: "Cloud Cover"
                        size: 12
                        color: Colors.outline
                        weight: 600
                    }

                    CustomText{
                        Layout.alignment: Qt.AlignCenter
                        content: ServiceWeather.cloudcover
                        size: 14
                    }
                }

                Item{
                    Layout.fillWidth: true
                }


                ColumnLayout{
                    Layout.fillWidth: true
                    CustomText{
                        Layout.alignment: Qt.AlignCenter
                        content: "Wind"
                        size: 12
                        color: Colors.outline
                        weight: 600
                    }

                    CustomText{
                        Layout.alignment: Qt.AlignCenter
                        content: ServiceWeather.windSpeed
                        size: 14
                    }
                }
            }

            



            // CustomText{
            //     Layout.alignment: Qt.AlignCenter
            //     content: ServiceWeather.location
            //     size: 20
            // }
        }
    }
}

