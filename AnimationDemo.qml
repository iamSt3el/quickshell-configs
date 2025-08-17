import Quickshell
import QtQuick
import Quickshell.Wayland


Item{
    PanelWindow{
        id: panel
        implicitWidth: 200
        implicitHeight: 20

        Behavior on implicitHeight{
            NumberAnimation{
                duration: 90; 
                easing.type: Easing.OutCirc
            }
        }

        WlrLayershell.layer: WlrLayer.Overlay
        exclusionMode: ExclusionMode.Normal

        anchors{
            top: true
            right: true
        }

        MouseArea{
            id: area
            hoverEnabled: true
            anchors{
                fill: parent
            }

            onClicked:{
                if(panel.implicitHeight != 200){
                    panel.implicitHeight = 200
                }else{
                    panel.implicitHeight =  20
                }
                
            }
        }

        Rectangle{
            anchors.fill: parent
            color: "black"
        }
    }
}
