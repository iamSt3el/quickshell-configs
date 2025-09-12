//@ pragma UseQApplication
import Quickshell
import QtQuick
import qs.modules.windows.Bar
import qs.modules.windows.AppLauncher
import qs.modules.windows.WorkspaceOverview
import qs.modules.windows.ToolsWidget
import qs.modules.services

ShellRoot {
    Scope{
        id: root


        Variants{
            model: Quickshell.screens
            delegate: Item {
                required property var modelData
    
                
                 Loader {
                    // Only create AppLauncher on primary screen (index 0)
                    active: ServiceIpcHandler.isToolWidgetVisible && modelData === Quickshell.screens[0]
                    sourceComponent: Component{
                                ToolsWidget{}
                    }
                }
             
                
                Bar {
                    screen: modelData
                }
                
                Loader {
                    // Only create AppLauncher on primary screen (index 0)
                    active: ServiceIpcHandler.isAppLauncherVisible && modelData === Quickshell.screens[0]
                    sourceComponent: Component{
                        AppLauncher{}
                    }
                }

                Loader {
                    // Only create WorkspaceOverview on focused monitor
                    active: ServiceIpcHandler.isWorkspaceOverviewVisible && modelData === Quickshell.screens[0]
                    sourceComponent: Component{
                        WorkspaceOverview{}
                    }
                }

            }
        }
    }   
}

