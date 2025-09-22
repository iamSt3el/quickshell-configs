pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root

    property var screens: new Map()

    // Get or create visibility state for a specific screen
    function getVisibilities(screen: ShellScreen): PersistentProperties {
        const monitor = Hyprland.monitorFor(screen)
        if (!screens.has(monitor)) {
            const props = visibilityComponent.createObject(root)
            screens.set(monitor, props)
            return props
        }
        return screens.get(monitor)
    }

    // Toggle functions for components
    function toggleAppLauncher(screen: ShellScreen): void {
        const vis = getVisibilities(screen)
        vis.appLauncher = !vis.appLauncher

        // Close other overlays when opening app launcher
        if (vis.appLauncher) {
            vis.workspaceOverview = false
            vis.toolsWidget = false
            vis.bluetoothPanel = false
        }
    }

    function toggleWorkspaceOverview(screen: ShellScreen): void {
        const vis = getVisibilities(screen)
        vis.workspaceOverview = !vis.workspaceOverview

        // Close other overlays when opening workspace overview
        if (vis.workspaceOverview) {
            vis.appLauncher = false
            vis.toolsWidget = false
            vis.bluetoothPanel = false
        }
    }

    function toggleToolsWidget(screen: ShellScreen): void {
        const vis = getVisibilities(screen)
        vis.toolsWidget = !vis.toolsWidget

        // Close other overlays when opening tools widget
        if (vis.toolsWidget) {
            vis.appLauncher = false
            vis.workspaceOverview = false
            vis.bluetoothPanel = false
        }
    }

    function toggleBluetoothPanel(screen: ShellScreen): void {
        const vis = getVisibilities(screen)
        vis.bluetoothPanel = !vis.bluetoothPanel

        // Close other overlays when opening bluetooth panel
        if (vis.bluetoothPanel) {
            vis.appLauncher = false
            vis.workspaceOverview = false
            vis.toolsWidget = false
        }
    }

    // Query functions for components
    function isAppLauncherVisible(screen: ShellScreen): bool {
        return getVisibilities(screen).appLauncher
    }

    function isWorkspaceOverviewVisible(screen: ShellScreen): bool {
        return getVisibilities(screen).workspaceOverview
    }

    function isToolsWidgetVisible(screen: ShellScreen): bool {
        return getVisibilities(screen).toolsWidget
    }

    function isBluetoothPanelVisible(screen: ShellScreen): bool {
        return getVisibilities(screen).bluetoothPanel
    }

    // Close all overlays for a screen
    function closeAll(screen: ShellScreen): void {
        const vis = getVisibilities(screen)
        vis.appLauncher = false
        vis.workspaceOverview = false
        vis.toolsWidget = false
        vis.bluetoothPanel = false
    }

    // Close all overlays on all screens
    function closeAllScreens(): void {
        for (const [monitor, vis] of screens) {
            vis.appLauncher = false
            vis.workspaceOverview = false
            vis.toolsWidget = false
            vis.bluetoothPanel = false
        }
    }

    // Component to create per-screen persistent state
    property Component visibilityComponent: Component {
        PersistentProperties {
            property bool appLauncher: false
            property bool workspaceOverview: false
            property bool toolsWidget: false
            property bool bluetoothPanel: false

            onAppLauncherChanged: root.stateChanged()
            onWorkspaceOverviewChanged: root.stateChanged()
            onToolsWidgetChanged: root.stateChanged()
            onBluetoothPanelChanged: root.stateChanged()
        }
    }

    // Global signal for any state change
    signal stateChanged()
}