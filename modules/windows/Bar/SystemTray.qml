import Quickshell
import Quickshell.Io
import QtQuick
import qs.modules.util
import qs.modules.components
import qs.modules.services
import Quickshell.Widgets

StyledRect{
    id: sysTrayWrapper
    implicitWidth: sysTrayRow.width + 10
    implicitHeight: Dimensions.component.height
    

    Row{
        id: sysTrayRow
        height: parent.height
        anchors.centerIn: parent

        Repeater{
            model: ServiceSystemTray.items

            delegate: Item{
                id: sysTrayIcon
                width: 25
                height: 25

                IconImage{
                    anchors.centerIn: parent
                    implicitSize: 20
                    source: modelData.icon
                }

                MouseArea{
                    id: iconArea
                    anchors.fill: parent
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    cursorShape: Qt.PointingHandCursor

                    onClicked: function(mouse){
                        if(mouse.button === Qt.RightButton && modelData.hasMenu){
                            modelData.display(bar, wrapper.x, wrapper.height)
                        }
                        if(mouse.button === Qt.LeftButton){
                            modelData.activate()
                        }
                    }
                }
            }
        }
    }
}
