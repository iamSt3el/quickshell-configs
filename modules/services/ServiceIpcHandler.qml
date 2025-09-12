pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io

Singleton{
    id: root

    property bool isAppLauncherVisible: false
    property bool isWorkspaceOverviewVisible: false
    property bool isToolWidgetVisible: false
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
