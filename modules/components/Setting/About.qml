import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    anchors.fill: parent
    anchors.margins: 5
    
    Flickable{
        anchors.fill: parent  
        contentHeight: column.implicitHeight
        contentWidth: width   
        clip: true
        
        ColumnLayout{
            id: column
            width: parent.width  
            spacing: 10          
            
            Item{
                Layout.preferredWidth: parent.width
                Layout.preferredHeight: 40

                Row{
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 20

                    IconImage {
                        implicitSize: 26
                        anchors.verticalCenter: parent.verticalCenter
                        source: IconUtil.getSystemIcon("about")
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Colors.primary
                            Behavior on colorizationColor{
                                ColorAnimation{
                                    duration: 200
                                }
                            }
                            brightness: 0
                        } 
                    }

                    CustomText{
                        content: "About"
                        anchors.verticalCenter: parent.verticalCenter
                        size: 20
                        color: Colors.primary

                    }
                }
            }
  
        }
    }
}


