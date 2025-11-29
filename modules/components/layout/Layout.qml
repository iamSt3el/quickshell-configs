import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import qs.modules.utils
import qs.modules.components.Bar
import qs.modules.settings
import qs.modules.components.AppLauncher
import qs.modules.components.ToolsWidget
import QtQuick.Effects

PanelWindow{
    id: layout
    color: "transparent"
    anchors{
        top: true 
        left: true
        right: true
        bottom: true
    }

        WlrLayershell.keyboardFocus: appLauncher.container.isClicked ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    mask: Region{
        item: maskRect;
        intersection: Intersection.Xor;
        Region{
            x: workspaces.x;
            y: workspaces.y;
            width: workspaces.container.width;
            height: workspaces.container.height;
            intersection: Intersection.Subtract
        } 
        Region{
            x: appLauncher.x;
            y: appLauncher.y;
            width: appLauncher.container.width;
            height: appLauncher.container.height;
            intersection: Intersection.Subtract
        }
        Region{
            x: isToolsWidgetClicked ? loader.x : 0;
            y: isToolsWidgetClicked ? loader.y : 0;
            width: isToolsWidgetClicked ? loader.width : 0;
            height: isToolsWidgetClicked ? loader.height : 0;
            intersection: Intersection.Subtract

        }
    }
    Rectangle{
        id: maskRect
        implicitHeight: parent.height - 40
        implicitWidth: parent.width
        anchors.bottom: parent.bottom
        color: "transparent"
    }

    property bool isToolsWidgetClicked: false


    Shape{
        preferredRendererType: Shape.CurveRenderer   
        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
        }
        ShapePath{
            fillColor: Settings.layoutColor
            //fillColor: "transparent"
            strokeWidth: 0
            //strokeColor: "blue"
            
            startX: 0
            startY: 0
            PathLine{ x: layout.width; y: 0 }
            PathLine{ x: layout.width; y: layout.height }
            PathLine{ x: 0; y: layout.height }
            PathLine{ x: 0; y: 0 }
            
            PathMove{ x: workspaces.container.width; y: 20 }

            PathArc{
                relativeX: 20
                relativeY: -12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                x: clock.x - 20 
                y: 8
            }

            PathArc{
                relativeX: 20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: clock.container.width
                relativeY: 0
            }

            PathArc{
                relativeX: 20
                relativeY: -12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                x: utility.x - 20
                relativeY: 0
            }

            PathArc{
                relativeX: 20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: utility.container.width - 28
                relativeY: 0
            }
            PathLine{
                relativeX: 0
                relativeY: 20
            }
            
            PathArc{
                relativeX: 20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: 0
                relativeY: layout.height - utility.container.height - 32
            }

            PathArc{
                relativeX: -20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: -layout.width + 56
                relativeY: 0
            }

            PathArc{
                relativeX: -20
                relativeY: -12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                x: appLauncher.x + 8 
                y: appLauncher.y + appLauncher.container.height + 12
            }

            PathArc{
                x: appLauncher.x + 8 + Math.max(0, Math.min(20, (appLauncher.container.width - 8) / 292 * 20))
                y: appLauncher.y + appLauncher.container.height 
                radiusX: Math.max(0, Math.min(18, (appLauncher.container.width - 8) / 292 * 18))
                radiusY: 12
            }




            PathLine{
                x: appLauncher.x + 8 + Math.max(0, Math.min(20, (appLauncher.container.width - 8) / 292 * 20))
                y: appLauncher.y 
            }
            
            PathArc{
                x: appLauncher.x + 8
                y: appLauncher.y - 12
                radiusX: Math.max(0, Math.min(18, (appLauncher.container.width - 8) / 292 * 18))
                radiusY: 12
            }
            

             PathLine{
                x: workspaces.x + 8
                y: workspaces.y + workspaces.container.height + 12
            }

            PathArc{
                relativeX: 20
                relativeY: -12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: 0
                relativeY: -20
            }

            PathLine{
                relativeX: workspaces.container.width - 30
                relativeY: 0
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
        AppLauncher{
            id: appLauncher
        }

        GlobalShortcut{
            name: "toolsWidget"
            onPressed:{
                if(Hyprland.focusedMonitor.name === layout.screen.name){
                   layout.isToolsWidgetClicked = !layout.isToolsWidgetClicked 
                }
            }
        }


        Loader{
            id: loader
            active: layout.isToolsWidgetClicked
            anchors.centerIn: parent
            width: 300
            height: 300
            sourceComponent: Item{
                ToolsWidget{
                    id: toolsWidget
                }
            }
        }
    }
}
