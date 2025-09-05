import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import qs.util
import QtQuick.Effects

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
             clockWrapper.implicitWidth = 220
         }
     }
    
    Colors {
        id: colors
    }
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
          blurMax: 15
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
        
        /*CalenderApp{
            id: calenderApp
        }*/

        Dashboard{
            id: dashboardPanel
        }
        
        Rectangle{
            id: clockWrapper
            implicitWidth: 220 
            implicitHeight: 40
            color: colors.surfaceContainer
           
            //bottomRightRadius: calenderApp.calenderVisible ? 0 : 20
            //bottomLeftRadius: calenderApp.calenderVisible ? 0 : 20
            bottomLeftRadius: 20
            bottomRightRadius: 20

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

            Text{
                visible: parent.width === 220
                anchors{
                    centerIn: parent
                }
                color: colors.surfaceText
                text: Qt.formatDateTime(clock.date, "hh:mm AP ddd dd")
                font.family: nothingFonts.name
                font.weight: 600
                font.pixelSize: 24
            }

            MouseArea{
                id: calenderArea
                hoverEnabled: true
                anchors{
                    fill: parent
                } 

                onClicked:{
                    var value = clockWrapper.implicitWidth
                    if(value !=720){ 
                        middleTimer.stop()
                        value = 720
                    }
                    else middleTimer.start()

                    clockWrapper.implicitWidth = value

                    if(dashboardPanel.isDashboardVisible){
                        dashboardPanel.close()
                    }else{
                        dashboardPanel.aliasTimer.start()
                    }
                }


               /* onClicked:{
                    if(!calenderApp.calenderVisible){
                        calenderApp.open()
                    }else{
                        calenderApp.close()
                    }
                }
                */
            }
            
        }
    }
}
