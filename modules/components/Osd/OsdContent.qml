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
    color: Settings.layoutColor
    radius: 20


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
        anchors.margins: 10
        anchors.fill: parent
        spacing: 10       
        MaterialIconSymbol{
            content: ServicePipewire.muted ? "volume_off" :"volume_up"
            iconSize: Appearance.size.iconSizeNormal
        }
        CustomSliderNew{
            id: slider
            Layout.preferredHeight: 10
            Layout.fillWidth: true
            interactive: false
            progress: Math.min(ServicePipewire.sink?.audio?.volume, 1)
        }

    }
}
