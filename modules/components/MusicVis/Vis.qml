import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Effects
import qs.modules.utils

PanelWindow {
    id: panelWindow
    implicitHeight: 100
    visible: true
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Bottom
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None


    mask: Region{
        item: maskRect
        intersection: Intersection.Xor;
    }

    Rectangle{
        id: maskRect
        anchors.fill: parent
        color: "transparent"
    }

    Process {
        id: cavaProc
        running: true
       
        command: ["sh", "-c", `
            cava -p /dev/stdin <<EOF
[general]
# Reduced to 20 for wider, smoother hills
bars = 40
framerate = 60
autosens = 1

[input]
method = pulse

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
bar_delimiter = 59

[smoothing]
monstercat = 1.5
waves = 0
gravity = 100
noise_reduction = 0.20

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
EOF
        `]
       
        stdout: SplitParser {
            onRead: data => {
                let newPoints = data.split(";")
                    .map(p => parseFloat(p.trim()) / 1000)
                    .filter(p => !isNaN(p));
                let smoothFactor = 0.3; 
                if (canvas.cavaData.length === 0 || canvas.cavaData.length !== newPoints.length) {
                    canvas.cavaData = newPoints;
                } else {
                    let smoothed = [];
                    for (let i = 0; i < newPoints.length; i++) {
                        let oldVal = canvas.cavaData[i];
                        let newVal = newPoints[i];
                        smoothed.push(oldVal + (newVal - oldVal) * smoothFactor);
                    }
                    canvas.cavaData = smoothed;
                }
                
                canvas.requestPaint();
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        property var cavaData: []
       
        onPaint: {
            var ctx = getContext('2d')
            ctx.clearRect(0, 0, width, height)
            
            drawMountainWave(ctx, cavaData, true)
            drawMountainWave(ctx, cavaData, false)
        }
       
        function drawMountainWave(ctx, data, isShadow) {
            if (data.length < 2) return

            var gradient = ctx.createLinearGradient(0, 0, width, 0)
            gradient.addColorStop(0.0, '#4158D0')
            gradient.addColorStop(0.3, '#C850C0')
            gradient.addColorStop(0.6, '#FFCC70')
            gradient.addColorStop(1.0, '#ffe53b')
            // gradient.addColorStop(0.0, Colors.surface)
            // gradient.addColorStop(0.3, Colors.surfaceContainer)
            // gradient.addColorStop(0.6, Colors.surfaceContainerHigh)
            // gradient.addColorStop(1.0, Colors.surfaceContainerHighest)

            ctx.beginPath()

            if (isShadow) {
                ctx.globalAlpha = 0.3  // 30% opacity
                ctx.save()             // Save current state
                ctx.translate(0, -10)  // Move up slightly
                ctx.scale(1.02, 1.05)  // Stretch slightly
            } else {
                ctx.globalAlpha = 1.0  // Full opacity
            }
            
            ctx.fillStyle = gradient

            ctx.moveTo(0, height)
            var startY = height - (data[0] * height)
            ctx.lineTo(0, startY)

            var barWidth = width / (data.length - 1)

            for (var i = 0; i < data.length - 1; i++) {
                var xCurr = i * barWidth
                var yCurr = height - (data[i] * height)

                var xNext = (i + 1) * barWidth
                var yNext = height - (data[i + 1] * height)

                var xMid = (xCurr + xNext) / 2
                var yMid = (yCurr + yNext) / 2

                ctx.quadraticCurveTo(xCurr, yCurr, xMid, yMid)
            }

            var lastX = (data.length - 1) * barWidth
            var lastY = height - (data[data.length - 1] * height)
           
            ctx.lineTo(lastX, lastY)
            ctx.lineTo(width, height)
            ctx.closePath()
            ctx.fill()
            
            // Clean up shadow settings
            if (isShadow) {
                ctx.restore()
            }
        }
    }
}
