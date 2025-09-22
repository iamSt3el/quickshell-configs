import QtQuick
import Quickshell
import qs.modules.util

Item {
    id: appDelegate
    
    // These are automatically provided by ListView delegate
    property var appData: modelData
    property bool isSelected: false
    
    signal clicked()
    signal hovered(int index)
    
    
    width: parent ? parent.width : 300
    height: 80

    Rectangle {
        anchors.fill: parent
        color: isSelected ? Colors.primaryContainer : Colors.surfaceContainerHigh
        radius: 10

        Row {
            anchors.fill: parent
            
            Item {
                height: parent.height
                width: 60
                
                Image {
                    anchors.centerIn: parent
                    width: 50
                    height: 50
                    asynchronous: true
                    cache: false // Save memory
                    source: appData ? Quickshell.iconPath(appData.icon, true) : ""
                    sourceSize: Qt.size(width, height)
                }
            }
            
            Item {
                height: parent.height
                width: parent.width - 60

                StyledText {
                    anchors.left: parent.left
                    anchors.margins: 10
                    anchors.verticalCenter: parent.verticalCenter
                    content: appData ? appData.name : ""
                    font.pixelSize: 16
                    color: Colors.surfaceText
                    font.weight: 100
                    elide: Text.ElideRight
                    width: parent.width - 20
                }
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: {
            appDelegate.hovered(index)
        }
        
        onClicked: {
            appDelegate.clicked()
        }
    }
}
