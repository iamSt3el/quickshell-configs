import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents

Item{
    id: root
    property int val
    property int inc: 10
    property int limit: 100
    RowLayout{
        anchors.fill: parent
        spacing: 10
        Rectangle{
            implicitWidth: 40
            implicitHeight: 30
            color: Colors.tertiary
            radius: 10
            MaterialIconSymbol{
                anchors.centerIn: parent
                content: "remove"
                iconSize: 20
                color: Colors.tertiaryText
            }

            CustomMouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    if(root.val > 0){
                        root.val -= root.inc
                    }
                }
            }
        }

        CustomText{
            content:root.val 
            size: 16
        }
        Rectangle{
            implicitWidth: 40
            implicitHeight: 30
            color: Colors.tertiary
            radius: 10

            MaterialIconSymbol{
                anchors.centerIn: parent
                content: "add"
                iconSize: 20
                color: Colors.tertiaryText
            }

            CustomMouseArea{
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked:{
                    if(root.val < root.limit){
                        root.val += root.inc
                    }
                }
            }
        }
    }
}
