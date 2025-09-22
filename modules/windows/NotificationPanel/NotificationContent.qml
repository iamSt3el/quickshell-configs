import Quickshell
import QtQuick
import qs.modules.util
import qs.modules.components
import Quickshell.Widgets
import QtQuick.Effects

Item{
    id: notifContentWrapper
    width: list.width
    height: 60

    Rectangle{
        id: notificationRect
        implicitWidth: parent.width - 10
        implicitHeight: parent.height
        anchors.centerIn: parent
        radius: 10
        clip: true

        // Urgency-based colors
        color: {
            if (!modelData) return Colors.surfaceVariant
            if (modelData.isCritical) return Colors.errorContainer
            return Colors.surfaceVariant
        }

        // Urgency border
        border.width: modelData?.isCritical ? 2 : 0
        border.color: modelData?.isCritical ? Colors.error : "transparent"

          Row{
            width: parent.width
            height: parent.height - 10

            Item{
                implicitWidth: 50
                implicitHeight: parent.height - 10

                Image{
                    anchors.centerIn: parent
                    width: 30
                    height: 30
                    source: IconUtils.getIconPath(modelData.appIcon)
                    sourceSize: Qt.size(width, height)
                }
            }

            Item{
                implicitWidth: parent.width - 40
                implicitHeight: parent.height - 10
                clip: true

                Column{
                    anchors.fill: parent
                    StyledText{
                        anchors.left: parent.left
                        anchors.horizontalCenter: parent.horizontalCenter
                        content: modelData.appName
                        size: 16
                        color: modelData?.isCritical ? Colors.errorContainerText : Colors.surfaceVariantText
                        font.family: Typography.primary
                        effect: false
                    }

                    StyledText{
                        anchors.left: parent.left
                         anchors.horizontalCenter: parent.horizontalCenter
                        content: modelData.summary
                        size: 14
                        color: modelData?.isCritical ? Colors.errorContainerText : Colors.surfaceVariantText
                        font.family: Typography.primary
                        effect: false
                    }
                }

                Item{
                    implicitWidth: 40
                    implicitHeight: 20
                    anchors{
                        top: parent.top
                        right: parent.right
                    }
                    MouseArea{
                        id: closeArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked:{
                            console.log("Clicked")
                            modelData.popup = false
                        }
                    }
                    Image{
                        width: 15
                        height: 15
                        anchors.centerIn: parent
                        source: IconUtils.getSystemIcon("close")

                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Colors.surfaceText
                            brightness: 1
                            Behavior on colorizationColor {
                                ColorAnimation { duration: Dimensions.animation.fast }
                            }
                        }
                    }

                }
            }


        }

        ClippingRectangle{
            implicitWidth: parent.width - 4
            implicitHeight: 10
            bottomLeftRadius: 10
            bottomRightRadius: 10
            color: "transparent"

            anchors{
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            Rectangle{
                implicitHeight: 5
                implicitWidth: parent.width * modelData.progress
                radius: 10
                color: "#a6d189"
                anchors{
                    bottom: parent.bottom
                    left: parent.left
                }

            }
        }
    } 
}
