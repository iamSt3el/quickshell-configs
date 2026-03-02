import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import qs.modules.utils
import qs.modules.components.Bar
import qs.modules.settings
import qs.modules.components.AppLauncher
import qs.modules.components.ToolsWidget
import qs.modules.components.Setting
import qs.modules.components.Clipboard
import qs.modules.components.Notification
import qs.modules.components.Dock
import qs.modules.components.Osd
import qs.modules.services
import qs.modules.customComponents

Item{
    id: root
    anchors.fill: parent
    property real disX: 20
    property real disY: 20
    property real radX: 20
    property real radY: 20
    property real lineDis: 6
    property real clockHeight: 0
    property real clockWidth: clock.width
    property real workspaceWidth: 100
    property real utilityWidth: 100
    Shape{
        preferredRendererType: Shape.CurveRenderer   
        ShapePath{
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: Colors.surface//"transparent"
            startX: 0
            startY: workspaces.height + root.disY

            PathArc{
                relativeX: root.disX
                relativeY: -root.disY
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                x: workspaces.width - root.disX
                relativeY: 0
            }

            PathArc{
                relativeX: root.disX
                relativeY: -root.disY
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: 0
                relativeY: -(workspaces.height - 2 * root.disY)
            }

            PathArc{
                relativeX: root.disX
                relativeY: -(root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
            } 

            PathLine{
                x: clock.x - root.disX
                relativeY: 0
            }
            
            PathArc{
                relativeX: root.disX
                relativeY: (root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                relativeX: 0
                relativeY: 0//(clock.height)
            }

            PathArc{
                relativeX: root.disX
                relativeY: (root.disY)
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: clock.width - 2 * root.disX
                relativeY: 0
            }

            PathArc{
                relativeX: root.disX
                relativeY: -(root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: 0
                relativeY: 0//-(clock.height - 2 * root.disY)
            }

            PathArc{
                relativeX: root.disX
                relativeY: -(root.disY)
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                x: utility.x - root.disX 
                relativeY: 0
            }

            PathArc{
                relativeX: root.disX
                relativeY:(root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                relativeX: 0
                relativeY: (utility.height - (root.disY + 2 * root.lineDis))
            }

            PathArc{
                relativeX: root.disX
                relativeY:(root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX: utility.width - 2 * root.disX
                relativeY: 0
            }

            PathArc{
                relativeX: root.disX
                relativeY:(root.disY - root.lineDis)
                radiusX: root.radX
                radiusY: root.radY
            }

            PathLine{
                relativeX: 0
                relativeY: - (utility.height + root.disY)
            }

            PathLine{
                x: 0
                y: 0
            }

            PathLine{
                relativeX: 0
                relativeY: workspaces.height + root.disY
            }
        }
    }


    Workspaces{
        id: workspaces
    }

    Clock{
        id: clock
    }

    Utility{
        id: utility
    }





}
