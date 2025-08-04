import Quickshell
import Quickshell.Hyprland
import QtQuick
import "."

Rectangle {
    id: iconContainer

    // Properties
    property var windowData

    // Signals for parent communication
    signal iconHovered()
    signal iconLeft()
    signal iconClicked()
    signal hovered()
    
    // Property to receive popup reference from parent
    property var popupRef: null

    width: 50
    height: 50
    radius: 10
    color: "transparent"

    Rectangle {
        anchors.centerIn: parent
        id: iconBackground
        width: 32
        height: 32
        radius: 5
        color: "transparent"

        Image {
            source: IconUtils.getIconPath(windowData.windowClass)
            width: 32
            height: 32
            opacity: mouseArea.containsMouse ? 1.0 : 0.5

            Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if(popupRef && popupRef.hideTimer_popup){
                popupRef.hideTimer_popup.stop();
                console.log("stop");
            }
            iconContainer.iconHovered()
            iconContainer.hovered()
        }
        onHoveredChanged: {
            iconContainer.iconLeft()
            iconContainer.hovered()
        }

        onExited: {
            if (popupRef && popupRef.hideTimer_popup) {
                popupRef.hideTimer_popup.start();
                console.log("start");
            }
            iconContainer.iconLeft()
            iconContainer.hovered()
        }

        onClicked: {
            iconContainer.iconClicked()

            let addr = windowData.address
            if (!addr.startsWith("0x"))
            {
                addr = "0x" + addr;
            }
            Hyprland.dispatch("focuswindow address:" + addr)
        }
    }
}

}
