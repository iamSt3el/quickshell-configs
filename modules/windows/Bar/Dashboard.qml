import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import qs.modules.services
import Quickshell.Widgets

PopupWindow{

    id: dashboard
    property bool isDashboardVisible: false
    visible: isDashboardVisible
    implicitWidth: wrapper.width + 20
    implicitHeight: 400 + 20
    color: "transparent"
    anchor{
        window: bar
        rect.x: wrapper.x
        rect.y: 20
    }

    signal closeFinished()

    Item{
        id: dashboardWrapper
        anchors.fill: parent

        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }

        transform: Scale{
            id: scaleTransform
            origin.x: dashboardWrapper.width / 2
            origin.y: 0
            yScale: 0
        }

        Rectangle{
            implicitHeight: parent.height - 20
            implicitWidth: parent.width - 20
            anchors.top: parent.top
            anchors.verticalCenter: parent.verticalCenter
            color: Colors.surfaceContainer
            bottomLeftRadius: 20
            bottomRightRadius: 20

            Row{
                width: parent.width - 20
                height: parent.height
                spacing: 8

                anchors.centerIn: parent

                DashboardOptions{}

                Rectangle{
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: parent.height - 20
                    implicitWidth: 2
                    color: Colors.surfaceVariant
                
                }

                DashboardNotifications{}

            }
        }
    }

    ParallelAnimation{
        id: openAnimation

        NumberAnimation{
            target: dashboardWrapper
            property: "y"
            to: 0
            duration: 300
            easing.type: Easing.OutQuad
            easing.overshoot: 1.2
        }

        NumberAnimation{
            target: scaleTransform
            property: "yScale"
            to: 1.0
            duration: 300
            easing.type: Easing.OutQuad
            easing.overshoot: 1.1
        }
    }

    ParallelAnimation{
        id: closeAnimation

        NumberAnimation{
            target: dashboardWrapper
            property: "y"
            to: 0
            duration: 300
            easing.type: Easing.InQuad
        }
        NumberAnimation{
            target: scaleTransform
            property: "yScale"
            to: 0
            duration: 300
            easing.type: Easing.InQuad
        }

        onFinished:{
            isDashboardVisible = false
            dashboardWrapper.y = 0
            scaleTransform.yScale = 0
            closeFinished()
        }
    }

    function open(){
        isDashboardVisible = true
        openAnimation.start()
    }

    function close(){
        closeAnimation.start()
    }
}
