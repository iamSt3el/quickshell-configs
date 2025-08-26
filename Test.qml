import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Wayland

Item{
    PanelWindow{
        implicitWidth: 300
        implicitHeight: 300
        WlrLayershell.layer: WlrLayer.Overlay
        //:exclusionMode: ExclusionMode.Normal
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        TextInput{
            anchors.fill: parent
            text: "hello"
        }

    }
}
