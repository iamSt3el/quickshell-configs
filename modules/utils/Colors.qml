pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ffb691"
    property string primaryText: "#542202"
    property string primaryContainer: "#703716"
    property string primaryContainerText: "#ffdbcb"
    
    property string secondary: "#e6beac"
    property string secondaryText: "#432b1e"
    property string secondaryContainer: "#5c4032"
    property string secondaryContainerText: "#ffdbcb"
    
    property string tertiary: "#cfc890"
    property string tertiaryText: "#353107"
    property string tertiaryContainer: "#4c481c"
    property string tertiaryContainerText: "#ece4aa"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#1a120e"
    property string surfaceText: "#f0dfd8"
    property string surfaceVariant: "#52443d"
    property string surfaceVariantText: "#d7c2b9"
    
    property string outline: "#a08d85"
    property string outlineVariant: "#52443d"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#f0dfd8"
    property string inverseSurfaceText: "#382e2a"
    property string inversePrimary: "#8d4e2b"
    
    property string surfaceDim: "#1a120e"
    property string surfaceBright: "#423732"
    property string surfaceContainerLowest: "#140c09"
    property string surfaceContainerLow: "#221a16"
    property string surfaceContainer: "#271e19"
    property string surfaceContainerHigh: "#322823"
    property string surfaceContainerHighest: "#3d332e"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/city-skyline.jpg"
    

}
