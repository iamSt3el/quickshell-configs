pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#c2c5df"
    property string primaryText: "#2b2f44"
    property string primaryContainer: "#0e1225"
    property string primaryContainerText: "#9b9fb8"
    
    property string secondary: "#c6c5d1"
    property string secondaryText: "#2f3039"
    property string secondaryContainer: "#454650"
    property string secondaryContainerText: "#e0dfeb"
    
    property string tertiary: "#d8bfd7"
    property string tertiaryText: "#3c2b3d"
    property string tertiaryContainer: "#1d0e1f"
    property string tertiaryContainerText: "#b199b0"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#131315"
    property string surfaceText: "#e5e1e3"
    property string surfaceVariant: "#46464d"
    property string surfaceVariantText: "#c7c5cd"
    
    property string outline: "#919097"
    property string outlineVariant: "#46464d"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e5e1e3"
    property string inverseSurfaceText: "#313032"
    property string inversePrimary: "#5a5d74"
    
    property string surfaceDim: "#131315"
    property string surfaceBright: "#39393b"
    property string surfaceContainerLowest: "#0e0e10"
    property string surfaceContainerLow: "#1c1b1d"
    property string surfaceContainer: "#201f21"
    property string surfaceContainerHigh: "#2a2a2b"
    property string surfaceContainerHighest: "#353436"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/wallhaven-vp9ez3_1920x1080.png"
    

}
