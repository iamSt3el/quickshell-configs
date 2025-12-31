import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.customComponents

Rectangle{
    anchors.bottom: parent.bottom
    implicitWidth: dockRow.implicitWidth + 20
    implicitHeight: dockHover.hovered ? 60 : 8
    color: Settings.layoutColor
    topLeftRadius: 20
    topRightRadius: 20
    Behavior on implicitHeight{
        NumberAnimation{
            duration: 300
            easing.type: Easing.OutQuad
        }
    }

    RowLayout{
        id: dockRow
        anchors.fill: parent
        spacing: 10
        anchors.margins: 10
        Repeater{
            model: ToplevelManager.toplevels
            delegate: Rectangle{
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                radius: 10
                color: Colors.surfaceContainerHigh

                Image{
                    anchors.centerIn: parent
                    source: Quickshell.iconPath(DesktopEntries.heuristicLookup(modelData.appId)?.icon, "image-missing")
                    width: 22
                    height: 22
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea{
                    id: dockIconArea
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:{
                        modelData.activate()
                    }
                }

                CustomToolTip{
                    content: modelData.appId
                    visible: dockIconArea.containsMouse
                }
            }
        }
    }
}
