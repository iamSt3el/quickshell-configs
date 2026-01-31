import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Rectangle{
    implicitWidth: parent.width
    topLeftRadius: Appearance.radius.large
    topRightRadius: Appearance.radius.extraLarge
    color: Colors.surface
    anchors.bottom:  parent.bottom


    Behavior on implicitHeight{
        NumberAnimation{
            duration: Appearance.duration.normal
            easing.type: Easing.OutQuad
        }
    }

    Connections{
        target: loader
        function onAnimationChanged(){
            if(loader.animation){
                timer.start();
            }else{
                colLoader.active = false
            }
        }
    }

    Timer{
        id: timer
        interval: 300
        onTriggered:{
            colLoader.active = true
        }
    }
    Loader{
        id: colLoader
        active: false
        visible: active
        anchors.fill: parent
        sourceComponent:ColumnLayout{
            id: col
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            NumberAnimation on opacity{
                from: 0
                to: 1
                duration: 100
                running: col.visible
            }

            NumberAnimation on scale{
                from: 0.8
                to: 1
                duration: 100
                running: col.visible
            }
            
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                radius: Appearance.radius.extraLarge
                color: Colors.surfaceContainer
                RowLayout{
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    spacing: 10
                    SearchBar{
                        Layout.preferredHeight: 50
                        Layout.preferredWidth: 400
                    }
                    Item{
                        Layout.fillWidth: true
                    }
                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 40
                        radius: 20
                        color: Colors.surfaceContainerHigh

                        MaterialIconSymbol{
                            anchors.centerIn: parent
                            content: "refresh"
                            iconSize: 20
                        }

                        CustomMouseArea{
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked:{
                                ServiceWallpaper.refresh()
                            }
                        }
                    } 
                    Rectangle{
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: row.implicitWidth + 30
                        radius: 20
                        color: Colors.surfaceContainerHigh
                        RowLayout{
                            id: row
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            anchors.rightMargin: 10
                            spacing: 10
                            MaterialIconSymbol{
                                content: "wallpaper"
                                iconSize: 18
                            } 
                            CustomText{
                                content: ServiceWallpaper.cacheModel.count + " wallpapers"
                                size: 12
                            }
                        }
                    }
                }
            }


            GridView{
                id: grid
                Layout.fillHeight: true
                Layout.fillWidth: true
                cellWidth: width / 4
                cellHeight: height / (4 / 2)
                model: ScriptModel{
                    values: ServiceWallpaper.wallpapers
                }
                clip: true

                interactive: true
                //keyNavigationWraps: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: CustomScrollBar{}


                delegate: Rectangle{
                    id: wallpaperItemImageContainer
                    required property var modelData
                    width: grid.cellWidth
                    height: grid.cellHeight
                    radius: 10
                    color: area.containsMouse ? Colors.primary : "transparent"

                    // border{
                    //     width: 2
                    //     color: area.containsMouse ? Colors.primary : "transparent"
                    // }

                    Image{
                        id: thumbnail
                        anchors.fill: parent
                        anchors.margins: 5
                        sourceSize: Qt.size(width, height)
                        asynchronous: true
                        anchors.centerIn: parent
                        smooth: true
                        cache: false
                        source: "file://" + modelData
                        fillMode: Image.PreserveAspectCrop
                        Behavior on anchors.margins{
                            NumberAnimation{
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: thumbnail.width
                                height: thumbnail.height
                                radius: 10
                            }
                        }
                    }

                    MouseArea{
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            ServiceWallpaper.setWallpaper(modelData) 
                        }
                    }
                }
            }

        }
    }
}
