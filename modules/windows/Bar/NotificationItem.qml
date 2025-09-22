import Quickshell
import QtQuick
import qs.modules.util
import qs.modules.components
import qs.modules.services

Rectangle {
    id: notificationItem
    property var notificationData
    property bool expanded: false

    implicitHeight: {
        if (!expanded) {
            return 70
        } else {
            return Math.max(70, contentColumn.implicitHeight + 16)
        }
    }
    radius: 12

    // Urgency-based colors
    color: {
        if (!notificationData) return Colors.surfaceVariant

        if (notificationData.isCritical) return Colors.errorContainer
        // Keep normal and low as default surfaceVariant
        return Colors.surfaceVariant
    }

    // Urgency border - only for critical
    border.width: notificationData?.isCritical ? 2 : 0
    border.color: notificationData?.isCritical ? Colors.error : "transparent"

    x: 0

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    onNotificationDataChanged: {
        expanded = false
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        property int startY

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: pressed ? Qt.ClosedHandCursor : Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.MiddleButton
        preventStealing: true

        drag.target: parent
        drag.axis: Drag.XAxis

        onPressed: event => {
            startY = event.y
            if (event.button === Qt.MiddleButton) {
                ServiceNotification.removeNotification(notificationData)
            }
        }

        onReleased: {
            if (Math.abs(notificationItem.x) < notificationItem.width * 0.3) {
                notificationItem.x = 0
            } else {
                ServiceNotification.removeNotification(notificationData)
            }
        }

        onPositionChanged: event => {
            if (pressed) {
                const diffY = event.y - startY
                if (Math.abs(diffY) > 20) {
                    notificationItem.expanded = diffY > 0
                }
            }
        }
    }


    Row {
        id: mainRow
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            width: 45
            height: 45
            radius: 8
            color: Colors.surface
            anchors.top: parent.top
            anchors.topMargin: 2

            Image {
                anchors.centerIn: parent
                width: 32
                height: 32
                sourceSize: Qt.size(width, height)
                source: notificationData?.appIcon ?
                    "image://icon/" + notificationData.appIcon :
                    IconUtils.getSystemIcon("notification")
                fillMode: Image.PreserveAspectFit
            }
        }

        Column {
            id: contentColumn
            width: parent.width - 57 - 30 
            anchors.top: parent.top
            anchors.topMargin: 2
            spacing: 4

            Row {
                width: parent.width
                spacing: 8

                StyledText {
                    content: notificationData?.appName || "Unknown App"
                    size: 12
                    color: notificationData?.isCritical ? Colors.errorContainerText : Colors.surfaceVariantText
                    effect: false
                    elide: Text.ElideRight
                    font.family: Typography.primary
                }

                StyledText {
                    content: Qt.formatTime(new Date(), "hh:mm")
                    size: 11
                    color: notificationData?.isCritical ? Colors.errorContainerText : Colors.surfaceVariantText
                    effect: false
                    font.family: Typography.primary
                }
            }

            StyledText {
                width: parent.width
                content: notificationData?.summary || ""
                size: 14
                color: notificationData?.isCritical ? Colors.errorContainerText : Colors.surfaceVariantText
                effect: false
                elide: Text.ElideRight
                wrapMode: expanded ? Text.WordWrap : Text.NoWrap
                maximumLineCount: expanded ? 3 : 1
                font.family: Typography.primary
            }

            StyledText {
                id: bodyText
                visible: expanded && (notificationData?.body || "") !== ""
                width: parent.width
                content: notificationData?.body || ""
                size: 12
                color: Colors.surfaceVariantText
                effect: false
                wrapMode: Text.WordWrap
                opacity: expanded ? 1.0 : 0.0
                font.family: Typography.primary

                height: expanded ? implicitHeight : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: expanded ? 250 : 150
                        easing.type: expanded ? Easing.OutQuart : Easing.InQuart
                    }
                }

                Behavior on height {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.1
                    }
                }

                transform: Scale {
                    origin.x: bodyText.width / 2
                    origin.y: 0
                    xScale: expanded ? 1.0 : 0.95
                    yScale: expanded ? 1.0 : 0.95

                    Behavior on xScale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }
                    Behavior on yScale {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutBack
                        }
                    }
                }
            }

        }
    }


    Rectangle {
        width: 24
        height: 24
        radius: 12
        //color: Colors.surface
       color: "transparent"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 8

        visible: notificationData?.body && notificationData.body !== ""

        Image {
            anchors.centerIn: parent
            width: 16
            height: 16
            sourceSize: Qt.size(width, height)
            source: IconUtils.getSystemIcon("down")
            rotation: expanded ? 180 : 0

            Behavior on rotation {
                NumberAnimation { duration: 200 }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton

            onClicked: mouse => {
                mouse.accepted = true
                notificationItem.expanded = !notificationItem.expanded
            }
        }
    }

}
