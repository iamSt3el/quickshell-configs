pragma Singleton
import QtQuick
import Quickshell

Singleton {
    // Font families
    readonly property string primary: "Iosevka"
    readonly property string mono: "CaskaydiaCove NF" 
    readonly property string digital: "Digital-7"
    readonly property string nothing: "nothing-font-5x7"
    readonly property string material: "Material Symbols Rounded"
    
    property Size size: Size {}
    property Weight weight: Weight {}
    
    component Size: QtObject {
        readonly property int tiny: 10
        readonly property int small: 12
        readonly property int caption: 14
        readonly property int body: 16
        readonly property int subtitle: 18
        readonly property int title: 20
        readonly property int heading: 24
        readonly property int display: 28
        readonly property int hero: 32
    }
    
    component Weight: QtObject {
        readonly property int thin: Font.Thin
        readonly property int light: Font.Light
        readonly property int normal: Font.Normal
        readonly property int medium: Font.Medium
        readonly property int bold: Font.Bold
        readonly property int heavy: Font.Black
    }
}