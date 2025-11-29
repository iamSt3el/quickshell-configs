import QtQuick
import qs.modules.utils


Text{
    id: root
    property alias content: root.text
    property int size: 12
    property int weight: 800
    property string customColor: Colors.surfaceText
    property string family: "Rubik"
    renderType: Text.NativeRendering
    
    color: customColor
    font.pixelSize: size
    font.weight: weight
    font.family: family
}
