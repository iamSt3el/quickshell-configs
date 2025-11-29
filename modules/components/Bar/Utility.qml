import Quickshell
import QtQuick
import QtQuick.Shapes
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    id: utility
    width: container.width
    height: container.height
    anchors.right: parent.right
    property alias container: container
    property bool isClicked: false

    Rectangle{
        id: container 
        implicitWidth: utility.isClicked ? 300 : row.width + 20
        implicitHeight: utility.isClicked ? 600 : 40
        anchors.right: parent.right
        color: Settings.layoutColor
        bottomLeftRadius: 20 

        Behavior on implicitHeight{
            NumberAnimation{
                duration: 200
                easing.type: Easing.OutQuad
            }
        }
        Behavior on implicitWidth{
            NumberAnimation{
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Loader{
            active: utility.isClicked
            anchors.fill: parent
            sourceComponent: Dashboard{
                
            }
        }
        
        Row{
            id: row
            visible: !utility.isClicked
            height: parent.height
            width: first.width + second.width + spacing
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 10
            spacing: 10
            Rectangle{
                id: first
                implicitHeight: 20
                implicitWidth: list.width + 8
                radius: 10
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                //color: Colors.inversePrimary

                ListView{
                    id: list
                    width: contentWidth
                    height: parent.height
                    orientation: Qt.Horizontal
                    anchors.centerIn: parent
                    model: ServiceUtility.utility
                    spacing: 10

                    delegate: Item{
                        width: 20
                        height: parent.height

                        IconImage{
                            anchors.centerIn: parent
                            implicitSize: 18
                            source: IconUtil.getSystemIcon(modelData.icon) 
                        }

                        MouseArea{
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked:{
                                utility.isClicked = true
                            }
                        }
                    }
                }
            }
            Rectangle{
                id: second
                implicitHeight: 20
                implicitWidth: 30
                radius:10
                anchors.verticalCenter: parent.verticalCenter
                //color: "transparent"
                color: Colors.surfaceText
              

                Rectangle{
                    implicitWidth: parent.width * ServiceUPower.powerLevel
                    implicitHeight: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    color: Colors.tertiary
                    radius: 6
                }

                CustomText{
                    anchors.centerIn: parent
                    content: ServiceUPower.powerLevel * 100
                    weight: 900
                    color: Settings.layoutColor
                }
            }
        }
    }
}
