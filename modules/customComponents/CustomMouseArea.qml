import Quickshell
import QtQuick


MouseArea{
    anchors.fill: parent
    onPressed:{
        parent.scale = 0.8
    } 
    onReleased:{
        parent.scale = 1
    }
}
