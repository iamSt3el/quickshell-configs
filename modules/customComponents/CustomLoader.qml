import QtQuick
import QtQuick.Shapes
import "loaderShapes.js" as ShapeData

Item {
    id: root

    property color color: "#6750A4"
    property real size: 200
    property bool running: true

    width: size
    height: size

    property int currentShapeIdx: 0
    property int nextShapeIdx: 1
    property real morphProgress: 0.0
    property real shapeRotation: 0.0  // Rotation during morph

    // Number of points for morphing
    property int numPoints: 120

    // Cached shape points and names
    property var shapePoints: []
    property var shapeNames: []

    // Cubic bezier helper
    function bezierPoint(t, p0, p1, p2, p3) {
        var mt = 1 - t
        var mt2 = mt * mt
        var mt3 = mt2 * mt
        var t2 = t * t
        var t3 = t2 * t
        return mt3 * p0 + 3 * mt2 * t * p1 + 3 * mt * t2 * p2 + t3 * p3
    }

    // Parse SVG path and sample points
    function parseSVGPath(pathData, viewW, viewH, samplesPerSegment) {
        var points = []
        var currentX = 0, currentY = 0
        var startX = 0, startY = 0

        var commands = pathData.match(/[MLCQZHV][^MLCQZHV]*/gi) || []

        for (var i = 0; i < commands.length; i++) {
            var cmd = commands[i]
            var type = cmd[0].toUpperCase()
            var nums = cmd.slice(1).trim().match(/-?[\d.]+/g) || []
            nums = nums.map(function(n) { return parseFloat(n) })

            if (type === 'M') {
                currentX = nums[0]
                currentY = nums[1]
                startX = currentX
                startY = currentY
                points.push({x: currentX, y: currentY})
            }
            else if (type === 'L') {
                var lx = nums[0], ly = nums[1]
                for (var li = 1; li <= samplesPerSegment; li++) {
                    var lt = li / samplesPerSegment
                    points.push({
                        x: currentX + (lx - currentX) * lt,
                        y: currentY + (ly - currentY) * lt
                    })
                }
                currentX = lx
                currentY = ly
            }
            else if (type === 'H') {
                var hx = nums[0]
                for (var hi = 1; hi <= samplesPerSegment; hi++) {
                    var ht = hi / samplesPerSegment
                    points.push({
                        x: currentX + (hx - currentX) * ht,
                        y: currentY
                    })
                }
                currentX = hx
            }
            else if (type === 'V') {
                var vy = nums[0]
                for (var vi = 1; vi <= samplesPerSegment; vi++) {
                    var vt = vi / samplesPerSegment
                    points.push({
                        x: currentX,
                        y: currentY + (vy - currentY) * vt
                    })
                }
                currentY = vy
            }
            else if (type === 'C') {
                for (var ci = 0; ci < nums.length; ci += 6) {
                    var x1 = nums[ci], y1 = nums[ci+1]
                    var x2 = nums[ci+2], y2 = nums[ci+3]
                    var x3 = nums[ci+4], y3 = nums[ci+5]

                    for (var cj = 1; cj <= samplesPerSegment; cj++) {
                        var ct = cj / samplesPerSegment
                        points.push({
                            x: bezierPoint(ct, currentX, x1, x2, x3),
                            y: bezierPoint(ct, currentY, y1, y2, y3)
                        })
                    }
                    currentX = x3
                    currentY = y3
                }
            }
            else if (type === 'Q') {
                var qx1 = nums[0], qy1 = nums[1]
                var qx2 = nums[2], qy2 = nums[3]
                for (var qi = 1; qi <= samplesPerSegment; qi++) {
                    var qt = qi / samplesPerSegment
                    var qmt = 1 - qt
                    points.push({
                        x: qmt*qmt*currentX + 2*qmt*qt*qx1 + qt*qt*qx2,
                        y: qmt*qmt*currentY + 2*qmt*qt*qy1 + qt*qt*qy2
                    })
                }
                currentX = qx2
                currentY = qy2
            }
            else if (type === 'Z') {
                if (Math.abs(currentX - startX) > 0.1 || Math.abs(currentY - startY) > 0.1) {
                    for (var zi = 1; zi <= samplesPerSegment; zi++) {
                        var zt = zi / samplesPerSegment
                        points.push({
                            x: currentX + (startX - currentX) * zt,
                            y: currentY + (startY - currentY) * zt
                        })
                    }
                }
                currentX = startX
                currentY = startY
            }
        }

        // Calculate centroid (average of all points) for proper visual centering
        var centroidX = 0, centroidY = 0
        for (var ci = 0; ci < points.length; ci++) {
            centroidX += points[ci].x
            centroidY += points[ci].y
        }
        centroidX /= points.length
        centroidY /= points.length

        // Calculate bounding box for scaling
        var minX = Infinity, maxX = -Infinity
        var minY = Infinity, maxY = -Infinity
        for (var bi = 0; bi < points.length; bi++) {
            minX = Math.min(minX, points[bi].x)
            maxX = Math.max(maxX, points[bi].x)
            minY = Math.min(minY, points[bi].y)
            maxY = Math.max(maxY, points[bi].y)
        }
        var width = maxX - minX
        var height = maxY - minY
        var maxDim = Math.max(width, height)

        // Normalize to -1 to 1 range, centered on centroid for proper visual balance
        var normalized = []
        for (var ni = 0; ni < points.length; ni++) {
            normalized.push({
                x: (points[ni].x - centroidX) / (maxDim / 2),
                y: (points[ni].y - centroidY) / (maxDim / 2)
            })
        }

        return normalized
    }

    // Resample shape to exact number of points
    function resampleShape(points, targetCount) {
        if (points.length < 2) return points

        var totalLen = 0
        var lengths = []
        for (var i = 0; i < points.length; i++) {
            var p1 = points[i]
            var p2 = points[(i + 1) % points.length]
            var len = Math.sqrt(Math.pow(p2.x - p1.x, 2) + Math.pow(p2.y - p1.y, 2))
            lengths.push(len)
            totalLen += len
        }

        var resampled = []
        var stepDist = totalLen / targetCount

        for (var n = 0; n < targetCount; n++) {
            var targetDist = n * stepDist
            var currentDist = 0

            for (var j = 0; j < points.length; j++) {
                if (currentDist + lengths[j] >= targetDist || j === points.length - 1) {
                    var t = lengths[j] > 0 ? (targetDist - currentDist) / lengths[j] : 0
                    t = Math.max(0, Math.min(1, t))
                    var p1 = points[j]
                    var p2 = points[(j + 1) % points.length]
                    resampled.push({
                        x: p1.x + (p2.x - p1.x) * t,
                        y: p1.y + (p2.y - p1.y) * t
                    })
                    break
                }
                currentDist += lengths[j]
            }
        }

        return resampled
    }

    // Find topmost point index
    function findTopIndex(points) {
        var topIdx = 0
        var topY = points[0].y
        for (var i = 1; i < points.length; i++) {
            if (points[i].y < topY) {
                topY = points[i].y
                topIdx = i
            }
        }
        return topIdx
    }

    // Rotate array
    function rotateArray(arr, startIdx) {
        return arr.slice(startIdx).concat(arr.slice(0, startIdx))
    }

    // Initialize shapes from external file
    Component.onCompleted: {
        var allShapes = []
        var names = []

        for (var i = 0; i < ShapeData.shapes.length; i++) {
            var svg = ShapeData.shapes[i]
            names.push(svg.name)

            var raw = parseSVGPath(svg.path, svg.w, svg.h, 6)
            var resampled = resampleShape(raw, numPoints)
            var topIdx = findTopIndex(resampled)
            var aligned = rotateArray(resampled, topIdx)
            allShapes.push(aligned)
        }

        shapePoints = allShapes
        shapeNames = names
        morphCanvas.requestPaint()
    }

    // Easing
    function easeInOutCubic(t) {
        return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
    }

    // Get morphed points
    function getMorphedPoints() {
        if (shapePoints.length === 0) return []

        var current = shapePoints[currentShapeIdx]
        var next = shapePoints[nextShapeIdx]

        if (!current || !next) return []

        var t = easeInOutCubic(morphProgress)
        var morphed = []

        for (var i = 0; i < numPoints; i++) {
            var p1 = current[i]
            var p2 = next[i]
            if (!p1 || !p2) continue
            morphed.push({
                x: p1.x + (p2.x - p1.x) * t,
                y: p1.y + (p2.y - p1.y) * t
            })
        }
        return morphed
    }

    // Draw with rotation
    function drawShape(ctx, points, scale, cx, cy, rotation) {
        if (points.length < 3) return

        ctx.beginPath()

        // Apply rotation to points
        var cosR = Math.cos(rotation)
        var sinR = Math.sin(rotation)

        var scaled = []
        for (var i = 0; i < points.length; i++) {
            var px = points[i].x
            var py = points[i].y
            // Rotate around center
            var rx = px * cosR - py * sinR
            var ry = px * sinR + py * cosR
            scaled.push({
                x: cx + rx * scale,
                y: cy + ry * scale
            })
        }

        // Smooth curve through midpoints
        var first = scaled[0]
        var last = scaled[scaled.length - 1]
        var midX = (last.x + first.x) / 2
        var midY = (last.y + first.y) / 2
        ctx.moveTo(midX, midY)

        for (var j = 0; j < scaled.length; j++) {
            var p0 = scaled[j]
            var p1 = scaled[(j + 1) % scaled.length]
            var mx = (p0.x + p1.x) / 2
            var my = (p0.y + p1.y) / 2
            ctx.quadraticCurveTo(p0.x, p0.y, mx, my)
        }

        ctx.closePath()
        ctx.fill()
    }

    // Canvas
    Canvas {
        id: morphCanvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            ctx.clearRect(0, 0, width, height)

            var points = root.getMorphedPoints()
            if (points.length === 0) return

            ctx.fillStyle = root.color
            root.drawShape(ctx, points, root.size * 0.42, width / 2, height / 2, root.shapeRotation)
        }

        Connections {
            target: root
            function onMorphProgressChanged() { morphCanvas.requestPaint() }
            function onShapeRotationChanged() { morphCanvas.requestPaint() }
        }
    }



    // M3 Expressive animation parameters
    property real rotationPerCycle: Math.PI  // 60 degrees per cycle
    property real baseRotation: 0

    // Shape morphing + rotation animation
    SequentialAnimation {
        id: morphAnim
        running: root.running
        loops: Animation.Infinite

        ParallelAnimation {
            // Morph with bounce
            PropertyAnimation {
                target: root
                property: "morphProgress"
                from: 0.0
                to: 1.0
                duration: 800
                easing.type: Easing.OutBounce
            }

            // Fast rotation
            NumberAnimation {
                target: root
                property: "shapeRotation"
                to: root.baseRotation + root.rotationPerCycle
                duration: 700
                easing.type: Easing.OutExpo
            }
        }

        ScriptAction {
            script: {
                root.baseRotation += root.rotationPerCycle
                root.currentShapeIdx = root.nextShapeIdx
                root.nextShapeIdx = (root.nextShapeIdx + 1) % root.shapeNames.length
                root.morphProgress = 0.0
            }
        }
    }


}
