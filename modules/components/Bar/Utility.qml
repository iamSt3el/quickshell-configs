import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.modules.utils
import qs.modules.settings

Item{
    id: utility
    implicitWidth: container.width
    anchors.right: parent.right
    property alias container: container

    Rectangle{
        id: container
        implicitWidth: 200
        implicitHeight: 40
        anchors.right: parent.right
        color: Settings.layoutColor
        bottomLeftRadius: 20 
    }
}
