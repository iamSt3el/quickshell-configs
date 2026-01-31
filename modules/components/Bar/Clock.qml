import Quickshell
import Quickshell.Hyprland
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
        property bool isClicked:hoverHandler.hovered
        implicitWidth: clockText.width + 20
        implicitHeight: Appearance.size.clockHeight
        anchors.horizontalCenter: parent.horizontalCenter
        color: Settings.layoutColor
        bottomRightRadius: Appearance.radius.extraLarge
        bottomLeftRadius: Appearance.radius.extraLarge

        onIsClickedChanged:{
            if(isClicked){
                container.implicitWidth = Appearance.size.calanderWidth
                container.implicitHeight = Appearance.size.calanderHeight
            }else{
                container.implicitWidth = clockText.width + 30
                container.implicitHeight = Appearance.size.clockHeight
            }
        }


        HoverHandler{
            id: hoverHandler
        }

        Behavior on implicitWidth{
            NumberAnimation{
                duration: Appearance.duration.large
                easing.type: Easing.OutQuad
            }
        }

        Behavior on implicitHeight{
            NumberAnimation{
                duration: Appearance.duration.large
                easing.type: Easing.OutQuad
            }
        }

        // RowLayout{
        //     id: clockText
        //     visible: container.height === 40
        //     anchors.centerIn: parent
        //     CustomText{
        //         size: 18
        //         weight: 600
        //         content: ServiceClock.time
        //     }
        //
        //     CustomText{
        //         size: 18
        //         weight: 600
        //         content: ServiceClock.day
        //     }
        //
        //     CustomText{
        //         size: 18
        //         weight: 600
        //         content: ServiceClock.date
        //     }
        // }
        CustomClock{
            id: clockText
            visible: container.height === 40
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
                interval: Appearance.duration.large
                running: container.isClicked
                onTriggered:{
                    calanderLoader.visible = true
                }
            }
            Timer{
                id: hideTimer
                interval: Appearance.duration.small
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
