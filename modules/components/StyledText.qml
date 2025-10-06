import QtQuick
import qs.modules.util
import qs.modules.services
import QtQuick.Effects


Text {
    id: root
    
    // Custom properties
    property alias content: root.text
    property int size: ServiceDashboardSettings.settings ? ServiceDashboardSettings.settings.defaultTextSize : 16
    property int weight: ServiceDashboardSettings.settings ? ServiceDashboardSettings.settings.defaultTextWeight : 200
    property bool effect: ServiceDashboardSettings.settings ? ServiceDashboardSettings.settings.textEffect : true
    property bool enableScrolling: ServiceDashboardSettings.settings ? ServiceDashboardSettings.settings.textScrolling : true
 
    color: Colors.surfaceText
 
    font.pixelSize: size
    font.weight: weight
    font.family: ServiceDashboardSettings.settings ? ServiceDashboardSettings.settings.defaultFontFamily : Typography.cartoon
    renderType: Text.NativeRendering

    layer.enabled: false
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 0.6
        shadowColor: Qt.alpha(Colors.shadow, 0.6)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
    }
}
