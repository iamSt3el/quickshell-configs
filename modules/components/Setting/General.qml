import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: root
    anchors.fill: parent
    anchors.margins: 5
    
    Flickable{
        id: flickable
        anchors.fill: parent  
        contentHeight: column.implicitHeight
        contentWidth: width   
        clip: true

        MouseArea{
            anchors.fill: parent
            onClicked:{
                list.isListClicked = false
                flickable.clip = true
            }
        }

        ColumnLayout{
            id: column
            width: parent.width
            spacing: 15
            RowLayout{
                Layout.margins: 5
                IconImage {
                    implicitSize: 26
                    Layout.alignment: Qt.AlignVCenter
                    source: IconUtil.getSystemIcon("general")
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Colors.primary
                        Behavior on colorizationColor{
                            ColorAnimation{
                                duration: 200
                            }
                        }
                        brightness: 0
                    } 
                }

                CustomText{
                    content: "General"
                    size: 20
                    color: Colors.primary
                }

            }

            ColumnLayout{
                Layout.margins: 5
                spacing: 0

                CustomText{
                    content: "Profile"
                    size: 18
                    color: Colors.secondary
                }
                CustomText{
                    content: "Edit your profile details"
                    size: 12
                    color: Colors.outline
                    weight: 600
                }

                RowLayout{
                    Layout.topMargin: 10
                    ClippingRectangle{
                        Layout.preferredHeight: 80
                        Layout.preferredWidth: 80
                        radius: 10
                        color: "transparent"

                        Image{
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: Settings.profile
                            sourceSize: Qt.size(width, height)

                        }
                    }
                    ColumnLayout{
                        Layout.fillHeight: true
                        Layout.margins: 5
                        spacing: 5
                        CustomText{
                            content: "St3el"
                            size: 16
                            weight: 700
                            color: Colors.tertiary
                        }

                        CustomText{
                            content: "Choose your profile picture"
                            size: 12
                            color: Colors.outline
                            weight: 600

                        }

                        RowLayout{
                            spacing: 10
                            Layout.fillHeight: true

                            Rectangle{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 30
                                radius: 10
                                color: Colors.surface
                                border{
                                    width: 1
                                    color: Colors.outline
                                }

                                CustomText{
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    anchors.leftMargin: 5
                                    content: Settings.profile
                                    size: 12
                                    weight: 600
                                }
                            }
                            IconImage {
                                Layout.preferredWidth: width
                                Layout.preferredHeight: height
                                implicitSize: 22
                                Layout.alignment: Qt.AlignVCenter
                                source: IconUtil.getSystemIcon("wallpaper")
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: Colors.primary
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


            ColumnLayout{
                Layout.margins: 5
                spacing: 0
                CustomText{
                    content: "Fonts"
                    size: 18
                    color: Colors.secondary
                }
                CustomText{
                    content: "Choose your fonts"
                    size: 12
                    color: Colors.outline
                    weight: 600
                }

                RowLayout{
                    Layout.topMargin: 10
                    CustomText{
                        Layout.fillWidth: true
                        content: "Default font"
                        size: 14
                        weight: 700
                    }

                    CustomList{
                        id: list
                        Layout.preferredWidth: 200
                        onListClicked: flickable.clip = false
                        onListChildClicked: (font) => Settings.setDefaultFont(font)
                        list: Settings.fonts
                        currentVal: Settings.defaultFont

                    }

                }
                // RowLayout{
                //    Layout.topMargin: 30 
                //     CustomText{
                //         content: "Default font size"
                //         size: 14
                //     }
                // }

            }

        }
    }
}
