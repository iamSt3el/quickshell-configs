import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes


Item{
    anchors{
        //centerIn: parent
        //verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
        top: parent.top
    }
    Rectangle{
        implicitWidth: 240
        implicitHeight: 40
        color: "red"
        
        Rectangle{
            implicitWidth: parent.width - 20
            implicitHeight: 30
            color: "#09070e"

        }
    }
}
