import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ccbeff"
    property string primaryText: "#33275e"
    property string primaryContainer: "#4a3e76"
    property string primaryContainerText: "#e7deff"
    
    property string secondary: "#cac3dc"
    property string secondaryText: "#322e41"
    property string secondaryContainer: "#494458"
    property string secondaryContainerText: "#e7dff8"
    
    property string tertiary: "#eeb8cb"
    property string tertiaryText: "#492534"
    property string tertiaryContainer: "#623b4a"
    property string tertiaryContainerText: "#ffd9e5"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#141318"
    property string surfaceText: "#e6e1e9"
    property string surfaceVariant: "#48454e"
    property string surfaceVariantText: "#cac4cf"
    
    property string outline: "#938f99"
    property string outlineVariant: "#48454e"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e6e1e9"
    property string inverseSurfaceText: "#312f35"
    property string inversePrimary: "#625690"
    
    property string surfaceDim: "#141318"
    property string surfaceBright: "#3a383e"
    property string surfaceContainerLowest: "#0f0d13"
    property string surfaceContainerLow: "#1c1b20"
    property string surfaceContainer: "#201f24"
    property string surfaceContainerHigh: "#2b292f"
    property string surfaceContainerHighest: "#36343a"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/dracula-portolans-ff79c6.png"
    
    /*Component.onCompleted: {
        console.log("Material You colors loaded from wallpaper")
    }*/
}
