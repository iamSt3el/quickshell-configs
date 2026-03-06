import Quickshell
import QtQuick


MouseArea{
    anchors.fill: parent
    onPressed:{
        parent.scale = 1
    } 
    onReleased:{
        parent.scale = 1
    }
}
