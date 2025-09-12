import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import qs.util
import Quickshell.Widgets
import QtQuick.Controls
Item{
    id: dashboardItem
    property bool isDashboardVisible: false
    property alias aliasTimer: timer
    
    Colors{
        id: colors
    }

    SystemMonitor{
        id: systemMonitor 
    }

    SystemInfo{
        id: sysInfo
    }

    Timer{
        id: timer
        interval: 200
        onTriggered:{
            open()
        }
    }
    
    PopupWindow{
        id: dashboardPanel
        anchor.window: topBar
        implicitWidth: middleRectWrapper.width - 20
        implicitHeight: 600
        color: "transparent"
        visible: isDashboardVisible

        anchor{
            rect.x: middleItem.x + middleRectWrapper.width / 2
            rect.y: middleRectWrapper.height - 20
            gravity: Edges.Bottom
        }
        
        Item{
            id: dashboardWrapper
            height: parent.height
            width: parent.width

            transform: Scale{
                id: scaleTransform
                origin.x: dashboardWrapper.width / 2
                origin.y: 0
                yScale: 0
            }


            Rectangle{
                implicitHeight: parent.height
                implicitWidth: parent.width

                Behavior on implicitHeight{
                    NumberAnimation{
                        duration: 200
                        easing.type: Easing.InQuad
                    }
                }

                bottomLeftRadius: 20
                bottomRightRadius: 20
                color: colors.surfaceContainer
                ClippingWrapperRectangle{ 
                    implicitHeight: parent.height - 10
                    implicitWidth: parent.width - 10
                    anchors.centerIn: parent
                    color: "transparent"
                    radius: 10
                    SwipeView{
                    id: swipeView
                    interactive: true
                    orientation: Qt.Horizontal
                    currentIndex: 0
                    width: parent.width
                    height: parent.height
                    anchors.centerIn: parent

                    onCurrentIndexChanged:{
                        var height = dashboardWrapper.height
                        if(height > 300){
                            height = 300
                        }else{
                            height = 600
                        }
                        dashboardWrapper.height = height
                    }
                    
                    DashboardSection_1{
                        //anchors.fill: parent
                        isDashboardVisible: dashboardItem.isDashboardVisible
                    }

                    DashboardSection_2{}
                }
            }
            }

        }

       
        ParallelAnimation{
            id: openAnimation

            NumberAnimation{
                target: dashboardWrapper
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutQuad
                easing.overshoot: 1.2
            }

            NumberAnimation{
                target: scaleTransform
                property: "yScale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutQuad
                easing.overshoot: 1.1
            }
        }

        ParallelAnimation{
            id: closeAnimation

            NumberAnimation{
                target: dashboardWrapper
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.InQuad
            }
            NumberAnimation{
                target: scaleTransform
                property: "yScale"
                to: 0
                duration: 300
                easing.type: Easing.InQuad
            }

            onFinished:{
                isDashboardVisible = false
                dashboardWrapper.y = 0
                scaleTransform.yScale = 0
            }
        }
    }
    function open(){
        isDashboardVisible = true
        openAnimation.start()
    }
    function close(){
        closeAnimation.start()
    }
}
