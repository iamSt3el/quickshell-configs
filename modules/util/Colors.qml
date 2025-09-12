pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#b2c5ff"
    property string primaryText: "#182e60"
    property string primaryContainer: "#304578"
    property string primaryContainerText: "#dae2ff"
    
    property string secondary: "#c0c6dd"
    property string secondaryText: "#2a3042"
    property string secondaryContainer: "#404659"
    property string secondaryContainerText: "#dce2f9"
    
    property string tertiary: "#e1bbdc"
    property string tertiaryText: "#422741"
    property string tertiaryContainer: "#5a3d59"
    property string tertiaryContainerText: "#fed7f9"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#121318"
    property string surfaceText: "#e3e2e9"
    property string surfaceVariant: "#45464f"
    property string surfaceVariantText: "#c5c6d0"
    
    property string outline: "#8f909a"
    property string outlineVariant: "#45464f"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e3e2e9"
    property string inverseSurfaceText: "#2f3036"
    property string inversePrimary: "#495d92"
    
    property string surfaceDim: "#121318"
    property string surfaceBright: "#38393f"
    property string surfaceContainerLowest: "#0d0e13"
    property string surfaceContainerLow: "#1a1b21"
    property string surfaceContainer: "#1e1f25"
    property string surfaceContainerHigh: "#292a2f"
    property string surfaceContainerHighest: "#33343a"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/fantasy-tree-flower-field-4k-wallpaper-uhdpaper.com-572@5@e.jpg"
    

}
