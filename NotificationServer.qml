import Quickshell
import Quickshell.Services.Notifications

ShellRoot {
    property var notificationQueue: []
    
    NotificationServer {
        id: notifications
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        imageSupported: true
        inlineReplySupported: true
        onNotification: function(notification) {
            // Log notification details
            console.log(`Notification from ${notification.appName}: ${notification.summary}`);   
            
            // Show in your custom notification popup
            addNotification(notification)
        }

    }

    function addNotification(notification){
        var notificationObj = {
            id: notification.id,
            summary: notification.summary || "notification",
            inlineReplyPlaceholder: notification.inlineReplyPlaceholder || "nothing",
            image: notification.image,
            appName: notification.appName
        }

        notificationQueue.unshift(notificationObj)

        notificationQueue = notificationQueue
    }


    NotificationPanel{
        id: notificationPanel
        notifList: notificationQueue
    }
    
}
