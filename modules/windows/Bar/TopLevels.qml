import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.components
import qs.modules.services
import Quickshell.Widgets

Item{
    anchors.fill: parent
    Rectangle{
        x: -5
        y: 10
        implicitHeight: 20
        implicitWidth: 20
        color: Colors.tertiaryContainer
        radius: 30
    
        StyledText{
            anchors.centerIn: parent
            content: modelData.id
            color: Colors.tertiaryContainerText
            size: 12
        }
    }

    ListView{
        id: appList
        width: parent.width
        height: parent.height - 5
        orientation: Qt.Horizontal
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 15
        spacing: 5

        add: Transition{
            ParallelAnimation{
                NumberAnimation{
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.OutBack
                }
                NumberAnimation{
                    property: "scale"
                    from: 0
                    to: 1.0
                    duration: 300
                    easing.type: Easing.OutBack
                }
            }
        }

        model: modelData.toplevels

        delegate: Item{
            height: 20
            width: 20
            Component.onCompleted:{
                ServiceWorkspace.refreshToplevels()               
            }
            IconImage{
                anchors.centerIn: parent
                implicitSize: 20
                source: modelData && modelData.lastIpcObject ? IconUtils.getIconPath(modelData.lastIpcObject.class) : ""
            }
        }
    }   
}
