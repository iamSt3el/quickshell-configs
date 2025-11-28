import Quickshell
import QtQuick
import qs.modules.utils
import qs.modules.services
import qs.modules.settings

Item{
    id: appLauncher
    height: container.height
    width: container.width
    anchors.verticalCenter: parent.verticalCenter
    property bool isVisible: true
    visible: isVisible
    property alias container: container
    Rectangle{
        id: container
        property bool isClicked: false
        implicitWidth: isClicked ? 200 : 8
        implicitHeight: 400
        color: Settings.layoutColor
        //color: "transparent"
        anchors.verticalCenter: parent.verticalCenter
        topRightRadius: 20
        bottomRightRadius: 20
        Behavior on implicitWidth{
            NumberAnimation{
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        MouseArea{
            id: mouseArea
            cursorShape: Qt.PointingHandCursor
            anchors.fill: parent
            onClicked:{
                container.isClicked = !container.isClicked
            }
            
        } 
    }
}
