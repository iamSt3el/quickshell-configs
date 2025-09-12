pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property Spacing spacing: Spacing {}
    property Radius radius: Radius {}
    property Component component: Component {}
    property Icon icon: Icon {}
    property Animation animation: Animation {}
    property Position position: Position {}

    component Position: QtObject{
        readonly property int x: 20
        readonly property int y: 10
    }

    component Spacing: QtObject {
        readonly property int tiny: 4
        readonly property int small: 8
        readonly property int normal: 12
        readonly property int medium: 16
        readonly property int large: 20
        readonly property int xlarge: 24
        readonly property int xxlarge: 32
        readonly property int huge: 40
    }
    
    component Radius: QtObject {
        readonly property int small: 6
        readonly property int normal: 10
        readonly property int medium: 15
        readonly property int large: 20
        readonly property int xlarge: 25
        readonly property int round: 30
    }
    
    component Component: QtObject {
        readonly property int topBarHeight: 50
        readonly property int height: 25
        readonly property int width: 30
        readonly property int cpuWidth: 135
        readonly property int interactive: 62
        readonly property int wrapperHeight: 50
    }
    
    component Icon: QtObject {
        readonly property int tiny: 12
        readonly property int small: 16
        readonly property int normal: 18
        readonly property int medium: 20
        readonly property int large: 32
        readonly property int xlarge: 40
    }
    
    component AnimationEasing: QtObject {
        readonly property int standard: Easing.OutQuad
        readonly property int emphasized: Easing.OutBack
        readonly property int smooth: Easing.InOutQuad
    }
    
    component Animation: QtObject {
        readonly property int fast: 150
        readonly property int normal: 250
        readonly property int slow: 400
        readonly property int verySlow: 600
        
        readonly property AnimationEasing easing: AnimationEasing {}
    }
}
