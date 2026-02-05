import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import qs.modules.utils
import qs.modules.settings
import qs.modules.customComponents


Item{
    id: root
    anchors.fill: parent


    property bool isMenuOpen: true
    property var currentPage: 0
    signal settingClosed
    scale: 0.7

    opacity: 0

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 200
        running: true
    }
    NumberAnimation on scale{
        from: 0.7
        to: 1
        duration: 100
        running: true
    }



    Rectangle{
        anchors.fill: parent
        radius: 20
        color: Settings.layoutColor

        ColumnLayout{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Item{
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 40

                CustomText{
                    anchors.centerIn: parent
                    content: "Settings"
                    size: 18
                }

                MaterialIconSymbol {
                    id: close
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 10
                    iconSize: 18
                    content: "close"
                 
                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked:root.settingClosed()

                    }
                }

            }
            RowLayout{
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width
                spacing: 10 

                Rectangle{
                    Layout.minimumWidth: 0
                    Layout.preferredWidth: root.isMenuOpen ? 130 : 55
                    Layout.preferredHeight: parent.height
                    color: Colors.surfaceContainer
                    radius: 10

                    Behavior on Layout.preferredWidth{
                        NumberAnimation{
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    ColumnLayout{
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 20

                        Item{
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 29


                            MaterialIconSymbol {
                                id: collapse
                                anchors.right: parent.right
                                anchors.rightMargin: root.isMenuOpen ? 0 : 5
                                iconSize: 18
                                content: "menu"

                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked:{
                                        root.isMenuOpen = !root.isMenuOpen
                                    }

                                }
                            }
                        }

                        Item{
                            Layout.fillHeight: true
                            Layout.preferredWidth: parent.width

                            ListView{
                                orientation: Qt.Vertical
                                height: contentHeight 
                                width: parent.width
                                interactive: false
                                spacing: 10

                                model: Settings.pages

                                delegate: Rectangle{
                                    implicitWidth: parent.width
                                    implicitHeight: 40
                                    color: root.currentPage === index ? Colors.primary : area.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent" 
                                    radius: 10


                                    Behavior on color{
                                        ColorAnimation{
                                            duration: 400
                                            easing.type: Easing.OutQuad
                                        }
                                    }

                                    Row{
                                        anchors.fill: parent
                                        anchors.margins: 5
                                        spacing: 10

                                        MaterialIconSymbol {
                                            anchors.verticalCenter: parent.verticalCenter
                                            iconSize: 24
                                            content: modelData.icon
                                            color: root.currentPage === index ? Colors.primaryText: Colors.surfaceVariantText
                                           
                                        }

                                        CustomText{
                                            visible: root.isMenuOpen
                                            weight: 600
                                            size: 14
                                            anchors.verticalCenter: parent.verticalCenter
                                            content: modelData.name
                                            color: root.currentPage === index ? Colors.primaryText: Colors.surfaceVariantText
                                        }
                                    }

                                    MouseArea{
                                        id: area
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked:{
                                            root.currentPage = index
                                        }
                                    }
                                    layer.enabled: root.currentPage === index
                                    layer.effect: MultiEffect{
                                        shadowEnabled: true
                                        shadowBlur: 0.4
                                        shadowOpacity: 1.0
                                        shadowColor: Qt.alpha(Colors.shadow, 1)
                                    }


                                }

                            }

                        }

                    }
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height
                    color: Colors.surfaceContainer
                    radius: 10
                    Behavior on Layout.preferredWidth{
                        NumberAnimation{
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }

                    Loader{
                        active: root.currentPage === 0
                        anchors.fill: parent
                        sourceComponent: General{

                        }
                    }
                    Loader{
                        active: root.currentPage === 1
                        anchors.fill: parent
                        sourceComponent: Theme{

                        }
                    }

                    Loader{
                        active: root.currentPage === 2
                        anchors.fill: parent
                        sourceComponent: Display{

                        }
                    }

                    Loader{
                        active: root.currentPage === 3
                        anchors.fill: parent
                        sourceComponent: About{

                        }
                    }
                }
            }
        }
    }
}
