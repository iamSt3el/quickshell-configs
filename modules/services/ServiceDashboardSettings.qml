pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io

Singleton{
    id: root

    property alias settings: settingsJsonAdapter
    property string filePath: Quickshell.shellPath("dashboard-settings.json")

    Timer {
        id: fileWriteTimer
        interval: 100
        repeat: false
        onTriggered: {
            settingsFileView.writeAdapter()
        }
    }

    FileView {
        id: settingsFileView
        path: root.filePath

        onAdapterUpdated: fileWriteTimer.restart()
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                fileWriteTimer.restart();
            }
        }

        adapter: JsonAdapter {
            id: settingsJsonAdapter

            // Dashboard display settings
            property bool showNotifications: true
            property bool showSystemStats: true
            property bool showMusicPlayer: true
            property bool showWeather: true

            // Theme settings
            property string themeMode: "auto" // "light", "dark", "auto"
            property int accentColorIndex: 0

            // Typography settings (from Typography.qml)
            property string primaryFont: "Iosevka"
            property string monoFont: "CaskaydiaCove NF"
            property string digitalFont: "Digital-7"
            property string nothingFont: "nothing-font-5x7"
            property string materialFont: "Material Symbols Rounded"
            property string cartoonFont: "Super Trend"
            property string orbitronFont: "Orbitron"

            // Font sizes (from Typography.qml)
            property int tinySize: 10
            property int smallSize: 12
            property int captionSize: 14
            property int bodySize: 16
            property int subtitleSize: 18
            property int titleSize: 20
            property int headingSize: 24
            property int displaySize: 28
            property int heroSize: 32

            // Font weights (from Typography.qml)
            property int thinWeight: 100
            property int lightWeight: 300
            property int normalWeight: 400
            property int mediumWeight: 500
            property int boldWeight: 600
            property int heavyWeight: 900

            // Dimensions - Spacing (from Dimensions.qml)
            property int tinySpacing: 4
            property int smallSpacing: 8
            property int normalSpacing: 12
            property int mediumSpacing: 16
            property int largeSpacing: 20
            property int xlargeSpacing: 24
            property int xxlargeSpacing: 32
            property int hugeSpacing: 40

            // Dimensions - Radius (from Dimensions.qml)
            property int smallRadius: 6
            property int normalRadius: 10
            property int mediumRadius: 15
            property int largeRadius: 20
            property int xlargeRadius: 25
            property int roundRadius: 30

            // Dimensions - Icons (from Dimensions.qml)
            property int tinyIcon: 12
            property int smallIcon: 16
            property int normalIcon: 18
            property int mediumIcon: 20
            property int largeIcon: 32
            property int xlargeIcon: 40

            // Dimensions - Components (from Dimensions.qml)
            property int topBarHeight: 50
            property int componentHeight: 25
            property int componentWidth: 30
            property int cpuWidth: 135
            property int interactiveSize: 62
            property int wrapperHeight: 50

            // Dimensions - Position (from Dimensions.qml)
            property int positionX: 20
            property int positionY: 10

            // Animation settings (from Dimensions.qml)
            property int fastAnimation: 150
            property int normalAnimation: 250
            property int slowAnimation: 400
            property int verySlowAnimation: 600

            // StyledText settings (from StyledText.qml)
            property int defaultTextSize: 16
            property int defaultTextWeight: 200
            property bool textEffect: true
            property bool textScrolling: true
            property string defaultFontFamily: "Super Trend" // Typography.cartoon

            // Behavior settings
            property bool autoHideDashboard: false
            property int dashboardTimeout: 5000
            property bool animateTransitions: true

            // Layout settings
            property string dashboardLayout: "default" // "default", "compact", "detailed"
            property bool showIcons: true
            property int iconSize: 24

            // Wallpaper path (from Colors.qml)
            property string wallpaperPath: "/home/steel/wallpaper/plane_sunset.png"
        }
    }

    // Convenience functions
    function setShowNotifications(value) {
        settings.showNotifications = value
    }

    function setShowSystemStats(value) {
        settings.showSystemStats = value
    }

    function setShowMusicPlayer(value) {
        settings.showMusicPlayer = value
    }

    function setShowWeather(value) {
        settings.showWeather = value
    }

    function setThemeMode(mode) {
        settings.themeMode = mode
    }

    function setAccentColorIndex(index) {
        settings.accentColorIndex = index
    }

    function setAutoHideDashboard(value) {
        settings.autoHideDashboard = value
    }

    function setDashboardTimeout(timeout) {
        settings.dashboardTimeout = timeout
    }

    function setAnimateTransitions(value) {
        settings.animateTransitions = value
    }

    function setDashboardLayout(layout) {
        settings.dashboardLayout = layout
    }

    function setShowIcons(value) {
        settings.showIcons = value
    }

    function setIconSize(size) {
        settings.iconSize = size
    }
}