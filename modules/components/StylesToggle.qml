import Quickshell
import QtQuick
import qs.modules.util


Item{
    id: root
    property bool isToggleOn: true
    Rectangle{
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        implicitWidth: 40
        implicitHeight: 20
        color: toggleButton.x === 20 ? Colors.primary : Colors.surfaceContainerLowest
        radius: 10

        Behavior on color{
            ColorAnimation {
                duration: 100
            }
        }

        Rectangle{
            id: toggleButton
            implicitWidth: 20
            implicitHeight: parent.height
            radius: 20
            x: root.isToggleOn ? 20 : 0

            Behavior on x{
                NumberAnimation{
                    duration: 200;
                    easing.type: Easing.OutQuad
                }
            }

            MouseArea{
                id: toggleButtonArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked:{
                    if(root.isToggleOn){
                        root.isToggleOn = false
                        Quickshell.execDetached(["bluetoothctl", "power", "off"])
                    }else{
                        root.isToggleOn = true
                        Quickshell.execDetached(["bluetoothctl", "power", "on"])
                    }
                }
            }
        }

    }
}
