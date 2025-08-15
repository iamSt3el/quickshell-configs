import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes


Item{
    id: middleItem
    implicitWidth: 240
    anchors{
         horizontalCenter: parent.horizontalCenter
    }
    Rectangle{
        id: middleRectWrapper
        implicitWidth: 240 
        implicitHeight: 40
        color: "transparent"
        anchors{
            horizontalCenter: parent.horizontalCenter
        }
        
        Shape{
            ShapePath{
                fillColor: "#06070e"
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
        
        CalenderApp{
            id: calenderApp
        }
        
        Rectangle{
            id: clockWrapper
            implicitWidth: parent.width - 20 
            implicitHeight: 40
            color: "#09070e"
           
            bottomRightRadius: calenderApp.calenderVisible ? 0 : 20
            bottomLeftRadius: calenderApp.calenderVisible ? 0 : 20
            
           /* Behavior on bottomRightRadius{
                NumberAnimation{duration: 300; easing.type:Easing.OutCubic}
            }

            Behavior on bottomLeftRadius{
                NumberAnimation{duration: 300; easing.type: Easing.OutCubic}
            }*/

            anchors{
                horizontalCenter: parent.horizontalCenter
            }

            FontLoader{
                id: nothingFonts
                source: "./fonts/nothing-font-5x7.ttf/nothing-font-5x7.ttf"
            }

            SystemClock{
                id: clock
                precision: SystemClock.Seconds
            }

            Text{
                anchors{
                    centerIn: parent
                }
                color: "white"
                text: Qt.formatDateTime(clock.date, "hh : mm AP  ddd dd")
                font.family: nothingFonts.name
                font.pixelSize: 22
            }

            MouseArea{
                id: calenderArea
                hoverEnabled: true
                anchors{
                    fill: parent
                }    


                onClicked:{
                    if(!calenderApp.calenderVisible){
                        calenderApp.open()
                    }else{
                        calenderApp.close()
                    }
                }
            }
            
        }
    }
}
