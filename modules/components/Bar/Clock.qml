import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: clock
    implicitWidth: container.width
    anchors.horizontalCenter: parent.horizontalCenter
    property alias container: container


    Rectangle{
        id: container
        property bool isClicked : false
        implicitWidth: isClicked ? 400 : clockText.width + 30
        implicitHeight: isClicked ? 400 : 40 
        anchors.horizontalCenter: parent.horizontalCenter
        color: Settings.layoutColor
        bottomRightRadius: 20
        bottomLeftRadius: 20

        Behavior on implicitWidth{
            NumberAnimation{
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

         Behavior on implicitHeight{
            NumberAnimation{
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        RowLayout{
            id: clockText
            anchors.centerIn: parent
            CustomText{
                size: 18
                weight: 800
                content: ServiceClock.time
            }

            

            CustomText{
                size: 18
                content: ServiceClock.day
            }

            CustomText{
                size: 18
                content: ServiceClock.date
            }
        }


        MouseArea{
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked:{
                container.isClicked = !container.isClicked 
            }
        }
    }
}
