import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Hyprland
import qs.modules.utils
import qs.modules.settings
import qs.modules.services


Item{
    id: toolWidgets
    anchors.centerIn: parent
    width:300
    height: 300
    GlobalShortcut{
        name: "appLauncher"

        onPressed:{
            if(Hyprland.focusedMonitor.name === layout.screen.name){
                container.isClicked = !container.isClicked
                if(container.isClicked){
                        searchInput.forceActiveFocus()
                }
            }
        }
    }    

    Rectangle{
        id: container
        anchors.fill: parent
        color: "transparent"

        Rectangle{
            implicitHeight: 40
            implicitWidth: 40
            radius: width
            color: Settings.layoutColor
            anchors.centerIn: parent
            IconImage{
                implicitSize: 30
                source: IconUtil.getSystemIcon("close")
                anchors.centerIn: parent
            }
        }
        
        Repeater{
            id: repeater
            anchors.centerIn: parent
            model:ServiceTools.tools

            delegate: Rectangle{
                id: icon
                property int iconIndex: index
                property bool showOptions: false
                implicitWidth: 50
                implicitHeight: 50
                radius: width
                color: Settings.layoutColor
                scale: 0

                property var pos: Functions.getCirclePosition(
                    index,
                    ServiceTools.tools.length,
                    120/2,
                    container.width / 2,
                    container.height / 2
                )
                x: pos.x
                y: pos.y

                IconImage{
                    implicitSize: 30
                    anchors.centerIn: parent
                    source: IconUtil.getSystemIcon(modelData.icon)
                }

                Item{
                    anchors.fill: parent
                    visible: icon.showOptions
                    Repeater{
                        anchors.fill: parent
                        model: modelData.options
                        delegate: Item{
                            width: 50
                            height: 50
                            property var childPos: Functions.getFixedSpaceCirclePosition(
                                index,
                                3,
                                120 / 2,
                                icon.width / 2,
                                icon.height / 2,
                                65,
                                icon.iconIndex - 1
                            )
                            x: childPos.x
                            y: childPos.y
                            Rectangle{
                                implicitWidth: 40
                                implicitHeight: 40
                                radius: width
                                anchors.centerIn: parent
                                color: Settings.layoutColor

                                scale: 0

                              

                                IconImage{
                                    implicitSize: 25
                                    anchors.centerIn: parent
                                    source: IconUtil.getSystemIcon(modelData.icon)
                                }

                                MouseArea{
                                    id: optionIconArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onEntered:{
                                        parent.scale = 1.2
                                    }
                                    onExited:{
                                        parent.scale = 1
                                    }
                                }

                                Timer{
                                    interval: icon.showOptions ? (index * 100 + 200) : 0
                                    running: icon.showOptions
                                    onTriggered: parent.scale = 1
                                }

                                Behavior on scale{
                                    NumberAnimation{
                                        duration: 300
                                        easing.type: Easing.OutBack
                                    }
                                }

                                onVisibleChanged:{
                                    if(!visible) scale = 0
                                }
                            }
                        }
                    }
                }

                Timer{
                    interval: index * 150
                    running: true
                    onTriggered: parent.scale = 1
                }

                Behavior on scale{
                    NumberAnimation{
                        duration: 300
                        easing.type: Easing.OutBack
                    }
                }

                MouseArea{
                    id: iconArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor


                    onClicked:{
                        icon.showOptions = !icon.showOptions
                    }
                }

            }
        }

    }
}
