import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Shapes

Item{
    id: utilityPopUpItem
    property bool isUtilityPopUpVisible: false
    property var utility: null

    PopupWindow{
        id: utilityPopupWrapper
        anchor.window: topBar
        implicitWidth: 180
        implicitHeight: 110
        color: "transparent"
        visible: isUtilityPopUpVisible

        anchor{
            rect.x: {
                let value = utility.mapToItem(utilityRect, -30, 0)
                return utilityRectItem.x - utilityRect.width + value.x / 2} 
            rect.y: utilityRect.height 
        }

        Shape{
            ShapePath{
                fillColor: "#06070e"
                //strokeColor: "blue"
                strokeWidth: 0
                startX: utilityPopupWrapper.x 
                startY: 0

                PathArc{
                    relativeX: 20
                    relativeY: 10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
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
}
