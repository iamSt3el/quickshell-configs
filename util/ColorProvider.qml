import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: colorProvider
    
    // Material You color properties (safe names to avoid QML conflicts)
    property string primary: "{{colors.primary.default.hex}}"
    property string primaryText: "{{colors.on_primary.default.hex}}"
    property string primaryContainer: "{{colors.primary_container.default.hex}}"
    property string primaryContainerText: "{{colors.on_primary_container.default.hex}}"
    
    property string secondary: "{{colors.secondary.default.hex}}"
    property string secondaryText: "{{colors.on_secondary.default.hex}}"
    property string secondaryContainer: "{{colors.secondary_container.default.hex}}"
    property string secondaryContainerText: "{{colors.on_secondary_container.default.hex}}"
    
    property string tertiary: "{{colors.tertiary.default.hex}}"
    property string tertiaryText: "{{colors.on_tertiary.default.hex}}"
    property string tertiaryContainer: "{{colors.tertiary_container.default.hex}}"
    property string tertiaryContainerText: "{{colors.on_tertiary_container.default.hex}}"
    
    property string error: "{{colors.error.default.hex}}"
    property string errorText: "{{colors.on_error.default.hex}}"
    property string errorContainer: "{{colors.error_container.default.hex}}"
    property string errorContainerText: "{{colors.on_error_container.default.hex}}"
    
    property string surface: "{{colors.surface.default.hex}}"
    property string surfaceText: "{{colors.on_surface.default.hex}}"
    property string surfaceVariant: "{{colors.surface_variant.default.hex}}"
    property string surfaceVariantText: "{{colors.on_surface_variant.default.hex}}"
    
    property string outline: "{{colors.outline.default.hex}}"
    property string outlineVariant: "{{colors.outline_variant.default.hex}}"
    property string shadow: "{{colors.shadow.default.hex}}"
    property string scrim: "{{colors.scrim.default.hex}}"
    
    property string inverseSurface: "{{colors.inverse_surface.default.hex}}"
    property string inverseSurfaceText: "{{colors.inverse_on_surface.default.hex}}"
    property string inversePrimary: "{{colors.inverse_primary.default.hex}}"
    
    property string surfaceDim: "{{colors.surface_dim.default.hex}}"
    property string surfaceBright: "{{colors.surface_bright.default.hex}}"
    property string surfaceContainerLowest: "{{colors.surface_container_lowest.default.hex}}"
    property string surfaceContainerLow: "{{colors.surface_container_low.default.hex}}"
    property string surfaceContainer: "{{colors.surface_container.default.hex}}"
    property string surfaceContainerHigh: "{{colors.surface_container_high.default.hex}}"
    property string surfaceContainerHighest: "{{colors.surface_container_highest.default.hex}}"
    
    // Wallpaper path
    property string wallpaper: "{{image}}"
    
    Component.onCompleted: {
        console.log("Material You colors loaded from wallpaper")
    }
}