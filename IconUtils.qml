// IconUtils.qml
pragma Singleton
import QtQuick
import Quickshell

QtObject {
    function getIconName(windowClass) {
        // Direct class-to-icon mapping for common apps
        const iconMap = {
            "firefox": "firefox",
            "google-chrome": "google-chrome",
            "chromium": "chromium",
            "code": "visual-studio-code",
            "discord": "discord",
            "spotify": "spotify",
            "kitty": "kitty",
            "alacritty": "Alacritty",
            "thunar": "thunar",
            "vlc": "vlc",
            "steam": "steam",
            "obsidian": "obsidian",
            "telegram": "telegram",
            "brave-browser": "brave-browser",
            "zen": "zen-browser",
            "emblem-mail": "telegram"

        }
        
        if (!windowClass) return ""
        var lowerClass = windowClass.toLowerCase()
        return iconMap[lowerClass] || lowerClass || ""
    }
    
    function getIconPath(windowClass, fallback = "application-x-executable") { 
        return Quickshell.iconPath(getIconName(windowClass), fallback)
    }
}
