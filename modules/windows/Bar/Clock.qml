import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.services
import qs.modules.components
import QtQuick.Effects

Item{
    id: wrapper
    width:clockWrapper.width
    height: parent.height
    anchors{
        horizontalCenter: parent.horizontalCenter
    }

    property bool isDashboard: false
    Shape{
        preferredRendererType: Shape.CurveRenderer
            
        ShapePath{
            fillColor: Colors.surfaceContainer
            strokeWidth: 0
            startX: clockWrapper.x - 20 
            startY: 0

            PathArc{
                relativeX: Dimensions.position.x
                relativeY: Dimensions.position.y 
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
            }

            PathLine{
                relativeX: clockWrapper.width 
                relativeY: 0
            }

            PathArc{
                relativeX: Dimensions.position.x
                relativeY: -Dimensions.position.y
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
            }
        }
    }
 
    Rectangle{
        id: clockWrapper
        property bool isClicked: false
        implicitWidth: isClicked ? 600 : clockText.width + 20
        implicitHeight: 40
        color:  Colors.surfaceContainer
        bottomLeftRadius: Dimensions.radius.large
        bottomRightRadius: Dimensions.radius.large

        anchors{
            horizontalCenter: parent.horizontalCenter
        }

        Behavior on implicitWidth{
            NumberAnimation{
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        StyledText{
            visible: !clockWrapper.isClicked
            id: clockText
            anchors.centerIn: parent
            content: ServiceClock.date
            size: Typography.size.title

            
            Behavior on visible{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.InCubic
                }
            }
        }
    }

         
    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 1.0
        shadowColor: Qt.alpha(Colors.shadow, 1)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }

    Loader{
        id: dashboardLoader
        active: wrapper.isDashboard

        sourceComponent: Component{
            Dashboard{
                id: dashboardComponent
                onCloseFinished: {
                    clockWrapper.isClicked = false
                    wrapper.isDashboard = false
                }
            }
        }
    }

    Timer{
        id: dashboardTimer
        interval: 300
        onTriggered:{
             wrapper.isDashboard = true
             if(dashboardLoader.item) {
                 dashboardLoader.item.open()
             }
        }
    }

    MouseArea{
        id: clockArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked:{
            if(!wrapper.isDashboard) {
                clockWrapper.isClicked = true
                dashboardTimer.start()
            } else {
                if(dashboardLoader.item) {
                    dashboardLoader.item.close()
                }
            }
        }
    }
}
