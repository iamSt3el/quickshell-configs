import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle{
    id: child
    anchors.fill: parent 
    scale: 0.8
    opacity: 0
    radius: 20
    color: Settings.layoutColor

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 100
        running: true
    }

    NumberAnimation on scale{
        from: 0.8
        to: 1
        duration: 100
        running: true
    }


    RowLayout{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10
        MaterialIconSymbol{
            content: "volume_up"
            iconSize: Appearance.size.iconSizeNormal
        }
        CustomSliderNew{
            id: slider
            Layout.fillWidth: true
            Layout.preferredHeight: 10
            progress: Math.min(ServicePipewire.sink?.audio?.volume, 1)
        }
    }
}
