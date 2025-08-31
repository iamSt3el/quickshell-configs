import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland
import qs.util
import QtQuick.Controls


Item {
    PanelWindow {
        id: testpanel
        implicitWidth: 400
        implicitHeight: 200
        WlrLayershell.layer: WlrLayer.Overlay
        //visible: false
        color: "transparent"
   
        Colors {
            id: colors
        }
        
        Rectangle {
            anchors.fill: parent
            color: colors.surface
            radius: 10
            clip: true

            SwipeView{
                id: test
            
                interactive: true
                orientation: Qt.Horizontal
                currentIndex: 0
                width: parent.width - 10
                height: parent.height - 10
                anchors.centerIn: parent
            

                Item{
                    Rectangle{
                        anchors.centerIn: parent
                        implicitWidth: parent.width - 10
                        implicitHeight: parent.height - 10
                        color: "blue"
                        radius: 10

                        Text{
                            anchors.centerIn: parent
                            text: test.currentIndex
                        }
                    }
                }

                  Item{
                    Rectangle{
                        anchors.centerIn: parent
                        implicitWidth: parent.width - 10
                        implicitHeight: parent.height - 10
                        color: "blue"
                        radius: 10

                        Text{
                            anchors.centerIn: parent
                            text: test.currentIndex
                        }
                    }
                }

                  Item{
                    Rectangle{
                        anchors.centerIn: parent
                        implicitWidth: parent.width - 10
                        implicitHeight: parent.height - 10
                        color: "blue"
                        radius: 10

                        Text{
                            anchors.centerIn: parent
                            text: test.currentIndex
                        }
                    }
                }
            }

        }
    }
}
