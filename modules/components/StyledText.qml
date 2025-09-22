import QtQuick
import qs.modules.util
import QtQuick.Effects


Text {
    id: root
    
    // Custom properties
    property alias content: root.text
    property int size: 16
    property int weight: 200
    property bool effect: true
    property bool enableScrolling: true
 
    color: Colors.surfaceText
 
    font.pixelSize: size
    font.weight: weight
    font.family: Typography.cartoon
    renderType: Text.NativeRendering

    layer.enabled: effect
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 0.6
        shadowColor: Qt.alpha(Colors.shadow, 0.6)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }


     property bool needsScrolling: root.contentWidth > parent.width && enableScrolling
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
