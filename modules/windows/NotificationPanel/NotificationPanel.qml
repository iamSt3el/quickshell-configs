import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland
import qs.modules.util
import qs.modules.services
import qs.modules.components

PanelWindow{
    id: notifPanel
    implicitHeight: 1040
    implicitWidth: 240
    color: "transparent"

    property var screen

    
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal 
    anchors{
        bottom: true
        right: true
    }

    mask: Region{item: maskRect; intersection: Intersection.Xor}

    Rectangle{
        id: maskRect
        implicitWidth: parent.width
        implicitHeight: parent.height - wrapper.height
        color: "transparent"
        anchors{
            bottom: parent.bottom
        }
    }


    readonly property var notifications: ServiceNotification.popups
    readonly property int notificationCount: notifications.length
    property bool isNotifVisible: false
    property int displayedCount: notificationCount
    property int contentHeight: {
        if (displayedCount === 0) return 0
        
        let height = 60 // First item (no spacing)
        for (let i = 1; i < displayedCount; i++) {
            height += 65 // Subsequent items (80 + 5 spacing)
        }
        return height + 25 // container padding
    }
    
    Timer {
        id: heightUpdateTimer
        interval: 400
        onTriggered: displayedCount = notificationCount
    }
    
    Timer {
        id: openTimer
        interval: 10
        onTriggered: open()
    }

    Timer {
        id: closeCheckTimer
        interval: 300
        onTriggered: {
            if (notifications.length === 0 && isNotifVisible) {
                close()
            }
        }
    }
    
    onNotificationCountChanged: {
        if (notificationCount < displayedCount) {
            // Items removed - delay height update
            heightUpdateTimer.restart()
            if (notificationCount === 0) {
                closeCheckTimer.restart()
            }
        } else {
            // Items added - update immediately
            displayedCount = notificationCount
            if (notificationCount > 0 && !isNotifVisible) {
                openTimer.start()
            }
        }
    }

    Item{
        id: wrapper
        width: parent.width
        height: contentHeight
        transform: Scale{
            id: scaleTransform
            origin.x: wrapper.width / 2
            origin.y: 0
            yScale: 0
        }
        
        Behavior on height{
            NumberAnimation{
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        Shape{
            visible: notificationCount > 0 
            preferredRendererType: Shape.CurveRenderer
            ShapePath{
                fillColor: Colors.surfaceContainer
                strokeWidth: 0
                startX: 0
                startY: 0

                PathArc{
                    relativeX: Dimensions.position.x
                    relativeY: Dimensions.position.x
                    radiusX: Dimensions.radius.large
                    radiusY: Dimensions.radius.medium
                }
                PathLine{
                    relativeX: notificationWrapper.width - 20
                    relativeY: 0
                }

                PathLine{
                    relativeX: 0
                    relativeY: notificationWrapper.height - 20
                }

                PathArc{
                    relativeX: Dimensions.position.x
                    relativeY: Dimensions.position.y
                    radiusX: Dimensions.radius.large
                    radiusY: Dimensions.radius.medium
                }
                PathLine{
                    relativeX: 0
                    relativeY: -notificationWrapper.height - 20
                }
            }
        }

        Rectangle{
            id: notificationWrapper
            implicitWidth: parent.width - 20
            implicitHeight: parent.height - 20
            color: Colors.surfaceContainer
            bottomLeftRadius: 20
            anchors{
                right: parent.right
                top: parent.top
            }

            ListView{
                id: list
                model: ScriptModel{
                    values: [...notifications].reverse()
                }

                anchors.fill: parent
                orientation: Qt.Vertical
                    
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

                delegate: Item {
                    id: itemWrapper
                    width: list.width
                    height: notifContent.height + (index === 0 ? 0 : 5)
                    
                    property int idx: index

                    ListView.onRemove: removeAnimation.start()

                    SequentialAnimation {
                        id: removeAnimation

                        PropertyAction {
                            target: itemWrapper
                            property: "ListView.delayRemove"
                            value: true
                        }
                        PropertyAction {
                            target: itemWrapper
                            property: "enabled"
                            value: false
                        }
                        PropertyAction {
                            target: itemWrapper
                            property: "height"
                            value: 0
                        }
                        NumberAnimation {
                            target: notifContent
                            property: "x"
                            from: 0
                            to: list.width
                            duration: 350
                            easing.type: Easing.InQuad
                        }
                        PropertyAction {
                            target: itemWrapper
                            property: "ListView.delayRemove"
                            value: false
                        }
                    }

                    NotificationContent {
                        id: notifContent
                        anchors.top: parent.top
                        anchors.topMargin: itemWrapper.idx === 0 ? 0 : 5
                    }
                }
            }
        }
    }
    
    ParallelAnimation{
        id: openAnimation

        NumberAnimation{
            target: wrapper
            property: "y"
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
            easing.overshoot: 1.1
        }

        NumberAnimation{
            target: scaleTransform
            property: "yScale"
            to: 1.0
            duration: 300
            easing.type: Easing.OutCubic
        }
    } 
    
    ParallelAnimation{
        id: closeAnimation

        NumberAnimation{
            target: wrapper
            property: "y"
            to: -30
            duration: 200
            easing.type: Easing.InCubic
        }

        NumberAnimation{
            target: scaleTransform
            property: "yScale"
            to: 0
            duration: 200
            easing.type: Easing.InCubic
            easing.overshoot: 1.1
        }

        onFinished:{
            isNotifVisible = false
        }
    }
    
    function open(){
        isNotifVisible = true
        openAnimation.start()
    }

    function close(){
        closeAnimation.start()
    }
}
