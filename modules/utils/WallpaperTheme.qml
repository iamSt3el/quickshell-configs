pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#92d1d5"
    property string primaryText: "#003739"
    property string primaryContainer: "#5b9b9f"
    property string primaryContainerText: "#000000"
    
    property string secondary: "#b2cbcd"
    property string secondaryText: "#1d3435"
    property string secondaryContainer: "#344b4c"
    property string secondaryContainerText: "#cce5e6"
    
    property string tertiary: "#d2bdf1"
    property string tertiaryText: "#382852"
    property string tertiaryContainer: "#9b88b9"
    property string tertiaryContainerText: "#000000"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#111414"
    property string surfaceText: "#e1e3e2"
    property string surfaceVariant: "#3f4849"
    property string surfaceVariantText: "#bfc8c9"
    
    property string outline: "#899293"
    property string outlineVariant: "#3f4849"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e1e3e2"
    property string inverseSurfaceText: "#2e3131"
    property string inversePrimary: "#24686b"
    
    property string surfaceDim: "#111414"
    property string surfaceBright: "#373a3a"
    property string surfaceContainerLowest: "#0b0f0f"
    property string surfaceContainerLow: "#191c1c"
    property string surfaceContainer: "#1d2020"
    property string surfaceContainerHigh: "#272b2b"
    property string surfaceContainerHighest: "#323535"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/gruvbox_retrocity.png"
    

}
