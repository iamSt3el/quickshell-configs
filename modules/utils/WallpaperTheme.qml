pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#fcba5a"
    property string primaryText: "#452b00"
    property string primaryContainer: "#bf8529"
    property string primaryContainerText: "#000000"
    
    property string secondary: "#e5c193"
    property string secondaryText: "#422c0b"
    property string secondaryContainer: "#5b421f"
    property string secondaryContainerText: "#ffdaac"
    
    property string tertiary: "#becf6c"
    property string tertiaryText: "#2c3400"
    property string tertiaryContainer: "#88983c"
    property string tertiaryContainerText: "#000000"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#18130c"
    property string surfaceText: "#ece1d5"
    property string surfaceVariant: "#514537"
    property string surfaceVariantText: "#d5c4b1"
    
    property string outline: "#9d8e7d"
    property string outlineVariant: "#514537"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#ece1d5"
    property string inverseSurfaceText: "#362f28"
    property string inversePrimary: "#825500"
    
    property string surfaceDim: "#18130c"
    property string surfaceBright: "#3f3830"
    property string surfaceContainerLowest: "#120d07"
    property string surfaceContainerLow: "#201b14"
    property string surfaceContainer: "#241f18"
    property string surfaceContainerHigh: "#2f2922"
    property string surfaceContainerHighest: "#3a342c"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/World-Map-Light.png"
    

}
