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
