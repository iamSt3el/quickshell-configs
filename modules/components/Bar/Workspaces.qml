import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents
import Quickshell.Hyprland
import Quickshell.Widgets

Item{
    id: workspaces
    property alias container: container
    Rectangle{
        id: container
        property bool isClicked: false
        implicitWidth: workspacesRow.width + 20
        implicitHeight: 40
        color: Settings.layoutColor
        bottomRightRadius: 20 

        Rectangle{
            id: overlay
            anchors.fill: parent
            z: 1
            color: "transparent"
            focus: true
        }

        ListView{
            id: workspacesRow
            visible: !container.isClicked
            width: contentWidth
            height: parent.height
            orientation: Qt.Horizontal
            anchors.centerIn: parent
            spacing: 10
            model: 5
            interactive: false

            delegate: Rectangle{
                property var currentWorkspace: ServiceWorkspaces.getWorkspace((index + 1))
                anchors.verticalCenter: parent.verticalCenter
                implicitHeight: currentWorkspace ? 25 : 15
                implicitWidth: currentWorkspace ? Math.max(15, topLevels.appList.width) + 10 : 15
                radius: 10
                color: currentWorkspace ? currentWorkspace.active ? Colors.primary : Colors.inversePrimary : Colors.inversePrimary

                Behavior on implicitWidth{
                    NumberAnimation{
                        duration: 100
                        easing.type: Easing.OutQuad
                    }
                }

               TopLevels{
                    id: topLevels
                }


                MouseArea{
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.RightButton | Qt.LeftButton
                    onClicked: function(mouse){
                        if(mouse.button === Qt.LeftButton){
                            if(currentWorkspace){
                                currentWorkspace.activate()
                            }else{
                                Hyprland.dispatch(`workspace ${index + 1}`)
                            }
                        }else if(mouse.button === Qt.RightButton){
                        }
                    }
                }
            }
        }
    }
}
