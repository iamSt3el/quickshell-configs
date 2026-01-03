pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ffb4a9"
    property string primaryText: "#690002"
    property string primaryContainer: "#ff5545"
    property string primaryContainerText: "#000000"
    
    property string secondary: "#ffb4a9"
    property string secondaryText: "#690002"
    property string secondaryContainer: "#901913"
    property string secondaryContainerText: "#ffdcd7"
    
    property string tertiary: "#ffb95d"
    property string tertiaryText: "#462a00"
    property string tertiaryContainer: "#c58321"
    property string tertiaryContainerText: "#000000"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#200f0c"
    property string surfaceText: "#fedbd5"
    property string surfaceVariant: "#5e3f3b"
    property string surfaceVariantText: "#e8bcb6"
    
    property string outline: "#ae8782"
    property string outlineVariant: "#5e3f3b"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#fedbd5"
    property string inverseSurfaceText: "#402b28"
    property string inversePrimary: "#c00008"
    
    property string surfaceDim: "#200f0c"
    property string surfaceBright: "#4a3430"
    property string surfaceContainerLowest: "#1a0a08"
    property string surfaceContainerLow: "#291714"
    property string surfaceContainer: "#2e1b18"
    property string surfaceContainerHigh: "#392522"
    property string surfaceContainerHighest: "#452f2c"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/cliff-edge.jpg"
    

}
