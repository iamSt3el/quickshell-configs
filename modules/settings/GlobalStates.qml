import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
pragma Singleton
pragma ComponentBehavior: Bound

Singleton{
    id: root
    property bool appLauncherOpen: false
    property bool clipboardOpen: false
    property bool settingsOpen: false
    property bool osdOpen: false
    property bool wallpaperOpen: false
    property bool musicVis: false
}
