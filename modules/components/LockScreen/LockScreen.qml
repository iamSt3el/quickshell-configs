pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

Scope {
    id: root

    property bool screenLocked: false

    // LockContext is lightweight, keep it loaded
    LockContext {
        id: lockContext

        onUnlocked: {
            root.screenLocked = false
        }
    }

    WlSessionLock {
        id: lock
        locked: root.screenLocked

        WlSessionLockSurface {
            id: lockSurface
            color: "transparent"

            // Loader unloads the UI when not locked to save memory
            Loader {
                active: root.screenLocked
                anchors.fill: parent

                sourceComponent: LockSurface {
                    anchors.fill: parent
                    context: lockContext
                }
            }
        }
    }

    // Triggered by: hyprctl dispatch global quickshell:lock
    GlobalShortcut {
        name: "lock"
        description: "Lock the screen"

        onPressed: {
            root.screenLocked = true
        }
    }
}
