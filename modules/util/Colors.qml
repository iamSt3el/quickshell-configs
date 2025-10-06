pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "#9dd49e"
    property string primaryText: "#023913"
    property string primaryContainer: "#1e5127"
    property string primaryContainerText: "#b8f1b9"
    
    property string secondary: "#b8ccb5"
    property string secondaryText: "#243424"
    property string secondaryContainer: "#3a4b3a"
    property string secondaryContainerText: "#d4e8d0"
    
    property string tertiary: "#a1ced6"
    property string tertiaryText: "#00363d"
    property string tertiaryContainer: "#1f4d54"
    property string tertiaryContainerText: "#bdeaf3"
    
    property string error: "#ffb4ab"
    property string errorText: "#690005"
    property string errorContainer: "#93000a"
    property string errorContainerText: "#ffdad6"
    
    property string surface: "#101510"
    property string surfaceText: "#e0e4db"
    property string surfaceVariant: "#424940"
    property string surfaceVariantText: "#c1c9be"
    
    property string outline: "#8c9389"
    property string outlineVariant: "#424940"
    property string shadow: "#000000"
    property string scrim: "#000000"
    
    property string inverseSurface: "#e0e4db"
    property string inverseSurfaceText: "#2d322c"
    property string inversePrimary: "#37693d"
    
    property string surfaceDim: "#101510"
    property string surfaceBright: "#363a35"
    property string surfaceContainerLowest: "#0b0f0b"
    property string surfaceContainerLow: "#181d18"
    property string surfaceContainer: "#1c211c"
    property string surfaceContainerHigh: "#272b26"
    property string surfaceContainerHighest: "#313630"
    
    // Wallpaper path
    property string wallpaper: "/home/steel/wallpaper/wallhaven-d85z1j_1920x1080.png"
    

}
