import QtQuick
import qs.modules.settings
import qs.modules.utils
import QtQuick.Effects


Text{
    id: root
    property alias content: root.text
    property bool shadow: false
    property int size: 12
    verticalAlignment: Text.AlignVCenter
    property int weight: 800
    property string customColor: Colors.surfaceText
    property string family: Settings.defaultFont
    renderType: Text.NativeRendering
    elide: Text.ElideRight
    color: customColor
    font.pixelSize: size
    font.weight: weight
    font.family: family


    layer.enabled: shadow
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 1.0
        shadowColor: Qt.alpha(Colors.shadow, 1)
    }


    Behavior on color{
        ColorAnimation{
            duration: 200
        }
    }
}
