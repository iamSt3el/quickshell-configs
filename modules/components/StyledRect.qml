import Quickshell
import QtQuick
import qs.modules.util
import QtQuick.Effects

Rectangle{
    color: Colors.surfaceVariant
    radius: 10

    
    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.2
        shadowOpacity: 0.6
        shadowColor: Qt.alpha(Colors.shadow, 0.6)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
}
