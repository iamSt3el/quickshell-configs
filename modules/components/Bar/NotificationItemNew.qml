import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services
import qs.modules.settings

Rectangle {
    id: notif
    property bool isExtended: false
    property int padding: 10

    implicitWidth: parent ? parent.width : 0
    implicitHeight: isExtended ? notifRow.implicitHeight + 20 : 60
    radius: 10
    color: Colors.surfaceContainerHighest
    clip: true

    x: 0

    Behavior on x {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    // Drag gestures
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
                ServiceNotification.removeNotification(modelData)
            }
        }

        onReleased: {
            if (Math.abs(notif.x) < notif.width * 0.3) {
                notif.x = 0
            } else {
                ServiceNotification.removeNotification(modelData)
            }
        }

        onPositionChanged: event => {
            if (pressed) {
                const diffY = event.y - startY
                if (Math.abs(diffY) > 20) {
                    notif.isExtended = diffY > 0
                }
            }
        }
    }

    RowLayout{
        id: notifRow
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5

        Image{
            source: IconUtil.getIconPath(modelData.appIcon)
            width: 26
            height: 26
            sourceSize: Qt.size(width, height)

            transform: Translate {
                y: notif.isExtended ? -notifRow.implicitHeight / 2 + 10 : 0

                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }

        ColumnLayout{
            Layout.fillWidth: true
            Layout.margins: 5
            Layout.fillHeight: true

            CustomText{
                Layout.fillWidth: true
                Layout.fillHeight: true
                visible: notif.isExtended
                content: modelData.appName
                size: 12

                NumberAnimation on opacity{
                    from: 0
                    to: 1
                    duration: 300
                    running: notif.isExtended
                }
                color: Colors.outline
            }
            Item{
                Layout.fillWidth: true
                Layout.fillHeight: notif.isExtended ? true : false
                Layout.preferredHeight: notif.isExtended ? summaryText.implicitHeight : summaryFont.height
                clip: true
                FontMetrics{
                    id: summaryFont
                    font: summaryText.font
                }

                Behavior on Layout.preferredHeight{
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                CustomText{
                    id: summaryText
                    width: parent.width
                    size: 13
                    anchors.top: parent.top
                    content: modelData.summary
                    wrapMode: notif.isExtended ? Text.WordWrap : Text.NoWrap

                }
            }

            Item{
                Layout.fillWidth: true
                Layout.fillHeight: notif.isExtended ? true : false
                Layout.preferredHeight: notif.isExtended ? bodyText.implicitHeight : fontMetrics.height
                clip: true
                FontMetrics{
                    id: fontMetrics
                    font: bodyText.font
                }

                Behavior on Layout.preferredHeight{
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }

                CustomText{
                    id: bodyText
                    width: parent.width
                    size: 12
                    content: modelData.body
                    wrapMode: notif.isExtended ? Text.WordWrap : Text.NoWrap
                    color: Colors.outline
                }
            }
        }

        Rectangle{
            Layout.preferredWidth: 20
            Layout.preferredHeight: 20
            radius: height
            color: Colors.surface

            transform: Translate {
                y: notif.isExtended ? -notifRow.implicitHeight / 2 + 10 : 0


                Behavior on y {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
            }
            

            CustomIconImage{
                icon: "down"
                size: 16
                rotation: notif.isExtended ? 180 : 0
                anchors.centerIn: parent

                Behavior on rotation{
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.OutQuad
                    }
                }
            }

            MouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    notif.isExtended = !notif.isExtended
                }
            }
        }
    }

}
