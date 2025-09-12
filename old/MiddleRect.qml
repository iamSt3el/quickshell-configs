import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import QtQuick.Effects
import qs.util
import qs.components

Item{
    id: middleItem
    implicitWidth: middleRectWrapper.width
    anchors{
         horizontalCenter: parent.horizontalCenter
     }

     Timer{
         id: middleTimer
         interval: 300
         onTriggered: {
             clockWrapper.implicitWidth = clockWidth
         }
     }
    
    Colors {
        id: colors
    }
    
    // Use structured dimensions instead of hardcoded values
    readonly property int clockWidth: 220
    readonly property int clockExpandedWidth: 720
    Item{
        id: middleRectWrapper
        width: clockWrapper.width + 20 
        height: 40
        anchors{
            horizontalCenter: parent.horizontalCenter
        }

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            blurMax: Dimensions.spacing.medium
            shadowColor: Qt.alpha(colors.shadow, 1)
        }
          
     
        
        Shape{
            preferredRendererType: Shape.CurveRenderer
            ShapePath{
                fillColor: colors.surfaceContainer
                //strokeColor: "blue"
                strokeWidth: 0

                startX: middleRectWrapper.x - 10 
                startY: 0

                PathArc{
                    relativeX: 20
                    relativeY: 10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: middleRectWrapper.x + middleRectWrapper.width - 20
                    relativeY: 0
                }

                PathArc{
                    relativeX: 20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }

            }
        }
        
 

        Dashboard{
            id: dashboardPanel
        }
        
        Rectangle{
            id: clockWrapper
            implicitWidth: clockWidth 
            implicitHeight: Dimensions.component.height + Dimensions.spacing.small
            color: colors.surfaceContainer
           
            //bottomRightRadius: calenderApp.calenderVisible ? 0 : 20
            //bottomLeftRadius: calenderApp.calenderVisible ? 0 : 20
            bottomLeftRadius: Dimensions.radius.large
            bottomRightRadius: Dimensions.radius.large

            Behavior on implicitWidth{
                NumberAnimation{
                    duration: 200;
                    easing.type: Easing.OutQuad
                }
            }
     

            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            FontLoader{
                id: nothingFonts
                source: "./fonts/PkgTTF-Iosevka-33.2.9/Iosevka-Bold.ttf"
                //source: "./fonts/nothing-font-5x7.ttf/nothing-font-5x7.ttf"
            }

         

            SystemClock{
                id: clock
                precision: SystemClock.Seconds
            }

            StyledText {
                visible: parent.width === clockWidth
                anchors.centerIn: parent
                content: Qt.formatDateTime(clock.date, "hh:mm AP ddd dd")
                textVariant: "heading"
                colorVariant: "surfaceText"
                font.family: nothingFonts.name
                font.weight: Typography.weight.bold
            }

            MouseArea{
                id: calenderArea
                hoverEnabled: true
                anchors{
                    fill: parent
                } 

                onClicked:{
                    var value = clockWrapper.implicitWidth
                    if(value != clockExpandedWidth){ 
                        middleTimer.stop()
                        value = clockExpandedWidth
                    }
                    else middleTimer.start()

                    clockWrapper.implicitWidth = value

                    if(dashboardPanel.isDashboardVisible){
                        dashboardPanel.close()
                    }else{
                        dashboardPanel.aliasTimer.start()
                    }
                }
            }          
        }
    }
}
