pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ffffff"
    property string primaryText: "#2d3136"
    property string primaryContainer: "#dfe2e9"
    property string primaryContainerText: "#44484e"
    
    property string secondary: "#c6c6c9"
    property string secondaryText: "#2f3033"
    property string secondaryContainer: "#48494b"
    property string secondaryContainerText: "#e4e3e6"
    
    property string tertiary: "#ffffff"
    property string tertiaryText: "#352e34"
    property string tertiaryContainer: "#ebdfe7"
    property string tertiaryContainerText: "#4d464c"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#131314"
    property string surfaceText: "#e5e2e2"
    property string surfaceVariant: "#45474b"
    property string surfaceVariantText: "#c5c6cb"
    
    property string outline: "#8f9195"
    property string outlineVariant: "#45474b"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e5e2e2"
    property string inverseSurfaceText: "#313030"
    property string inversePrimary: "#5b5f65"
    
    property string surfaceDim: "#131314"
    property string surfaceBright: "#3a3939"
    property string surfaceContainerLowest: "#0e0e0e"
    property string surfaceContainerLow: "#1c1b1c"
    property string surfaceContainer: "#201f20"
    property string surfaceContainerHigh: "#2a2a2a"
    property string surfaceContainerHighest: "#353435"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/arch-nord-light.png"
    

}
