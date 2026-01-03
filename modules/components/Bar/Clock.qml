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
    implicitHeight: container.height
    anchors.horizontalCenter: parent.horizontalCenter
    property alias container: container


    Rectangle{
        id: container
        property bool isClicked : hoverHandler.hovered
        implicitWidth: isClicked ? 400 : clockText.width + 30
        implicitHeight: isClicked ? 400 : 40
        anchors.horizontalCenter: parent.horizontalCenter
        color: Settings.layoutColor
        bottomRightRadius: 20
        bottomLeftRadius: 20

        HoverHandler{
            id: hoverHandler
        }

        Behavior on implicitWidth{
            NumberAnimation{
                duration: 400
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
            visible: container.height === 40
            anchors.centerIn: parent
            CustomText{
                size: 18
                weight: 600
                content: ServiceClock.time
            }

            CustomText{
                size: 18
                weight: 600
                content: ServiceClock.day
            }

            CustomText{
                size: 18
                weight: 600
                content: ServiceClock.date
            }
        }

        Loader{
            id: calanderLoader
            active: container.isClicked
            anchors.fill: parent
            visible: false
            opacity: visible ? 1 : 0
            Behavior on opacity{
                NumberAnimation{
                    duration: 300
                }
            }
            Timer{
                id: showTimer
                interval: 400
                running: container.isClicked
                onTriggered:{
                    calanderLoader.visible = true
                }
            }
            Timer{
                id: hideTimer
                interval: 100
                running: !container.isClicked && calanderLoader.visible
                onTriggered:{
                    calanderLoader.visible = false
                }
            }
            sourceComponent: Calander{
                id: calander
            }
        }
    }
}
