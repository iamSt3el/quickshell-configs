pragma Singleton
import Quickshell
import "HelperFunctions.js" as HelperFunctions


Singleton{
    function getCirclePosition(index, total, radiusValue, centerXValue, centerYValue){
        return HelperFunctions.getCirclePosition(index, total, radiusValue, centerXValue, centerYValue)
    }

    function getFixedSpaceCirclePosition(index, total, radiusValue, centerXValue, centerYValue, fixedAngleDegrees, parentIndex){
        return HelperFunctions.getFixedSpaceCirclePosition(index, total, radiusValue, centerXValue, centerYValue, fixedAngleDegrees, parentIndex)
    }
}
