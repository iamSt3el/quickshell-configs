import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import qs.modules.services
import Quickshell.Widgets

StyledRect{
    implicitWidth: parent.width / 2 - 10
    implicitHeight: parent.height - 10
    radius: 20
    color: "transparent"

    readonly property var notifications: ServiceNotification.allNotifications
    readonly property int notificationCount: notifications.length
    property int displayedCount: notificationCount

    Timer {
        id: heightUpdateTimer
        interval: 400
        onTriggered: displayedCount = notificationCount
    }

    onNotificationCountChanged: {
        if (notificationCount < displayedCount) {
            heightUpdateTimer.restart()
        } else {
            displayedCount = notificationCount
        }
    }

    Column{
        anchors.fill: parent
        spacing: 10

        Item {
            implicitWidth: parent.width
            implicitHeight: 40

       
                StyledText{
                    id: titleText
                    anchors.verticalCenter: parent.verticalCenter
                    content: "Notifications" + `(${ServiceNotification.notificationsNumber})`
                    size: 20
                }

                Rectangle{
                    implicitHeight: 20
                    implicitWidth: 30
                    radius: 5
                    color: Colors.surfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    Image{
                        anchors.centerIn: parent
                        source: IconUtils.getSystemIcon("clear")
                        width: 20
                        height: 20
                        sourceSize: Qt.size(width, height)
                    }

                    MouseArea{
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            
                            ServiceNotification.clear()
                        }
                    }
            }
        }

        Loader{
            visible: displayedCount <= 0
            height: parent.height - 60
            width: parent.width
            active: displayedCount <= 0
            sourceComponent: Component{
                Item{
                    anchors.fill: parent

                    Column {
                        anchors.centerIn: parent
                        spacing: 15

                        Image{
                            width: 130
                            height: 130
                            anchors.horizontalCenter: parent.horizontalCenter
                            source: IconUtils.getImage("interface-design.png")
                        }

                        StyledText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            content: "No notifications"
                            size: 16
                            color: Colors.tertiaryText
                        }
                    }
                }
            }
        }

        Loader{
            visible: displayedCount > 0
            height: parent.height - 60
            width: parent.width
            active: displayedCount > 0
            sourceComponent: Component{
                ClippingWrapperRectangle{
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10

                    ListView{
                        id: notificationsList
                        width: parent.width
                        height: parent.height
                        orientation: Qt.Vertical
                        clip: true
                        reuseItems: false

                        model: ScriptModel{
                            values: [...notifications].reverse().slice(0, displayedCount)
                        }
                        spacing: 8

                        add: Transition {
                            NumberAnimation{
                                property: "x"
                                from: notificationsList.width
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

                        delegate: Item {
                            id: itemWrapper
                            width: notificationsList.width
                            height: notificationItem.height

                            property int idx: index


                            NotificationItem {
                                id: notificationItem
                                width: notificationsList.width
                                anchors.top: parent.top
                                notificationData: modelData
                            }
                        }

                        onModelChanged: {
                            forceLayout()
                        }
                    }
                }
            }
        }
    }
}
