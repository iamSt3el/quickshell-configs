import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Hyprland

Item{
    anchors{
        right: parent.right
    }
    Rectangle{
        id: utilityRectWrapper
        implicitWidth: 260
        implicitHeight: 50
        color: "transparent"
        anchors{
            right: parent.right
        }

        Rectangle{
            implicitWidth: 250
            implicitHeight: 40
            color: "#06070e"
            bottomLeftRadius: 20
            anchors{
                right: parent.right
            }

        }
    
       Shape{
            ShapePath{
                fillColor: "#06070e"
                //strokeColor: "blue"
                strokeWidth: 0
                startX: utilityRectWrapper.width
                startY: utilityRectWrapper.height

                PathArc{
                    relativeX: -20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: -(utilityRectWrapper.width - 30) 
                    relativeY: -(utilityRectWrapper.height - 20)
                }
                

                PathArc{
                    relativeX: -20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    direction: PathArc.Counterclockwise
                }
                
                PathLine{
                    relativeX: utilityRectWrapper.width + 10
                    relativeY: 0

                }
            }
        }
    }
}
