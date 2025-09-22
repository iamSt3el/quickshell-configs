pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.services

Singleton{
    id: root

    // Properties delegate to StateManager but maintain the same interface
    property bool isAppLauncherVisible: false
    property bool isWorkspaceOverviewVisible: false
    property bool isToolWidgetVisible: false

    // Sync properties with StateManager on changes
    onIsAppLauncherVisibleChanged: {
        const vis = ServiceStateManager.getVisibilities(Quickshell.screens[0])
        if (vis.appLauncher !== isAppLauncherVisible) {
            vis.appLauncher = isAppLauncherVisible
            if (isAppLauncherVisible) {
                vis.workspaceOverview = false
                vis.toolsWidget = false
            }
        }
    }

    onIsWorkspaceOverviewVisibleChanged: {
        const vis = ServiceStateManager.getVisibilities(Quickshell.screens[0])
        if (vis.workspaceOverview !== isWorkspaceOverviewVisible) {
            vis.workspaceOverview = isWorkspaceOverviewVisible
            if (isWorkspaceOverviewVisible) {
                vis.appLauncher = false
                vis.toolsWidget = false
            }
        }
    }

    onIsToolWidgetVisibleChanged: {
        const vis = ServiceStateManager.getVisibilities(Quickshell.screens[0])
        if (vis.toolsWidget !== isToolWidgetVisible) {
            vis.toolsWidget = isToolWidgetVisible
            if (isToolWidgetVisible) {
                vis.appLauncher = false
                vis.workspaceOverview = false
            }
        }
    }

    // Sync back from StateManager to IpcHandler
    Connections {
        target: ServiceStateManager
        function onStateChanged() {
            const vis = ServiceStateManager.getVisibilities(Quickshell.screens[0])
            if (isAppLauncherVisible !== vis.appLauncher) {
                isAppLauncherVisible = vis.appLauncher
            }
            if (isWorkspaceOverviewVisible !== vis.workspaceOverview) {
                isWorkspaceOverviewVisible = vis.workspaceOverview
            }
            if (isToolWidgetVisible !== vis.toolsWidget) {
                isToolWidgetVisible = vis.toolsWidget
            }
        }
    }
    signal requestAppLauncherClose()
    signal requestWorkspaceOverviewClose()
    IpcHandler{
        target: "appLauncher"

        function toggleAppLauncher(): void{
            if (root.isAppLauncherVisible) {
                // Request close - animation will handle setting state to false
                root.requestAppLauncherClose()
            } else {
                root.isAppLauncherVisible = true
            }
        }
    }

    IpcHandler{
        target: "workspaceOverview"

        function toggleWorkspaceOverview(): void{
            if(root.isWorkspaceOverviewVisible){
                root.requestWorkspaceOverviewClose()
            }else{
                root.isWorkspaceOverviewVisible = true
            }
        }
    }

    IpcHandler{
        target: "toolwidget"

        function toggleToolWidget(): void{
            if(root.isToolWidgetVisible){
                root.isToolWidgetVisible = false
                //root.requestWorkspaceOverviewClose()
            }else{
                root.isToolWidgetVisible = true
            }
        }
    }
    
}
