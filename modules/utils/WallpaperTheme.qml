pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#b7c6eb"
    property string primaryText: "#21304d"
    property string primaryContainer: "#253451"
    property string primaryContainerText: "#b4c3e8"
    
    property string secondary: "#c1c6d6"
    property string secondaryText: "#2b303d"
    property string secondaryContainer: "#414754"
    property string secondaryContainerText: "#dbe0f0"
    
    property string tertiary: "#e3badb"
    property string tertiaryText: "#432740"
    property string tertiaryContainer: "#472a44"
    property string tertiaryContainerText: "#e0b7d8"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#131315"
    property string surfaceText: "#e4e2e5"
    property string surfaceVariant: "#44474d"
    property string surfaceVariantText: "#c5c6ce"
    
    property string outline: "#8f9098"
    property string outlineVariant: "#44474d"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e4e2e5"
    property string inverseSurfaceText: "#303033"
    property string inversePrimary: "#505e7e"
    
    property string surfaceDim: "#131315"
    property string surfaceBright: "#39393b"
    property string surfaceContainerLowest: "#0d0e10"
    property string surfaceContainerLow: "#1b1b1e"
    property string surfaceContainer: "#1f1f22"
    property string surfaceContainerHigh: "#292a2c"
    property string surfaceContainerHighest: "#343537"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/apple-light.jpg"
    

}
