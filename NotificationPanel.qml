import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland

Item{

    readonly property var notifications: NotificationManager.popups
    property bool isNotifVisible: false
    property int displayedCount: notifications.length
    property int contentHeight: Math.max(90, displayedCount * 90 + 15)

    Timer {
        id: openTimer
        interval: 10
        onTriggered: open()
    }

    Timer {
        id: closeCheckTimer
        interval: 300  // After remove animation completes
        onTriggered: {
            if (notifications.length === 0 && isNotifVisible) {
                close()
            }
        }
    }

    Timer {
        id: removeCompleteTimer
        interval: 350  // Slightly longer than remove animation (300ms)
        onTriggered: {
            displayedCount = notifications.length
        }
    }

    onNotificationsChanged: {
        console.log("length: " + displayedCount)
        if (notifications.length < displayedCount) {
            removeCompleteTimer.restart()
            if (notifications.length === 0) {
                closeCheckTimer.restart()
            }
        } else {
            displayedCount = notifications.length
            if (notifications.length > 0) {
                openTimer.start()
            }
        }
    }

    PopupWindow{
        id: notificationPanel
        anchor{
            window: topBar
            rect.x: utilityRectItem.x
            rect.y: utilityRect.height
            adjustment: PopupAdjustment.FlipX
        }

        implicitWidth: 280
        implicitHeight: 1200  // Fixed height - large enough for max notifications
        
        visible: isNotifVisible

        color: "transparent"
        
        mask: Region {
            x: 0
            y: 0
            width: 280
            height: contentHeight
        }

        Item{
            id: outerWrapper
            
            // Use contentHeight instead of parent height for smooth animations
            implicitHeight: contentHeight
            implicitWidth: 280
            
            // Animate the content height smoothly
            Behavior on implicitHeight {
                NumberAnimation { 
                    duration: 300
                    easing.type: Easing.OutCubic 
                }
            }
            

            transform: Scale{
                id: scaleTransform
                origin.x: outerWrapper.width / 2
                origin.y: 0
                yScale: 0
            }
            
            Shape{
                preferredRendererType: Shape.CurveRenderer
                width: outerWrapper.width
                height: outerWrapper.height

                ShapePath{
                    fillColor: "#11111b"
                    strokeWidth: 0
                    startX: 0
                    startY: 0

                    PathArc{
                        relativeX: 20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 15
                    }

                    PathLine{
                        relativeY: 0
                        relativeX: outerWrapper.width - 40
                    }

                    PathLine{
                        relativeX: 0
                        relativeY: outerWrapper.height - 40
                    }

                    PathArc{
                        relativeX: 20
                        relativeY: 20
                        radiusX: 20
                        radiusY: 15
                    }
                    PathLine{
                        relativeX: 0
                        relativeY: -outerWrapper.height
                    }
                }
            }
            
            Rectangle{
                id: innerWrapper
                anchors{
                    top: parent.top
                    right: parent.right
                }
                implicitWidth: parent.width - 20
                implicitHeight: parent.height - 20
                color: "#11111b"
                bottomLeftRadius: 20
                clip: true  // Ensure content doesn't overflow
                
               ListView{
                    id: list

                    model: ScriptModel{
                        values: [...notifications].reverse()
                    }

                    anchors.fill: parent
                    orientation: Qt.Vertical
                    spacing: 10

                    add: Transition {
                        NumberAnimation { 
                            property: "x"
                            from: parent ? parent.width : 280
                            to: 0
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }

                    remove: Transition{
                        PropertyAction { target: wrapper ; property: "ListView.delayRemove"; value: true }
                        PropertyAction {target: wrapper; property: "enabled"; value: false}
                        NumberAnimation{
                            property: "x"
                            from: 0
                            to: parent ? parent.width : 280
                            duration: 300
                            easing.type: Easing.InCubic
                        }
                        PropertyAction { target: wrapper; property: "ListView.delayRemove"; value: false}
                    }

                    addDisplaced: Transition{
                        NumberAnimation{
                            property: "y"
                            duration: 300
                            easing.type: Easing.OutCubic
                        }
                    }

                  

                    delegate: Item {
                            id: wrapper
                            width: list.width
                            height: 80

                        
    
                            Rectangle{
                                id: notificationRect
                                width: parent.width - 10
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: parent.height
                                radius: 10
                                color: "#585b70"
                                
                                Column{
                                    anchors.fill: parent
                                    Row{
                                        width: parent.width
                                        height: parent.height / 2
                                    
                                        Item{
                                            implicitWidth: parent.width / 4
                                            implicitHeight: parent.height

                                            Image{
                                                anchors.left: parent.left
                                                anchors.verticalCenter: parent.verticalCenter
                                                //anchors.centerIn: parent
                                                anchors.leftMargin: 10
                                                width: 30
                                                height: 30
                                                sourceSize: Qt.size(width, height)
                                                source: Quickshell.iconPath(modelData.appIcon) || modelData.image
                                            }
                                        }
                                        Item{
                                            implicitHeight: parent.height
                                            implicitWidth: parent.width - parent.width / 3

                                            Text{
                                                anchors.left: parent.left
                                                anchors.verticalCenter: parent.verticalCenter

                                                text: modelData.appName
                                                color: "white"
                                                font.pixelSize: 16
                                            }

                                        }

                                    }

                                    Item{
                                        implicitWidth: parent.width
                                        implicitHeight: parent.height / 2
                                        clip: true

                                        Text{
                                            anchors.left: parent.left
                                            anchors.leftMargin: 10

                                            text: modelData.summary
                                            color: "white"
                                            font.pixelSize: 14
                                        }
                                    }
                                }

                                MouseArea{
                                    id: notifArea
                                    hoverEnabled: true
                                    anchors.fill:parent
                                    onEntered:{
                                        modelData.timer.stop()
                                    }
                                    onExited:{
                                        modelData.timer.start()
                                    }
                                }
                            }
                    }
                }
            }
        }
        
        ParallelAnimation{
            id: openAnimation

            NumberAnimation{
                target: outerWrapper
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
                target: outerWrapper
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
    }

    function open(){
        isNotifVisible = true
        openAnimation.start()
    }

    function close(){
        closeAnimation.start()
    }
}
