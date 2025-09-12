import Quickshell
import QtQuick
import qs.modules.components
import Quickshell.Widgets
import qs.modules.util
import QtQuick.Effects

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
            
            color: "transparent"

            Image{
                id: wifiIcon
                anchors.centerIn: parent
                //implicitSize: Dimensions.icon.normal
                width: Dimensions.icon.normal
                height: Dimensions.icon.normal
                sourceSize: Qt.size(width, height)

                source: IconUtils.getSystemIcon("wifi")
                cache: true
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: wifiArea.containsMouse ? Colors.primary : Colors.surfaceText
                    brightness: 1
                    
                    Behavior on colorizationColor {
                        ColorAnimation { duration: Dimensions.animation.fast }
                    }
                }
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
            
            color: "transparent"

            Image{
                id: btIcon
                anchors.centerIn: parent
                //implicitSize: Dimensions.icon.normal
                width: Dimensions.icon.normal
                height: Dimensions.icon.normal
                sourceSize: Qt.size(width, height)
                cache: true

                source: IconUtils.getSystemIcon("bluetooth")
                
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: btArea.containsMouse ? Colors.primary : Colors.surfaceText
                    brightness: 1
                    
                    Behavior on colorizationColor {
                        ColorAnimation { duration: Dimensions.animation.fast }
                    }
                }
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
            
            color: "transparent"

            Image{
                id: notificationIcon
                anchors.centerIn: parent
                //implicitSize: Dimensions.icon.normal
                source: IconUtils.getSystemIcon("notification")

                width: Dimensions.icon.normal
                height: Dimensions.icon.normal
                sourceSize: Qt.size(width, height)
                cache: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor:  Colors.surfaceText
                    brightness: 1
                    
                    Behavior on colorizationColor {
                        ColorAnimation { duration: Dimensions.animation.fast }
                    }
                }
            }
        }

         Rectangle{
            id: power
            implicitWidth: Dimensions.component.width
            implicitHeight: Dimensions.component.height
            
            color: "transparent"

            Image{
                id: powerIcon
                anchors.centerIn: parent
                //implicitSize: Dimensions.icon.normal
                source: IconUtils.getSystemIcon("shutdown")
                cache: true
                width: Dimensions.icon.normal
                height: Dimensions.icon.normal
                sourceSize: Qt.size(width, height)

                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Colors.error
                    brightness: 1
                    
                    Behavior on colorizationColor {
                        ColorAnimation { duration: Dimensions.animation.fast }
                    }
                }
            }
        }
    }

}
