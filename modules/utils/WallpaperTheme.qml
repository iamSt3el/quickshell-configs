pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ffcf72"
    property string primaryText: "#412d00"
    property string primaryContainer: "#ebb12d"
    property string primaryContainerText: "#3d2a00"
    
    property string secondary: "#e3c287"
    property string secondaryText: "#412d00"
    property string secondaryContainer: "#5c4616"
    property string secondaryContainerText: "#ffe0a9"
    
    property string tertiary: "#c7e169"
    property string tertiaryText: "#2a3400"
    property string tertiaryContainer: "#acc550"
    property string tertiaryContainerText: "#273100"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#17130a"
    property string surfaceText: "#ece1d3"
    property string surfaceVariant: "#4f4534"
    property string surfaceVariantText: "#d3c5ae"
    
    property string outline: "#9c8f7a"
    property string outlineVariant: "#4f4534"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#ece1d3"
    property string inverseSurfaceText: "#353026"
    property string inversePrimary: "#7b5900"
    
    property string surfaceDim: "#17130a"
    property string surfaceBright: "#3e382e"
    property string surfaceContainerLowest: "#120e06"
    property string surfaceContainerLow: "#201b12"
    property string surfaceContainer: "#241f16"
    property string surfaceContainerHigh: "#2f2920"
    property string surfaceContainerHighest: "#3a342a"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/World-Map-Dark.png"
    

}
