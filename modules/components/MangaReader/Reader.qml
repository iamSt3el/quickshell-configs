import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents
import QtWebView


PanelWindow{
    id: panelWindow
    implicitWidth: 300
    implicitHeight: 600
    WlrLayershell.layer: WlrLayer.Top
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    //color: "transparent"



}
