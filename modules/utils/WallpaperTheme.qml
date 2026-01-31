pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#e0bcd6"
    property string primaryText: "#41283d"
    property string primaryContainer: "#261023"
    property string primaryContainerText: "#bc9ab3"
    
    property string secondary: "#d4c1cd"
    property string secondaryText: "#392d36"
    property string secondaryContainer: "#554751"
    property string secondaryContainerText: "#f6e2ee"
    
    property string tertiary: "#efb9ba"
    property string tertiaryText: "#492728"
    property string tertiaryContainer: "#2c0f11"
    property string tertiaryContainerText: "#c99798"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#151314"
    property string surfaceText: "#e8e1e3"
    property string surfaceVariant: "#4d444a"
    property string surfaceVariantText: "#d0c3ca"
    
    property string outline: "#998e94"
    property string outlineVariant: "#4d444a"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e8e1e3"
    property string inverseSurfaceText: "#332f31"
    property string inversePrimary: "#72556c"
    
    property string surfaceDim: "#151314"
    property string surfaceBright: "#3c383a"
    property string surfaceContainerLowest: "#100d0f"
    property string surfaceContainerLow: "#1e1b1c"
    property string surfaceContainer: "#221f20"
    property string surfaceContainerHigh: "#2c292b"
    property string surfaceContainerHighest: "#373435"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/explorer_orange_sunset.jpg"
    

}
