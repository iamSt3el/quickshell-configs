import Quickshell
import QtQuick
import Quickshell.Wayland
import qs.modules.components.layout

ShellRoot{
    Variants{
        model: Quickshell.screens
        delegate: Item{
            required property var modelData
            Layout{
                screen: modelData
            }
        }
    }
    
}
