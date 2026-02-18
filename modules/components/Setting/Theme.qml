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
    anchors.fill: parent
    anchors.margins: 5
    
    Flickable{
        anchors.fill: parent  
        contentHeight: column.implicitHeight
        contentWidth: width   
        clip: true
        
        ColumnLayout{
            id: column
            width: parent.width
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 5
            spacing: 0        

            RowLayout{
                spacing: 10
                MaterialIconSymbol{
                    content: "palette"
                    iconSize: 20
                } 

                CustomText{
                    content: "Theme"
                    size: 20
                    color: Colors.primary
                }
            }

            CustomText{
                Layout.topMargin: 30
                content: "Appearance"
                size: 18
                color: Colors.primary
            }
            CustomText{
                content: "Edit the appearance details"
                size: 14
                color: Colors.outline
            }

            RowLayout{
                Layout.fillWidth: true
                Layout.topMargin: 10
                spacing: 10
                ColumnLayout{
                    spacing: 0
                    CustomText{
                        content: "Wallpaper"
                        size: 16
                    }
                    CustomText{
                        content: "Choose your wallpaper"
                        size: 13
                        color: Colors.outline
                    }

                }

                Item{
                    Layout.fillWidth: true
                }
                Rectangle{
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                    radius: 10
                    color: Colors.surfaceContainerHighest
                    clip: true
                    CustomText{
                        anchors.right: parent.right
                        anchors.left: parent.left
                        anchors.rightMargin: 10
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        content: Colors.wallpaper
                        size: 14
                    }
                }
                Rectangle{
                    Layout.preferredHeight: 30 
                    Layout.preferredWidth: 30
                    radius: 10
                    color: Colors.tertiary


                    MaterialIconSymbol{
                        anchors.centerIn: parent
                        content: "wallpaper"
                        size: 26
                        color: Colors.tertiaryText
                    }
                } 
            }
            RowLayout{
                Layout.topMargin: 10
                ColumnLayout{
                    spacing: 0
                    CustomText{
                        content: "Theme Mode"
                        size: 16
                    }
                    CustomText{
                        content: "Set Theme mode Dark/Light"
                        size: 13
                        color: Colors.outline
                    }
                }
                Item{
                    Layout.fillWidth: true
                }
                
                Rectangle{
                    id: outer
                    Layout.preferredWidth:120
                    Layout.preferredHeight: 30 
                    color: "transparent"
                    radius: 10
                    border{
                        width: 1
                        color: Colors.outline
                    }
                    property bool active

              
                    Rectangle{
                        id: slider
                        implicitWidth: 60 
                        implicitHeight: 30
                        radius: 10
                        color: Colors.tertiary

                        Behavior on x{
                            NumberAnimation{
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                    Row{
                        Item{
                            id: sun
                            implicitHeight: 30
                            implicitWidth: 60
                            MaterialIconSymbol{
                                anchors.centerIn: parent
                                content: "sunny"
                                size: 24
                                color: !outer.active ? Colors.tertiaryText : Colors.surfaceText
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    slider.x = sun.x
                                    outer.active = false
                                }
                            }
                        }
                        Item{
                            id: moon
                            implicitHeight: 30
                            implicitWidth: 60
                            MaterialIconSymbol{
                                anchors.centerIn: parent
                                content: "bedtime"
                                size: 24
                                color: outer.active ? Colors.tertiaryText : Colors.surfaceText
                            }
                            MouseArea{
                                anchors.fill: parent
                                onClicked:{
                                    slider.x = moon.x
                                    outer.active = true
                                }
                            }

                        }
                    }
                }
            }
            RowLayout{
                Layout.topMargin: 10
                ColumnLayout{
                    spacing: 0
                    CustomText{
                        content: "Matugen"
                        size: 16
                    }
                    CustomText{
                        content: "Matugen lets you generates colors from your wallpaper"
                        size: 13
                        color: Colors.outline
                    }
                }
                Item{
                    Layout.fillWidth: true
                }

                CustomToogle{

                }
            }
            RowLayout{
                Layout.topMargin: 10
                ColumnLayout{
                    spacing: 0
                    CustomText{
                        content: "Matugen Styles"
                        size: 16
                    }
                    CustomText{
                        content: "Choose matugen style"
                        size: 13
                        color: Colors.outline
                    }
                }
                Item{
                    Layout.fillWidth: true
                }

                CustomListNew{
                    Layout.preferredWidth: 200
                    Layout.preferredHeight: 30
                    currentVal: Settings.currentMatugenStyle
                    list: Settings.matugen
                    onIsListClickedChanged:{
                        if(isListClicked)
                        grab.active = false
                        else 
                        grab.active = true
                    }
                }
            }
        }
    }
}

