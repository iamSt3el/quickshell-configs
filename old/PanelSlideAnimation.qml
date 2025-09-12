import QtQuick
import QtQuick.Shapes

Item {
    id: root
    
    // Properties to be set by the parent
    property var targetRect: null
    property var targetShape: null
    property var targetShapeScale: null
    property var onOpenFinished: function() {}
    property var onCloseFinished: function() {}
    
    // Animation direction - "horizontal" for AppLauncher, "vertical" for workspace overview
    property string direction: "horizontal"
    
    property alias openAnimation: openAnim
    property alias closeAnimation: closeAnim
    
    SequentialAnimation {
        id: openAnim
        
        // Stage 1: Initial size AND Shape scales up (parallel)
        ParallelAnimation {
            NumberAnimation {
                target: root.targetRect
                property: direction === "horizontal" ? "width" : "height"
                from: 0
                to: 30
                duration: 400
                easing.type: Easing.OutQuad
            }
            
            NumberAnimation {
                target: root.targetShapeScale
                property: direction === "horizontal" ? "xScale" : "yScale"
                from: 0
                to: 1.0
                duration: 400
                easing.type: Easing.OutQuad
            }
        }
        
        // Stage 2: Full size (panel slides out completely)
        NumberAnimation {
            target: root.targetRect
            property: direction === "horizontal" ? "width" : "height"
            from: 30
            to: direction === "horizontal" ? 300 : root.targetRect.parent.height
            duration: 200
            easing.type: Easing.OutQuad
        }
        
        onFinished: root.onOpenFinished()
    }
    
    SequentialAnimation {
        id: closeAnim
        
        // Reverse: Full size → 30
        NumberAnimation {
            target: root.targetRect
            property: direction === "horizontal" ? "width" : "height"
            from: direction === "horizontal" ? 300 : root.targetRect.parent.height
            to: 30
            duration: 200
            easing.type: Easing.InQuad
        }
        
        ParallelAnimation {
            // Shape scales down
            NumberAnimation {
                target: root.targetShapeScale
                property: direction === "horizontal" ? "xScale" : "yScale"
                from: 1.0
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
            
            // Size 30 → 0
            NumberAnimation {
                target: root.targetRect
                property: direction === "horizontal" ? "width" : "height"
                from: 30
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
        }
        
        onFinished: root.onCloseFinished()
    }
}
