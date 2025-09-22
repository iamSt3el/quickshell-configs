import Quickshell
import QtQuick
import qs.modules.components
import qs.modules.util
import qs.modules.services


StyledRect{
    anchors.verticalCenter: parent.verticalCenter
    implicitHeight: 25
    implicitWidth: Math.max(70, row.width + 10)
    
    Row{
        id: row
        anchors.centerIn: parent
        spacing: 10

        StyledText{
            content: ServiceNetworkSpeed.downloadSpeedText
            size: 14
            weight: 100
        }
    }

}
