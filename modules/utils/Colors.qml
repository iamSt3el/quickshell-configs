pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#ffb2b7"
    property string primaryText: "#561d24"
    property string primaryContainer: "#723339"
    property string primaryContainerText: "#ffdadb"
    
    property string secondary: "#e6bdbe"
    property string secondaryText: "#44292b"
    property string secondaryContainer: "#5c3f41"
    property string secondaryContainerText: "#ffdadb"
    
    property string tertiary: "#e7c08e"
    property string tertiaryText: "#432c06"
    property string tertiaryContainer: "#5c421a"
    property string tertiaryContainerText: "#ffddb3"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#1a1112"
    property string surfaceText: "#f0dede"
    property string surfaceVariant: "#524344"
    property string surfaceVariantText: "#d7c1c2"
    
    property string outline: "#9f8c8d"
    property string outlineVariant: "#524344"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#f0dede"
    property string inverseSurfaceText: "#382e2e"
    property string inversePrimary: "#8f4a50"
    
    property string surfaceDim: "#1a1112"
    property string surfaceBright: "#413737"
    property string surfaceContainerLowest: "#140c0c"
    property string surfaceContainerLow: "#22191a"
    property string surfaceContainer: "#271d1e"
    property string surfaceContainerHigh: "#312828"
    property string surfaceContainerHighest: "#3d3232"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/1281259.jpg"
    

}
