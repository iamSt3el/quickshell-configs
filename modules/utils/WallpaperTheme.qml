pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#feed35"
    property string primaryText: "#363100"
    property string primaryContainer: "#e1d00a"
    property string primaryContainerText: "#413c00"
    
    property string secondary: "#d2c87c"
    property string secondaryText: "#363100"
    property string secondaryContainer: "#4e4807"
    property string secondaryContainerText: "#ece293"
    
    property string tertiary: "#bdfc71"
    property string tertiaryText: "#1f3700"
    property string tertiaryContainer: "#a2df58"
    property string tertiaryContainerText: "#264200"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#151409"
    property string surfaceText: "#e8e2d0"
    property string surfaceVariant: "#4a4733"
    property string surfaceVariantText: "#ccc7ac"
    
    property string outline: "#969179"
    property string outlineVariant: "#4a4733"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e8e2d0"
    property string inverseSurfaceText: "#333124"
    property string inversePrimary: "#686000"
    
    property string surfaceDim: "#151409"
    property string surfaceBright: "#3c392d"
    property string surfaceContainerLowest: "#100e05"
    property string surfaceContainerLow: "#1d1c11"
    property string surfaceContainer: "#212014"
    property string surfaceContainerHigh: "#2c2a1e"
    property string surfaceContainerHighest: "#373528"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/Macro.png"
    

}
