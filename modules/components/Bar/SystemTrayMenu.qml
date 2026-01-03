import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.settings

PopupWindow{
    id: root
    implicitWidth: 240
    implicitHeight: container.implicitHeight + 10
    visible: true
    signal close
    color: "transparent"
    property QsMenuHandle menuData
    anchor{
        window: layout
        rect.x: utility.x
        rect.y: utility.y + utility.height
    }

    HyprlandFocusGrab {
        active: true
        windows: [QsWindow.window]
        onCleared: root.close()
    }
    QsMenuOpener{
        id: menuOpener
        menu: root.menuData
    }

    Rectangle{
        id: container
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 5
        }
        implicitHeight: col.implicitHeight + 20
        radius: 15
        color: Settings.layoutColor

        ColumnLayout{
            id: col
            anchors{
                top: parent.top
                left: parent.left
                right: parent.right
                leftMargin: 10
                rightMargin: 10
                topMargin: 10
            }

            Repeater{
                model: menuOpener.children

                delegate: Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: modelData.isSeparator ? 1 : 30
                    radius: 10
                    color: area.containsMouse ? Colors.surfaceContainerHigh : modelData.isSeparator ? Colors.outline : "transparent"

                    Loader{
                        active: !modelData.isSeparator
                        anchors.fill: parent
                        sourceComponent: RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5
                            anchors.leftMargin: 10
                            spacing: 10


                            CustomText{
                                Layout.fillWidth: true
                                width: text.implicitWidth
                                content: modelData.text
                                size: 12
                            }
                            Loader{
                                active: modelData.hasChildren
                                visible: active
                                sourceComponent: CustomIconImage{
                                    icon: "right"
                                    size: 18
                                }
                            }

                            Loader{
                                active: modelData.buttonType === 1
                                visible: active
                                sourceComponent: CustomCheckbox{
                                    checkState: modelData.checkState === 2 ? true : false
                                }
                            }
                        }
                    }
                    MouseArea{
                        id: area
                        visible: !modelData.isSeparator
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            if(!modelData.hasChildren){
                                root.close()
                                modelData.triggered()
                            }
                        }
                    }
                }
            }
        }
    }
}
