pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#b8c4ff"
    property string primaryText: "#1f2c61"
    property string primaryContainer: "#374379"
    property string primaryContainerText: "#dde1ff"
    
    property string secondary: "#c2c5dd"
    property string secondaryText: "#2c2f42"
    property string secondaryContainer: "#424659"
    property string secondaryContainerText: "#dfe1f9"
    
    property string tertiary: "#e4bad9"
    property string tertiaryText: "#44273f"
    property string tertiaryContainer: "#5c3d56"
    property string tertiaryContainerText: "#ffd7f4"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#121318"
    property string surfaceText: "#e3e1e9"
    property string surfaceVariant: "#45464f"
    property string surfaceVariantText: "#c6c5d0"
    
    property string outline: "#90909a"
    property string outlineVariant: "#45464f"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e3e1e9"
    property string inverseSurfaceText: "#2f3036"
    property string inversePrimary: "#4f5b92"
    
    property string surfaceDim: "#121318"
    property string surfaceBright: "#38393f"
    property string surfaceContainerLowest: "#0d0e13"
    property string surfaceContainerLow: "#1b1b21"
    property string surfaceContainer: "#1f1f25"
    property string surfaceContainerHigh: "#292a2f"
    property string surfaceContainerHighest: "#34343a"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/rocket_launch.jpg"
    

}
