import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Shapes

Item{
    id: utilityPopUpItem
    property bool isUtilityPopUpVisible: false
    property var utility: null
    property alias utilityCloseTimer: utilityCloseTimer

    Timer{
        id: utilityCloseTimer
        interval: 300
        onTriggered:{
            close()
        }
         
    }

    PopupWindow{
        id: utilityPopupWrapper
        anchor.window: topBar
        implicitWidth: 180
        implicitHeight: 110
        color: "transparent"
        visible: isUtilityPopUpVisible

        anchor{
            rect.x: {
                if (utility) {
                    let value = utility.mapToItem(utilityRect, -30, 0)
                    return utilityRectItem.x - utilityRect.width + value.x / 2
                }
                return 0
            } 
            rect.y: utilityRect.height 
        }

        Behavior on anchor.rect.x{
            NumberAnimation{duration: 100; easing.type: Easing.OutCubic}
        }
        Rectangle{
            id: animationRect
            anchors.fill: parent
            color: "transparent"
            
            transform: Scale{
                id: scaleTransform
                origin.x: animationRect.width / 2
                origin.y: 0
                yScale: 0
            }

            Shape{
                ShapePath{
                    fillColor: "#06070e"
                    //strokeColor: "blue"
                    strokeWidth: 0
                    startX: utilityPopupWrapper.x || 0 
                    startY: 0

                    PathArc{
                        relativeX: 20
                        relativeY: 10
                        radiusX: 20
                        radiusY: 15
                    }
                    PathLine{
                        relativeX: utilityPopupWrapper.width - 40
                        relativeY: 0
                    }

                    PathArc{
                        relativeX: 20
                        relativeY: -10
                        radiusX: 20
                        radiusY: 15
                    }
                }
            }

            Rectangle{
                id: utilityPopup
                implicitHeight: parent.height
                implicitWidth: parent.width - 40
                anchors.horizontalCenter: parent.horizontalCenter

                color: "#06070e"
                bottomLeftRadius: 10
                bottomRightRadius: 10

            }
        }

        ParallelAnimation{
            id: openAnimation

            NumberAnimation{
                target: animationRect
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
            }

            NumberAnimation{
                target: scaleTransform
                property: "yScale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.1
            }
        }
         ParallelAnimation{
            id: closeAnimation

            NumberAnimation{
                target: animationRect
                property: "y"
                to: -30
                duration: 300
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
                isUtilityPopUpVisible = false
            }
        }
    }

    function open(){
        utilityCloseTimer.stop()
        isUtilityPopUpVisible = true
        openAnimation.start()
    }
    function close(){
        closeAnimation.start()
    }
    
}
