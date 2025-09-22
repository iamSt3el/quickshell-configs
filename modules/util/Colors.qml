pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#feb0d2"
    property string primaryText: "#531d39"
    property string primaryContainer: "#6d3350"
    property string primaryContainerText: "#ffd8e6"
    
    property string secondary: "#e0bdca"
    property string secondaryText: "#412a34"
    property string secondaryContainer: "#59404a"
    property string secondaryContainerText: "#fed9e6"
    
    property string tertiary: "#f2bb98"
    property string tertiaryText: "#49280f"
    property string tertiaryContainer: "#633e23"
    property string tertiaryContainerText: "#ffdcc6"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#191114"
    property string surfaceText: "#eedfe3"
    property string surfaceVariant: "#504348"
    property string surfaceVariantText: "#d4c2c7"
    
    property string outline: "#9d8c92"
    property string outlineVariant: "#504348"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#eedfe3"
    property string inverseSurfaceText: "#372e31"
    property string inversePrimary: "#894a68"
    
    property string surfaceDim: "#191114"
    property string surfaceBright: "#40373a"
    property string surfaceContainerLowest: "#130c0f"
    property string surfaceContainerLow: "#21191c"
    property string surfaceContainer: "#251d20"
    property string surfaceContainerHigh: "#30282b"
    property string surfaceContainerHighest: "#3b3236"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/manga.png"
    

}
