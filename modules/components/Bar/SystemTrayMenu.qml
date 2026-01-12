import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.settings

PopupWindow{
    id: root
    implicitWidth: 240
    implicitHeight: container.implicitHeight + 10
    //implicitHeight: 320
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


    Rectangle{
        id: container
        anchors{
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: 2
        }
        implicitHeight: stackView.implicitHeight
        radius: 15
        color: Settings.layoutColor

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

        StackView{
            id: stackView

            implicitHeight: currentItem.implicitHeight
            implicitWidth: currentItem.implicitWidth

            pushEnter: Transition {
                NumberAnimation {
                    duration: 0
                }                    
            }

            pushExit: Transition {
                NumberAnimation {
                    duration: 0
                }                    
            }

            popEnter: Transition {
                NumberAnimation {
                    duration: 0
                }                    
            }

            popExit: Transition {
                NumberAnimation {
                    duration: 0
                }                    
            }


            initialItem: SubMenu{
                handle: root.menuData
            }

            component SubMenu: Column{
                property QsMenuHandle handle
                property bool show
                property bool isSubMenu

                padding: 5 
                spacing: 5

                opacity: show ? 1 : 0
                scale: show ? 1 : 0.8

                Component.onCompleted: show = true
                StackView.onActivating: show = true
                StackView.onDeactivating: show = false

                QsMenuOpener{
                    id: menuOpener
                    menu: handle
                }




                Behavior on opacity{
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on scale{
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }

                Loader{
                    active: isSubMenu

                    sourceComponent: Item{
                        implicitWidth: 230
                        implicitHeight: 30

                        RowLayout{
                            anchors.fill: parent
                            anchors.margins: 5

                            CustomIconImage{
                                icon: "left"
                                size: 20
                            }

                            CustomText{
                                Layout.fillWidth: true
                                content: "Back"
                                size: 12
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: stackView.pop()
                        }
                    }
                }

                Repeater{
                    model: menuOpener.children

                    Rectangle{
                        implicitWidth: 230
                        implicitHeight: modelData.isSeparator ? 1 : 30
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
                                const entry = modelData
                                if(entry.hasChildren){
                                    stackView.push(subMenuComp.createObject(null, {
                                        handle: entry,
                                        isSubMenu: true
                                    }));
                                }else{
                                    root.close()
                                    modelData.triggered()
                                }
                            }
                        }
                    }
                }


            }

            Component{
                id: subMenuComp
                SubMenu{}
            }
        }




    }
}
