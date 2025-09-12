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



    Shape{
            preferredRendererType: Shape.CurveRenderer
            
            // Inner shadow effect for shape
     
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
         property bool isDashboard: false
        id: clockWrapper
        implicitWidth: isDashboard ? 600 : clockText.width + 20
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
            visible: !clockWrapper.isDashboard
            id: clockText
            anchors.centerIn: parent
            content: ServiceClock.date
            size: Typography.size.subtitle
            weight: Typography.weight.bold
            
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


    MouseArea{
        id: clockArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked:{
            clockWrapper.isDashboard = !clockWrapper.isDashboard
        }
    }



}
