pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root
    
    property list <NotificationItem> allNotifications: []
    property list <NotificationItem> popups: allNotifications.filter(n => n.popup)

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

            root.allNotifications.push(notifComp.createObject(root, {
                popup: true,
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
        
         property Timer timer: Timer {
            running: true
            interval: 5000
            onTriggered: {
                console.log("Exited")
                notifItem.popup = false
            }
        }
    } 

    Component{
        id: notifComp
        NotificationItem{}
    }
}
