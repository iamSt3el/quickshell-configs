import QtQuick
import qs.modules.util

Text {
    id: root
    
    // Custom properties
    property alias content: root.text
    property int size: 16 
    property int weight: 400
 
    color: Colors.surfaceText
 
    font.pixelSize: size
    font.weight: weight
    font.family: Typography.primary
    renderType: Text.NativeRendering

     property bool needsScrolling: root.contentWidth > parent.width
                                SequentialAnimation {
                                    running: root.needsScrolling
                                    loops: Animation.Infinite

                                    PauseAnimation {duration: 1000}

                                    NumberAnimation {
                                        target: root
                                        property: "x"
                                        from: 0
                                        to: -(root.contentWidth - root.parent.width)
                                        duration: 3000
                                        easing.type: Easing.Linear
                                    }
                                    PauseAnimation {duration: 1000}
                                    NumberAnimation {
                                        target: root
                                        property: "x"
                                        from: -(root.contentWidth - root.parent.width)
                                        to: 0
                                        duration: 1500
                                        easing.type: Easing.Linear
                                    }
                                }

}
