import QtQuick
import qs.modules.utils

Item {
    id: root

    property var values: []         // array of numeric values (push new ones in)
    property int maxPoints: 30      // how many history points to keep
    property color lineColor: Colors.primary
    property color fillColor: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0.15)
    property real lineWidth: 1.5
    property bool filled: true      // fill area under the line

    // Call this to append a new data point
    function addValue(v) {
        const copy = values.slice()
        copy.push(v)
        if (copy.length > maxPoints) copy.shift()
        values = copy
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            const pts = root.values
            if (pts.length < 2) return

            const maxVal = Math.max(...pts, 1)
            const stepX  = width / (root.maxPoints - 1)
            const offsetX = (root.maxPoints - pts.length) * stepX

            const xAt = i => offsetX + i * stepX
            const yAt = v => height - (v / maxVal) * height * 0.9

            // Fill under the line
            if (root.filled) {
                ctx.beginPath()
                ctx.moveTo(xAt(0), height)
                for (let i = 0; i < pts.length; i++)
                    ctx.lineTo(xAt(i), yAt(pts[i]))
                ctx.lineTo(xAt(pts.length - 1), height)
                ctx.closePath()
                ctx.fillStyle = root.fillColor
                ctx.fill()
            }

            // Line
            ctx.beginPath()
            ctx.moveTo(xAt(0), yAt(pts[0]))
            for (let i = 1; i < pts.length; i++)
                ctx.lineTo(xAt(i), yAt(pts[i]))
            ctx.strokeStyle = root.lineColor
            ctx.lineWidth = root.lineWidth
            ctx.lineJoin = "round"
            ctx.lineCap = "round"
            ctx.stroke()
        }

        Connections {
            target: root
            function onValuesChanged() { canvas.requestPaint() }
        }
    }
}
