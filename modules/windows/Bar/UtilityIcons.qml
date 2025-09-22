import Quickshell
import QtQuick
import qs.modules.components
import Quickshell.Widgets
import qs.modules.util
import QtQuick.Effects
import Quickshell.Widgets
import qs.modules.services

StyledRect{
    id: utilityIcons
    implicitHeight: Dimensions.component.height
    implicitWidth: iconsWrapper.width
    
    signal bluetoothClicked()

    anchors.verticalCenter: parent.verticalCenter

    Row{
        id: iconsWrapper
        height: parent.height

        Rectangle{
            id: wifi
            implicitWidth: Dimensions.component.width
            implicitHeight: Dimensions.component.height

            radius: 10

            color: wifiArea.containsMouse ? Colors.primary : "transparent"

            Behavior on color{
                ColorAnimation{duration: 100}
            }

            IconImage{
                implicitSize: Dimensions.icon.normal
                anchors.centerIn: parent
                source: IconUtils.getSystemIcon("wifi") 
            }

        
            MouseArea{
                id: wifiArea
                anchors.fill:parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    Quickshell.execDetached(["kitty", "--class", "nmtui-popup", "-e", "nmtui"])
                }
            }
        }

         Rectangle{
            id: bt
            implicitWidth: Dimensions.component.width
            implicitHeight: Dimensions.component.height
            radius: 10
            color: btArea.containsMouse ? Colors.primary : "transparent"    
            Behavior on color{
                ColorAnimation{duration: 100}
            }

            
            IconImage{
                implicitSize: Dimensions.icon.normal
                anchors.centerIn: parent
                source: IconUtils.getSystemIcon("bluetooth")
            }
            
            
            MouseArea{
                id: btArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: utilityIcons.bluetoothClicked()
            }
        }

         Rectangle{
            id: notification
            implicitWidth: Dimensions.component.width
            implicitHeight: Dimensions.component.height
            radius: 10
            color: notificationArea.containsMouse ? Colors.primary : "transparent"

            Rectangle{
                visible: ServiceNotification.notificationsNumber > 0
                anchors.right: parent.right
                implicitHeight: 15
                implicitWidth:  15
                color: Colors.errorContainer
                radius: implicitWidth
                z: 1

                StyledText{
                    id: text
                    anchors.centerIn: parent
                    content: ServiceNotification.notificationsNumber
                    color: Colors.errorContainerText
                    effect: false
                    size: 12
                }
            }

            Behavior on color{
                ColorAnimation{duration: 100}
            }

            IconImage{
                implicitSize: Dimensions.icon.normal
                anchors.centerIn: parent
                source: IconUtils.getSystemIcon(ServiceNotification.muted ? "notification-no" : "notification")
            }

            MouseArea{
                id: notificationArea
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                anchors.fill:parent
                onClicked: {
                    ServiceNotification.toggleMute()
                }
            }
        }

         Rectangle{
            id: power
            implicitWidth: Dimensions.component.width
            implicitHeight: Dimensions.component.height
            radius: 10
            color: powerArea.containsMouse ? Colors.primary : "transparent"
            
            Behavior on color{
                ColorAnimation{duration: 100}
            }

            IconImage{
                implicitSize: Dimensions.icon.normal
                anchors.centerIn: parent
                source: IconUtils.getSystemIcon("shutdown")
            }

            MouseArea{
                id: powerArea
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                anchors.fill:parent
            }
        }
    }

}
