import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Scope{
    Loader{
        id: loader
        active: GlobalStates.settingsOpen
        sourceComponent:PanelWindow{
            id: panelWindow
            implicitWidth: 700
            implicitHeight: 700
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Normal
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
            color: "transparent"
                
            HyprlandFocusGrab{
                id: grab
                windows: [panelWindow]
                active: loader.active
                onCleared: () => {
                    if(!active) {
                      GlobalStates.settingsOpen = false
                    }
                }
            }

            SettingsContent{
                onSettingClosed: {
                   GlobalStates.settingsOpen = false
                }
            }


        }
    }

    GlobalShortcut{
        name: "settingOpen"
        onPressed:{
            GlobalStates.settingsOpen = !GlobalStates.settingsOpen 
        }
    }

}
