import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.services


Rectangle{
    id: root
    anchors.fill: parent
    color: Colors.surfaceContainer
    radius: 20

    signal notificationCenterClosed


    opacity:0
    scale: 0.8

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 400
        running: true
    }


    NumberAnimation on scale{
        from: 0.8
        to: 1
        duration: 400
        running: true
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        RowLayout{
            Layout.margins: 5
            spacing: 5
            MaterialIconSymbol{
                content: "notifications"
                iconSize: 18
            }
            CustomText{
                Layout.fillWidth: true
                content: "Notifications"
                size: 16
                weight: 600
            }
            MaterialIconSymbol{
                content: "close"
                iconSize: 20
                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.notificationCenterClosed()
                }
            }
        }

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 2
            radius: 5
            color: Colors.outline
        }

        Loader{
            active: ServiceNotification.allNotifications.length === 0
            visible: ServiceNotification.allNotifications.length === 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: Item{
                CustomText{
                    anchors.centerIn: parent
                    content: "No Notifications"
                    size: 20
                    weight: 600
                    color: Colors.outline
                }
            }
        }


        Loader{
            active: ServiceNotification.allNotifications.length > 0
            visible: ServiceNotification.allNotifications.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent:  ClippingWrapperRectangle{
                anchors.fill: parent
                radius: 20
                color: "transparent"
                ListView{
                    id: list
                    anchors.fill: parent
                    anchors.topMargin: 10
                    orientation: Qt.Vertical
                    model: ScriptModel{
                        values: [...ServiceNotification.allNotifications].reverse()
                    }
                    spacing: 10
                    add: Transition {
                        NumberAnimation{
                            property: "x"
                            from: list.width
                            to: 0
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                    }

                    addDisplaced: Transition{
                        NumberAnimation{
                            property: "y"
                            duration: 300
                            easing.type: Easing.OutQuad
                        }
                    }

                    move: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 350
                            easing.type: Easing.OutQuad
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 350
                            easing.type: Easing.OutQuad
                        }
                    }
                    delegate: NotificationItemNew {
                    }
                }
            }
        }

        RowLayout{
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.topMargin: 5
            CustomText{
                Layout.fillWidth: true
                content: ServiceNotification.notificationsNumber + " Notification"
                size: 15
            } 

            Rectangle{
                Layout.preferredWidth: 60
                Layout.preferredHeight: 30
                radius: 10
                color: clearArea.containsMouse ? Colors.primary : Colors.surfaceContainerHigh

                Behavior on color{
                    ColorAnimation{
                        duration: 200
                    }
                }
                CustomText{
                    anchors.centerIn: parent
                    content: "Clear"
                    size: 12
                    color: clearArea.containsMouse ? Colors.primaryText : Colors.surfaceVariantText
                }

                MouseArea{
                    id: clearArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked:{
                        ServiceNotification.clear()
                    }
                }
            }
        }
    }    
}
