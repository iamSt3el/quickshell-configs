import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.modules.utils

PanelWindow {
    id: mainWindow
    
    // --- CONFIGURATION ---
    property int gridSize: 3      // Try 3, 4, or 5
    property int dotSize: 30
    property int spacingSize: 80 
    // ---------------------

    // Auto-size window based on config
    implicitWidth: (gridSize * dotSize) + ((gridSize - 1) * spacingSize) + 100
    implicitHeight: (gridSize * dotSize) + ((gridSize - 1) * spacingSize) + 100

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    color: "transparent"

    Rectangle {
        id: root
        anchors.fill: parent
        radius: 20
        color: Qt.alpha(Colors.surface, 0.6)

        property var dots: []
        property var selectedDots: []

        Canvas {
            id: canvas
            anchors.fill: parent
            z: 1

            property var points: []
            property point currentTip: Qt.point(0, 0)
            property bool isDragging: false

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true

                onPressed: (mouse) => {
                    canvas.isDragging = true
                    canvas.points = []
                    root.selectedDots = [] // reset to empty new array
                    canvas.currentTip = Qt.point(mouse.x, mouse.y)
                    checkCollision(mouse.x, mouse.y)
                    canvas.requestPaint()
                }

                onPositionChanged: (mouse) => {
                    if (canvas.isDragging) {
                        canvas.currentTip = Qt.point(mouse.x, mouse.y)
                        checkCollision(mouse.x, mouse.y)
                        canvas.requestPaint()
                    }
                }

                onReleased: {
                    canvas.isDragging = false
                    var password = root.selectedDots.join("");
                    if(password != "046751"){
                        root.selectedDots = []
                        canvas.points = []
                    }
                    console.log("Pattern:", root.selectedDots.join(""))
                    canvas.requestPaint()
                }

                function checkCollision(x, y) {
                    for (var i = 0; i < root.dots.length; i++) {
                        // Check collision
                        if (root.isPointInCircle(x, y, root.dots[i].x, root.dots[i].y, mainWindow.dotSize)) {
                            
                            var targetIndex = root.dots[i].index;

                            // If not already selected...
                            if (!root.selectedDots.includes(targetIndex)) {
                                
                                // 1. Fill in the gaps (intermediate dots)
                                if (root.selectedDots.length > 0) {
                                    var lastIndex = root.selectedDots[root.selectedDots.length - 1];
                                    var intermediates = root.getIntermediateDots(lastIndex, targetIndex);
                                    
                                    for(var j = 0; j < intermediates.length; j++) {
                                        // Recursively add intermediates if missing
                                        if(!root.selectedDots.includes(intermediates[j])) {
                                            addDot(intermediates[j]);
                                        }
                                    }
                                }
                                
                                // 2. Add the target dot
                                addDot(targetIndex);
                            }
                        }
                    }
                }

                function addDot(index) {
                    // FIX: Use .concat() to create a NEW array reference.
                    // This forces QML to notice the change and update the colors.
                    root.selectedDots = root.selectedDots.concat(index)

                    // Update Canvas Line
                    var dotObj = root.dots.find(d => d.index === index)
                    if (dotObj) {
                        // We also need to reassign points to trigger canvas updates properly
                        // though requestPaint handles the visual part mostly.
                        var p = canvas.points
                        p.push(Qt.point(dotObj.x, dotObj.y))
                        canvas.points = p
                    }
                }
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                if (points.length > 0) {
                    ctx.strokeStyle = Colors.primary
                    ctx.lineWidth = 8
                    ctx.lineJoin = "round"
                    ctx.lineCap = "round"
                    ctx.beginPath()

                    ctx.moveTo(points[0].x, points[0].y)
                    for (var i = 1; i < points.length; i++) {
                        ctx.lineTo(points[i].x, points[i].y)
                    }

                    if (isDragging) {
                        ctx.lineTo(currentTip.x, currentTip.y)
                    }
                    ctx.stroke()
                }
            }
        }

        Grid {
            id: grid
            anchors.centerIn: parent
            rows: mainWindow.gridSize
            columns: mainWindow.gridSize
            spacing: mainWindow.spacingSize
            z: 2

            Repeater {
                model: mainWindow.gridSize * mainWindow.gridSize
                
                delegate: Rectangle {
                    id: dot
                    implicitHeight: mainWindow.dotSize
                    implicitWidth: mainWindow.dotSize
                    radius: width / 2
                    
                    // Because we use .concat(), root.selectedDots is a new object,
                    // so this binding re-evaluates correctly now.
                    color: root.selectedDots.includes(index) ? Colors.primary : Colors.inverseSurface

                    scale: root.selectedDots.includes(index) ? 1.3 : 1.0
                    Behavior on scale { NumberAnimation { duration: 150; easing.type: Easing.OutBack } }

                    Component.onCompleted: {
                        Qt.callLater(() => {
                            var p = dot.mapToItem(root, dot.width / 2, dot.height / 2)
                            // Avoid duplicates on reload
                            if(!root.dots.some(d => d.index === index)) {
                                root.dots.push({ x: p.x, y: p.y, index: index })
                            }
                        })
                    }
                }
            }
        }

        function isPointInCircle(px, py, cx, cy, r) {
            var dx = px - cx
            var dy = py - cy
            return (dx * dx + dy * dy) <= (r * r)
        }
        
        function gcd(a, b) {
            return b === 0 ? a : gcd(b, a % b);
        }

        function getIntermediateDots(index1, index2) {
            var intermediates = []
            var size = mainWindow.gridSize
            
            var r1 = Math.floor(index1 / size)
            var c1 = index1 % size
            var r2 = Math.floor(index2 / size)
            var c2 = index2 % size

            var dr = r2 - r1
            var dc = c2 - c1
            var steps = gcd(Math.abs(dr), Math.abs(dc))

            if (steps > 1) {
                var stepR = dr / steps
                var stepC = dc / steps
                for (var i = 1; i < steps; i++) {
                    var newR = r1 + (i * stepR)
                    var newC = c1 + (i * stepC)
                    intermediates.push(newR * size + newC)
                }
            }
            return intermediates
        }
    }
}
