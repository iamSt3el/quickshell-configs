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

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        RowLayout{
            SearchBar{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 400
            }
            Item{
                Layout.fillWidth: true
            }
            Rectangle{
                Layout.preferredHeight: 50
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
                        iconSize: 30
                    } 
                    CustomText{
                        content: ServiceWallpaper.folderModel.count + " wallpapers"
                        size: 16
                    }
                }
            }
        }


        GridView{
            id: grid
            Layout.fillHeight: true
            Layout.fillWidth: true
            cellWidth: width / 4
            cellHeight: height / 2
            model: ServiceWallpaper.folderModel
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
                color: "transparent"

                Image{
                    id: thumbnail
                    anchors.fill: parent
                    anchors.margins: 5
                    sourceSize: Qt.size(width, height)
                    //asynchronous: true
                    smooth: true
                    source: modelData.filePath

                    Behavior on anchors.margins{
                        NumberAnimation{
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: wallpaperItemImageContainer.width
                            height: wallpaperItemImageContainer.height
                            radius: 10
                        }
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered:{
                        thumbnail.anchors.margins = 0;
                    }
                    onExited:{
                        thumbnail.anchors.margins = 5;
                    }
                }
            }
        }

    }
}
