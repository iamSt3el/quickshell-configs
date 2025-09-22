import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.modules.util
import qs.modules.services
import QtQuick.Effects
import Quickshell.Widgets

Item{
    id: root
    anchors.verticalCenter: parent.verticalCenter
    width: 30
    height: 30
    property real progress: 0.0
    property string iconSource: ""
    property real thickness: 2
    property real radius: Math.min(width, height) / 2 - thickness
    property bool isInteractive: false

    signal clicked()
    signal wheelChanged(delta: int)

    
    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 0.6
        shadowColor: Qt.alpha(Colors.shadow, 0.6)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
    
    Canvas{
        id: canvas
        anchors.fill: parent
        
        renderStrategy: Canvas.Cooperative
        antialiasing: true
        smooth: true

        readonly property real centerX: width / 2
        readonly property real centerY: height / 2
        readonly property real startAngle: -Math.PI / 2
        readonly property real endAngle: startAngle + (2 * Math.PI * root.progress)
        
        onEndAngleChanged: requestPaint()

        onPaint:{
            const ctx = getContext("2d")
            ctx.reset();

            ctx.lineWidth = root.thickness;
            ctx.lineCap = "round"

            const radius = root.radius
            const cx = centerX;
            const cy = centerY;

           /* ctx.beginPath();
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI, false)
            ctx.strokeStyle = Colors.secondary
            ctx.stroke();*/

            if(root.progress > 0){
                ctx.beginPath();
                ctx.arc(cx, cy, radius, startAngle, endAngle, false);
                ctx.strokeStyle = Colors.primary
                ctx.stroke();
            }
        }
    }

    Rectangle{
        id: centerContent
        anchors.centerIn: parent 
        implicitWidth: parent.width - 6
        implicitHeight: parent.height - 6
        radius: width
        color: Colors.primaryContainer
        IconImage{
             visible: !area.containsMouse
             id: iconImage
             source: root.iconSource
             width: parent.width - 6
             height: parent.height - 6
             anchors.centerIn: parent

            
            scale: visible ? 1 : 0
            
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }

        StyledText{
            visible: area.containsMouse
            anchors.centerIn: parent
            content: Math.floor(root.progress * 100)
            color: Colors.surfaceText
            size: text === "100" ? 12 : 14
            weight: 800
            scale: visible ? 1 : 0
            
            Behavior on scale {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }


    }

    MouseArea{
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.isInteractive ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            if (root.isInteractive) root.clicked()
        }

        onWheel: function(wheel){
            if (root.isInteractive) root.wheelChanged(wheel.angleDelta.y / 120)
        }
    }

}
