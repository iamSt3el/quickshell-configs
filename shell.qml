//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules.windows.Bar
import qs.modules.windows.AppLauncher
import qs.modules.windows.WorkspaceOverview
import qs.modules.windows.ToolsWidget
import qs.modules.windows.NotificationPanel
import qs.modules.services

ShellRoot {
    Scope{
        id: root


        Variants{
            model: Quickshell.screens
            delegate: Item {
                required property var modelData
            
                NotificationPanel{
                    screen: modelData[0]
                }
                Bar {
                    screen: modelData
                } 
            }
        }

           Loader {
                    active: ServiceIpcHandler.isAppLauncherVisible
                    sourceComponent: Component{
                        AppLauncher{}
                    }
                }

                Loader {
                    active: ServiceIpcHandler.isWorkspaceOverviewVisible
                    sourceComponent: Component{
                        WorkspaceOverview{}
                    }
                }

                Loader {
                    active: ServiceIpcHandler.isToolWidgetVisible
                    sourceComponent: Component{
                                ToolsWidget{}
                    }
                }
    }   
}

