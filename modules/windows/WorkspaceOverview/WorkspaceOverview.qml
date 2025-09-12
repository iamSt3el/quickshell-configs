import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import qs.modules.util
import qs.modules.services
import QtQuick.Shapes

PanelWindow {
    id: testpanel
    implicitWidth: (5 * 300) + 40 + 60  // grid width + wrapper padding
    implicitHeight: (2 * 200) + 10 + 60  // grid height + wrapper padding
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal
    visible: false
    color: "transparent"

    anchors{
        bottom: true
    }

    Connections {
        target: ServiceIpcHandler
        function onRequestWorkspaceOverviewClose() {
            close()
        }
    }

    Component.onCompleted: {
        open()
    }
    
    Timer{
        id: timer
        interval: 100
        onTriggered:{
            testpanel.visible = false
        }
    }

    SequentialAnimation {
        id: openAnimation
        
        ParallelAnimation {
            NumberAnimation {
                target: wrapper
                property: "height"
                from: 0
                to: 30
                duration: 400
                easing.type: Easing.OutQuad
            }
            
            NumberAnimation {
                target: shapeScale
                property: "yScale"
                from: 0
                to: 1.0
                duration: 400
                easing.type: Easing.OutQuad
            }
        }
        
        NumberAnimation {
            target: wrapper
            property: "height"
            from: 30
            to: 470
            duration: 200
            easing.type: Easing.OutQuad
        }
    }
    
    SequentialAnimation {
        id: closeAnimation
        
        NumberAnimation {
            target: wrapper
            property: "height"  
            from: 470
            to: 30
            duration: 200
            easing.type: Easing.InQuad
        }
        
        ParallelAnimation {
            NumberAnimation {
                target: shapeScale
                property: "yScale"
                from: 1.0
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
            
            NumberAnimation {
                target: wrapper
                property: "height"
                from: 30
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
        }
        
        onFinished: {
            timer.start()
            ServiceIpcHandler.isWorkspaceOverviewVisible = false
        }
    }
    
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "movewindow" || 
                event.name === "resizewindow" ||
                event.name === "fullscreen" ||
                event.name === "activewindow" ||
                event.name === "openwindow" ||
                event.name === "closewindow" ||
                event.name === "changefloatingmode") {
                Hyprland.refreshToplevels()
            }
        }
    }

    Item{
        id: wrapper
        width: parent.width
        height: 0
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter

        Shape{
            id: shapeElement
            preferredRendererType: Shape.CurveRenderer
            
            transform: Scale {
                id: shapeScale
                origin.x: wrapper.width / 2
                origin.y: wrapper.height
                yScale: 0
            }
            ShapePath{
                fillColor: Colors.surface
                strokeWidth: 0

                startX: wrapper.x
                startY: wrapper.height

                PathArc{
                    relativeX:20
                    relativeY: -20
                    radiusY: 15
                    radiusX: 20
                    direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: wrapper.width - 40
                    relativeY: 0
                }

                PathArc{
                    relativeX: 20
                    relativeY: 20
                    radiusX: 20
                    radiusY: 15
                    direction: PathArc.Counterclockwise
                }

            }
        }
    
        Rectangle {
            id: workspaceOverview
            width: parent.width - 40
            height: parent.height
            color: Colors.surface
            topLeftRadius: 20
            topRightRadius: 20
            clip: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            WorkspaceOverviewContent {
                id: content
                anchors.fill: parent
                visible: wrapper.height === 470
            }
        }
    }
    
    function open(){
        testpanel.visible = true
        openAnimation.start()
    }

    function close(){
        closeAnimation.start()
    }
}