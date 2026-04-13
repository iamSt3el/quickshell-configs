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
    radius: 20
    color: sArea.containsMouse ? Colors.primary : Colors.surfaceContainerHighest
    Behavior on color{
        ColorAnimation{
            duration: 200
        }
    }
    Behavior on scale{
        NumberAnimation{
            duration: 100
        }
    }
    MaterialIconSymbol{
        anchors.centerIn: parent
        content: root.icon
        iconSize: root.iconSize
        color: sArea.containsMouse ? Colors.primaryText : Colors.surfaceText
    }

    CustomMouseArea{
        id: sArea
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked:{
            ServiceMusic.togglePlaying()
        }
    }
}
