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

    // Get monitor-specific workspaces
    property var assignedWorkspaces: Settings.getWorkspacesForMonitor(Hyprland.monitorFor(layout.screen).name)
    property var otherScreenWorkspaces: Settings.getOtherScreenWorkspaces(Hyprland.monitorFor(layout.screen).name)

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

        Row {
            visible: !container.isClicked
            anchors.centerIn: parent
            spacing: 10

            ListView{
                id: workspacesRow
                width: contentWidth
                height: container.height
                orientation: Qt.Horizontal
                spacing: 10
                model: workspaces.assignedWorkspaces
                interactive: false

                delegate: Rectangle{
                    property int workspaceId: modelData
                    property var currentWorkspace: ServiceWorkspaces.getWorkspace(workspaceId)
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: currentWorkspace ? 25 : 15
                    implicitWidth: currentWorkspace ? Math.max(15, topLevels.appList.width) + 10 : 15
                    radius: 10
                    color: currentWorkspace ? currentWorkspace.active ? Colors.primary : Colors.surfaceContainer : Colors.surfaceContainer
                    border{
                        width: 1
                        color: Qt.alpha(Colors.outline, 0.5)
                    }

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
                                    Hyprland.dispatch(`workspace ${workspaceId}`)
                                }
                            }else if(mouse.button === Qt.RightButton){
                            }
                        }
                    }
                }
            }

            
        }
    }
}
