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

        Rectangle{
            anchors.fill: parent
            anchors.margins: 10
            radius: 20
            color: Colors.surfaceContainer
            RowLayout{
                anchors.fill: parent

                Rectangle{
                    Layout.fillHeight: true
                    Layout.preferredWidth: 150
                    radius:20
                    color: Colors.surfaceContainerHigh

                    ColumnLayout{
                        // anchors.top: parent.top
                        // anchors.left: parent.left
                        // anchors.right: parent.right
                        // anchors.topMargin: 10
                        // anchors.leftMargin: 10
                        // anchors.rightMargin: 10
                        anchors.fill: parent
                        anchors.margins: 10

                        CustomText{
                            //Layout.alignment: Qt.AlignHCenter
                            content: "Nebula"
                            size: 22
                            weight: 700
                        }
                        CustomText{
                            content: "v0.1.0-beta"
                            size: 12
                            color: Colors.outline
                        }

                        Item{
                            Layout.preferredHeight: 20
                        }

                        Item{
                            Layout.fillWidth: true
                            Layout.preferredHeight: navColumn.implicitHeight

                            Rectangle{
                                id: navHighlight
                                width: parent.width
                                height: 40
                                radius: 10
                                color: Colors.primary
                                y: root.currentPage * (40 + navColumn.spacing)

                                Behavior on y{
                                    NumberAnimation{
                                        duration: 200
                                        easing.type: Easing.OutQuad
                                    }
                                }
                            }

                            Column{
                                id: navColumn
                                anchors.left: parent.left
                                anchors.right: parent.right
                                spacing: 5

                                Repeater{
                                    model: Settings.pages

                                    delegate: Item{
                                        property bool active: root.currentPage === index
                                        width: navColumn.width
                                        height: 40

                                        RowLayout{
                                            anchors.fill: parent
                                            anchors.margins: 5
                                            spacing: 10
                                            MaterialIconSymbol{
                                                content: modelData.icon
                                                iconSize: 20
                                                color: active ? Colors.primaryText : Colors.surfaceVariantText
                                            }
                                            CustomText{
                                                Layout.fillWidth: true
                                                content: modelData.name
                                                size: 14
                                                color: active ? Colors.primaryText : Colors.surfaceVariantText
                                            }
                                        }

                                        MouseArea{
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            hoverEnabled: true

                                            onClicked:{
                                                root.currentPage = index
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        Item{
                            Layout.fillHeight: true
                        }

                        Rectangle{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 40
                            radius: 15
                            color: Colors.tertiary

                            RowLayout{
                                anchors.centerIn: parent
                                MaterialIconSymbol{
                                    content: "edit"
                                    size: 20
                                    color: Colors.tertiaryText
                                }
                                CustomText{
                                    content: "Edit Config"
                                    size: 14
                                    color: Colors.tertiaryText
                                }
                            }
                        }
                    }
                }
                Item{
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Loader{
                        anchors.fill: parent
                        active: root.currentPage === 0
                        sourceComponent:General{}
                    }
                    Loader{
                        anchors.fill: parent
                        active: root.currentPage === 1
                        sourceComponent: Theme{}
                    }

                    Loader{
                        anchors.fill: parent
                        active: root.currentPage === 2
                        sourceComponent: Display{}
                    }

                    Loader{
                        anchors.fill: parent
                        active: root.currentPage === 3
                        sourceComponent: Keybindings{}
                    }

                    Loader{
                        anchors.fill: parent
                        active: root.currentPage === 4
                        sourceComponent: About{}
                    }


                }

            }
        }

    }
}
