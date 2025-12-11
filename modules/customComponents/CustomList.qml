import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings

Rectangle{
    id: root
    property bool isListClicked: false
    property var currentVal
    property var list: []
    color: Colors.surface
    radius: 10
    z: isListClicked ? 1000 : 0
    signal listClicked
    signal listChildClicked(string font)
    height: 30
    border{
        width: 1
        color: Colors.outline
    }

    Behavior on height{
        NumberAnimation{
            duration: 200
            easing.type: Easing.OutQuad
        }
    }

    onCurrentValChanged:{
        console.log("Height: " + height)
    }

    RowLayout{
        visible: !root.isListClicked && root.height === 30
        anchors.fill: parent
        anchors.margins: 5
        anchors.leftMargin: 10
        CustomText{
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            content: root.currentVal
            size: 12
            weight: 600
        }
        
        CustomIconImage{
            icon: "drop-down"
            size: 20

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    root.isListClicked = true
                    root.listClicked()
                }
            }
        } 
    }

    Loader{
        active: root.isListClicked
        sourceComponent: PopupWindow{
            id: popup
            anchor.window: layout
            visible: true
            implicitWidth: root.width
            implicitHeight: 200
            color: "transparent"

            property var windowPos: layout?.mapFromItem(root, 0, root.height) ?? Qt.point(0, 0)

            anchor{
                rect.x: windowPos.x
                rect.y: windowPos.y - root.height
            }



            Rectangle{
                anchors.fill: parent
                radius: 10
                color: Colors.surface
                border{
                    width: 1
                    color: Colors.outline
                }

                ColumnLayout{
                    anchors.fill: parent
                    anchors.margins: 10

                    Rectangle{
                        Layout.preferredWidth: parent.width
                        Layout.preferredHeight: 30
                        radius: 10
                        color: Colors.surfaceContainerHigh

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5
                            CustomIconImage{
                                icon: "search"
                                size: 14
                            }

                            TextInput{
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                verticalAlignment: TextInput.AlignVCenter
                                focus: true
                                clip: true
                                text: root.currentVal
                                font.pixelSize: 12
                                color: Colors.inverseSurface
                            }
                        }
                    }

                    ListView{
                        Layout.fillHeight: true
                        Layout.topMargin: 5
                        orientation: Qt.Vertical
                        Layout.preferredWidth: parent.width
                        model: root.list
                        spacing: 5
                        clip: true

                        delegate: Rectangle{
                            implicitWidth: ListView.view.width
                            implicitHeight: 20
                            radius: 5
                            color: root.currentVal === modelData.name ? Colors.primary : area.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent"
                            CustomText{
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.leftMargin: 5
                                content: modelData.name
                                width: text.width
                                size: 12
                                weight: 600
                                color: root.currentVal === modelData.name ? Colors.primaryText : Colors.surfaceVariantText
                            }

                            MouseArea{
                                id: area
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true

                                onClicked:{
                                    root.isListClicked = false
                                    root.currentVal = modelData.name
                                    root.listChildClicked(modelData.name)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ColumnLayout{
    //     visible: root.isListClicked
    //     anchors.fill: parent
    //     anchors.margins: 10
    //
    //     Rectangle{
    //         Layout.preferredWidth: parent.width
    //         Layout.preferredHeight: 30
    //         radius: 10
    //         color: Colors.surfaceContainerHigh
    //
    //         RowLayout{
    //             anchors.fill: parent
    //             anchors.margins: 5
    //             CustomIconImage{
    //                 icon: "search"
    //                 size: 14
    //             }
    //
    //             TextInput{
    //                 Layout.fillWidth: true
    //                 Layout.fillHeight: true
    //                 verticalAlignment: TextInput.AlignVCenter
    //
    //                 focus: true
    //                 clip: true
    //                 text: root.currentVal
    //                 font.pixelSize: 12
    //                 color: Colors.inverseSurface
    //
    //             }
    //         }
    //     }
    //
    //     ListView{
    //         visible: root.isListClicked
    //         Layout.fillHeight: true
    //         Layout.topMargin: 5
    //         orientation: Qt.Vertical
    //         Layout.preferredWidth: parent.width
    //         model: root.list
    //         spacing: 5
    //
    //         delegate: Rectangle{
    //             implicitWidth: ListView.view.width
    //             implicitHeight: 20
    //             radius: 5
    //             color: root.currentVal === modelData.name ? Colors.primary : area.containsMouse ? Qt.alpha(Colors.primary, 0.5) : "transparent"
    //             CustomText{
    //                 anchors.left:parent.left
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 anchors.leftMargin: 5
    //                 content: modelData.name
    //                 width: text.width
    //                 size: 12
    //                 weight: 600
    //                 color: root.currentVal === modelData.name ? Colors.primaryText : Colors.surfaceVariantText 
    //             }
    //
    //             MouseArea{
    //                 id: area
    //                 anchors.fill: parent
    //                 cursorShape: Qt.PointingHandCursor
    //                 hoverEnabled: true
    //
    //                 onClicked:{
    //                     root.isListClicked = false
    //
    //                     root.currentVal = modelData.name
    //                     root.listChildClicked(modelData.name)
    //                 }
    //             }
    //         }
    //     }
    //
    // }
}
