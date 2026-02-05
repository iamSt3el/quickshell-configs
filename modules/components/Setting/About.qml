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
                    anchors.margins: 5
                    spacing: 10

                    MaterialIconSymbol{
                        content: "info"
                        iconSize: 20
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


