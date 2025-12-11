pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications
import QtMultimedia

Singleton {
    id: root

    property list <NotificationItem> allNotifications: []
    property list <NotificationItem> popups: allNotifications.filter(n => n.popup)
    property int notificationsNumber: allNotifications.length
    property bool muted: false


    SoundEffect {
        id: notificationSound
        source: "../../notification.wav"
    }

    NotificationServer{
        id: server
        keepOnReload: false
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        inlineReplySupported: true

        onNotification: notif => {
            notif.tracked = true
            notificationSound.play()
            root.allNotifications.push(notifComp.createObject(root, {
                popup: !root.muted,
                notification: notif
            }))
        }
    }


    component NotificationItem: QtObject {
        id: notifItem

        property bool popup
        required property Notification notification
        readonly property string id: notification.id
        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property int urgency: notification.urgency
        readonly property bool isLow: notification.urgency === NotificationUrgency.Low
        readonly property bool isNormal: notification.urgency === NotificationUrgency.Normal
        readonly property bool isCritical: notification.urgency === NotificationUrgency.Critical

        property Timer timer: Timer {
            running: true
            interval: 5000
            onTriggered: {
                console.log("Exited")
                notifItem.popup = false
            }
        }

        property real progress: 0
        NumberAnimation on progress {
            running: timer.running
            from: 0
            to: 1
            duration: timer.interval
        }
    }

    function clear(){
        root.allNotifications = []
    }

    function removeNotification(notificationItem) {
        const index = root.allNotifications.indexOf(notificationItem)
        if (index > -1) {
            root.allNotifications.splice(index, 1)
            root.allNotifications = root.allNotifications.slice()
        }
    }

    function toggleMute() {
        root.muted = !root.muted
    }

    Component{
        id: notifComp
        NotificationItem{}
    }
}


