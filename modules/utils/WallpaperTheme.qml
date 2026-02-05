pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#71de65"
    property string primaryText: "#003a03"
    property string primaryContainer: "#44b13e"
    property string primaryContainerText: "#001100"
    
    property string secondary: "#a2d495"
    property string secondaryText: "#0c390b"
    property string secondaryContainer: "#275222"
    property string secondaryContainerText: "#bff2b1"
    
    property string tertiary: "#8bceff"
    property string tertiaryText: "#00344e"
    property string tertiaryContainer: "#00a5ed"
    property string tertiaryContainerText: "#000e19"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#0f150d"
    property string surfaceText: "#dee5d7"
    property string surfaceVariant: "#3f4a3b"
    property string surfaceVariantText: "#becab6"
    
    property string outline: "#889482"
    property string outlineVariant: "#3f4a3b"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#dee5d7"
    property string inverseSurfaceText: "#2c3229"
    property string inversePrimary: "#006e0d"
    
    property string surfaceDim: "#0f150d"
    property string surfaceBright: "#343b31"
    property string surfaceContainerLowest: "#0a1008"
    property string surfaceContainerLow: "#171d15"
    property string surfaceContainer: "#1b2119"
    property string surfaceContainerHigh: "#252c23"
    property string surfaceContainerHighest: "#30372d"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/guy_sleeping_colored.png"
    

}
