import Quickshell
import QtQuick
import QtQuick.Shapes
import qs.util

Item {
    id: root
    
    // Public properties
    property real progress: 0.0  // Progress from 0 to 1
    property string displayText: getDisplayText()  // Text to display in center
    property string iconSource: ""  // Optional icon source
    property string name: ""  // Optional name/title
    property bool isTemperature: false  // If true, shows temperature with degree symbol
    
    // Styling properties
    property real thickness: 8
    property real radius: Math.min(width, height) / 2 - thickness
    property bool interactive: false  // Whether user can drag to change progress
    property bool showPercentage: true
    
    Colors {
        id: colors
    }
    
    // Visual properties using Material You colors
    property color bgColor: colors.surfaceVariant
    property color fgColor: colors.primary
    property color textColor: colors.surfaceText
    property color nameColor: colors.surfaceText
    
    // Internal
    onProgressChanged: canvas.requestPaint()
    
    // Function to generate display text based on type
    function getDisplayText() {
        if (isTemperature) {
            return Math.round(progress * 100) + "°C"
        } else {
            return Math.round(progress * 100) + "%"
        }
    }
    
    Canvas {
        id: canvas
        anchors.fill: parent
        
        readonly property real centerX: width / 2
        readonly property real centerY: height / 2
        readonly property real startAngle: -Math.PI / 2  // Start at top (12 o'clock)
        readonly property real endAngle: startAngle + (2 * Math.PI * root.progress)
        
        onPaint: {
            const ctx = getContext("2d");
            ctx.reset();
            
            ctx.lineWidth = root.thickness;
            ctx.lineCap = "round";
            
            const radius = root.radius;
            const cx = centerX;
            const cy = centerY;
            
            // Draw background circle
            ctx.beginPath();
            ctx.arc(cx, cy, radius, 0, 2 * Math.PI, false);
            ctx.strokeStyle = root.bgColor;
            ctx.stroke();
            
            // Draw progress arc
            if (root.progress > 0) {
                ctx.beginPath();
                ctx.arc(cx, cy, radius, startAngle, endAngle, false);
                ctx.strokeStyle = root.fgColor;
                ctx.stroke();
            }
        }
    }
    
    // Center content area
    Item {
        id: centerContent
        anchors.centerIn: parent
        width: Math.max(iconImage.width, centerText.width)
        height: iconImage.height + centerText.height + (iconImage.visible ? 5 : 0)
        
        // Optional icon
        Image {
            id: iconImage
            visible: root.iconSource !== ""
            source: root.iconSource
            width: 32
            height: 32
            sourceSize: Qt.size(width, height)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
        }
        
        // Center text (percentage or custom text)
        Text {
            id: centerText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: iconImage.visible ? iconImage.bottom : parent.top
            anchors.topMargin: iconImage.visible ? 5 : 0
            text: root.displayText
            color: root.textColor
            font.pixelSize: Math.min(root.width * 0.15, 24)
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }
    }
    
    // Optional name/title below the circle
    Text {
        id: nameText
        visible: root.name !== ""
        text: root.name
        color: root.nameColor
        font.pixelSize: 12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 5
    }
    
    // Optional interactive drag area
    MouseArea {
        id: dragArea
        anchors.fill: parent
        enabled: root.interactive
        
        function calculateProgress(mouseX, mouseY) {
            const centerX = width / 2;
            const centerY = height / 2;
            
            // Calculate angle from center to mouse position
            const dx = mouseX - centerX;
            const dy = mouseY - centerY;
            let angle = Math.atan2(dy, dx);
            
            // Normalize to start from top (12 o'clock) and go clockwise
            angle = angle + Math.PI / 2;
            if (angle < 0) angle += 2 * Math.PI;
            
            // Convert to progress (0 to 1)
            return Math.max(0, Math.min(1, angle / (2 * Math.PI)));
        }
        
        onPressed: {
            if (root.interactive) {
                root.progress = calculateProgress(mouseX, mouseY);
            }
        }
        
        onPositionChanged: {
            if (pressed && root.interactive) {
                root.progress = calculateProgress(mouseX, mouseY);
            }
        }
    }
    
    // Smooth animation when not being dragged
    Behavior on progress {
        enabled: !dragArea.pressed
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutCubic
        }
    }
}