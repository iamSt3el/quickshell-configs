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
    property bool showingSettings: false
    visible: isDashboardVisible
    implicitWidth: wrapper.width + 20
    implicitHeight: showingSettings ? 600 + 20 : 450 + 20


    color: "transparent"
    anchor{
        window: bar
        rect.x: wrapper.x
        rect.y: 20
    }

    signal closeFinished()

    Item{
        id: dashboardWrapper
        implicitWidth: parent.width
        implicitHeight: parent.height

        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }

            Behavior on implicitHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
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

            Column{
                anchors.fill: parent
                spacing: 0

                // Title bar with buttons
                Rectangle{
                    width: parent.width
                    height: 50
                    color: "transparent"

                    Row{
                        anchors.centerIn: parent
                        spacing: 10

                        Rectangle{
                            width: 100
                            height: 35
                            radius: 18
                            color: !showingSettings ? Colors.primary : Colors.surfaceVariant

                            StyledText{
                                anchors.centerIn: parent
                                content: "Dashboard"
                                size: 14
                                color: !showingSettings ? Colors.primaryText : Colors.surfaceVariantText
                            }

                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: showingSettings = false
                            }
                        }

                        Rectangle{
                            width: 100
                            height: 35
                            radius: 18
                            color: showingSettings ? Colors.primary : Colors.surfaceVariant

                            StyledText{
                                anchors.centerIn: parent
                                content: "Settings"
                                size: 14
                                color: showingSettings ? Colors.primaryText : Colors.surfaceVariantText
                            }

                            MouseArea{
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: showingSettings = true
                            }
                        }
                    }
                }

                // Content area
                Item{
                    width: parent.width
                    height: parent.height - 50

                    // Dashboard content
                    Row{
                        visible: !showingSettings
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

                    // Settings content
                    DashboardSettings{
                        visible: showingSettings
                        anchors.fill: parent
                        anchors.margins: 10
                    }
                }
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
