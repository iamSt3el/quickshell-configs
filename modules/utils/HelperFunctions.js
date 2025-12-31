function getCirclePosition(index, total, radiusValue, centerXValue, centerYValue) {
    var angle = (index * 2 * Math.PI) / total - Math.PI / 2
    var x = centerXValue + radiusValue * Math.cos(angle) - 50 / 2
    var y = centerYValue + radiusValue * Math.sin(angle) - 50 / 2
    
    return { x: x, y: y }
}

function getFixedSpaceCirclePosition(index, total, radiusValue, centerXValue, centerYValue, fixedAngleDegrees, parentIndex) {
    var parentOffset = parentIndex * 90 * (Math.PI / 180) 
    var totalAngle = (total - 1) * fixedAngleDegrees * (Math.PI / 180)
    var startAngle = parentOffset - totalAngle / 2 
    var angle = startAngle + (index * fixedAngleDegrees * (Math.PI / 180))

    var x = centerXValue + radiusValue * Math.cos(angle) - 25 
    var y = centerYValue + radiusValue * Math.sin(angle) - 25 

    return { x: x, y: y }
}

function getRadius(size, index, activeIndex){
    if(index !== activeIndex && index === 0){
        return {topLeft: 20, topRight: 5, bottomLeft: 20, bottomRight: 5}
    }else if(index !== activeIndex && index === size - 1){
        return {topLeft: 5, topRight: 20, bottomLeft: 5, bottomRight: 20}
    }

    if(activeIndex - 1 === index){
        return {topLeft: 5, topRight: 5, bottomLeft: 5, bottomRight: 5}
    }else if(activeIndex + 1 === index){
        return {topLeft: 5, topRight: 5, bottomLeft: 5, bottomRight: 5}
    }

    return {topLeft: 20, topRight: 20, bottomLeft: 20, bottomRight: 20}

}

// Arc path generator helpers
var ARC_CONFIG = {
    radiusX: 18,
    radiusY: 12,
    arcOffset: 20,
    gap: 8
}

// Generate horizontal arc segment (for top bar components)
function generateHorizontalArcSegment(component, prevComponent, config) {
    config = config || ARC_CONFIG
    var segments = []

    if (prevComponent) {
        // Arc out from previous component
        segments.push({
            type: "arc",
            relativeX: config.arcOffset,
            relativeY: -config.radiusY,
            radiusX: config.radiusX,
            radiusY: config.radiusY
        })

        // Line to next component
        segments.push({
            type: "line",
            x: component.x - config.arcOffset,
            y: config.gap
        })

        // Arc into component
        segments.push({
            type: "arc",
            relativeX: config.arcOffset,
            relativeY: config.radiusY,
            radiusX: config.radiusX,
            radiusY: config.radiusY
        })
    }

    // Line across component
    segments.push({
        type: "line",
        relativeX: component.width,
        relativeY: 0
    })

    return segments
}

// Generate vertical transition (for components that extend down/up)
function generateVerticalTransition(fromY, toY, direction, config) {
    config = config || ARC_CONFIG
    var segments = []

    // Line down/up
    segments.push({
        type: "line",
        relativeX: 0,
        relativeY: toY - fromY
    })

    // Arc at corner
    segments.push({
        type: "arc",
        relativeX: direction === "left" ? -config.arcOffset : config.arcOffset,
        relativeY: config.radiusY,
        radiusX: config.radiusX,
        radiusY: config.radiusY
    })

    return segments
}

// Generate component box with arcs (for loaders like notifications, clipboard)
function generateBoxWithArcs(x, y, width, height, visible, config) {
    config = config || ARC_CONFIG
    var segments = []

    if (!visible || height <= config.gap * 2) {
        return segments
    }

    // Top-left corner arc
    segments.push({
        type: "arc",
        relativeX: -config.arcOffset,
        relativeY: config.radiusY,
        radiusX: config.radiusX,
        radiusY: config.radiusY
    })

    // Left side
    segments.push({
        type: "line",
        relativeX: 0,
        relativeY: height - config.arcOffset - config.radiusY
    })

    // Bottom-left corner
    segments.push({
        type: "line",
        relativeX: -(width - config.arcOffset - config.radiusY),
        relativeY: 0
    })

    // Bottom-right corner
    segments.push({
        type: "arc",
        relativeX: -config.arcOffset,
        relativeY: config.radiusY,
        radiusX: config.radiusX,
        radiusY: config.radiusY
    })

    return segments
}
