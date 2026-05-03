import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle{
    id: root
    property string icon
    property int iconSize
    property string iconColor: Colors.surfaceText
    property string iconHoverColor: Colors.primaryText
    radius: 20
    color: sArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
    signal clicked
    Behavior on color{
        ColorAnimation{
            duration: 200
        }
    }
 
    MaterialIconSymbol{
        anchors.centerIn: parent
        content: root.icon
        iconSize: root.iconSize
        color: sArea.containsMouse ? root.iconHoverColor : root.iconColor
    }

    MouseArea{
        id: sArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
