import Quickshell
import Quickshell.Wayland
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
import qs.modules.services


PanelWindow{
    id: layout
    color: "transparent"
    anchors{
        top: true 
        left: true
        right: true
        bottom: true
    }

        WlrLayershell.keyboardFocus: appLauncher.container.isClicked || isClipboardClicked ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
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

        Region{
            x: isSettingClicked ? settingsLoader.x : 0;
            y: isSettingClicked ? settingsLoader.y : 0;
            width: isSettingClicked ? settingsLoader.width : 0;
            height: isSettingClicked ? settingsLoader.height : 0;
            intersection: Intersection.Subtract
        }

        Region{
            x: utility.x
            y: utility.y
            width: utility.container.width
            height: utility.container.height
            intersection: Intersection.Subtract
        }

        Region{
            x: (layout.width - clipboardLoader.width) / 2
            y: layout.height - clipboardLoader.height
            width: clipboardLoader.width
            height: clipboardLoader.height
            intersection: Intersection.Subtract
        }

        Region{
            x: notificationLoader.x
            y: notificationLoader.y
            width: notificationLoader.width
            height: notificationLoader.height
            intersection: Intersection.Subtract
        }

        
    }
    Rectangle{
        id: maskRect
        implicitHeight: parent.height
        implicitWidth: parent.width
        anchors.bottom: parent.bottom
        color: isToolsWidgetClicked ? Qt.alpha(Colors.outline, 0.5) : "transparent"
        layer.enabled: true
        layer.effect: MultiEffect{
            saturation: 0.2
            blurEnabled: true
            blurMax: 7
            blur: 1

        }
    }

    property bool isToolsWidgetClicked: false
    property bool isSettingClicked: false
    property bool isClipboardClicked: false
    property bool isNotificationVisible: ServiceNotification.popups.length > 0 && screen.name === Hyprland.focusedMonitor.name


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
                relativeX: utility.width - 28
                relativeY: 0
            }
            PathLine{
                relativeX: 0
                relativeY: utility.height - 20
            }
            
            PathArc{
                relativeX: 20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            // PathLine{
            //     relativeX: 0
            //     relativeY: layout.height - utility.height - 32
            // }
            
            PathLine{
                relativeX: 0
                relativeY: layout.isNotificationVisible ? layout.height - notificationLoader.height - utility.height - 24 : layout.height - utility.height - 32
            }

            PathArc{
                relativeX: -20
                relativeY: 12
                radiusX: 18
                radiusY: 12
            }

            PathLine{
                relativeX: 0
                relativeY: layout.isNotificationVisible ? notificationLoader.height - 20 : 0
            }

            PathLine{
                relativeX: layout.isNotificationVisible ? -notificationLoader.width + 26 : 0
                relativeY: 0
            }

            PathArc{
                relativeX: -20
                relativeY: layout.isNotificationVisible ? 12 : 0
                radiusX: 18
                radiusY: layout.isNotificationVisible ? 12 : 0

            }

            PathLine{
                x: clipboardLoader.x + clipboardLoader.width + 20
                y: layout.height - 8
            }
            PathArc{
                relativeX: -20
                relativeY: - Math.max(0, Math.min(12, (clipboardLoader.height - 12) / 588 * 12))
                radiusX: 18
                radiusY: Math.max(0, Math.min(12, (clipboardLoader.height - 12) / 588 * 12))
            }

            PathLine{
                relativeX: -clipboardLoader.width
                relativeY: 0
            }

            PathArc{
                relativeX: -20
                relativeY: Math.max(0, Math.min(12, (clipboardLoader.height - 12) / 588 * 12))
                radiusX: 18
                radiusY: Math.max(0, Math.min(12, (clipboardLoader.height - 12) / 588 * 12))
            }



            PathLine{
                x: 8 + 12 + 6
                y: layout.height - 8
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

        GlobalShortcut{
            name: "clipboard"
            onPressed:{
                if(Hyprland.focusedMonitor.name === layout.screen.name){
                   layout.isClipboardClicked = !layout.isClipboardClicked
                }
            }
        }

        Loader{
            id: settingsLoader
            active: layout.isSettingClicked
            width: 600
            height: 600
            anchors.centerIn: parent
            sourceComponent: SettingWindow{
                id: settingsWindow
                onSettingClosed: layout.isSettingClicked = false
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
                    onToogled: layout.isToolsWidgetClicked = false
                    onSettingClicked: layout.isSettingClicked = true

                }
            }
        }

        Loader{
            id: clipboardLoader
            active: height !== 8
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 400
            height: layout.isClipboardClicked ? 600 : 8
            Behavior on height{
                NumberAnimation{
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            sourceComponent: Clipboard{
                id: clipboard
                isClicked: layout.isClipboardClicked
                onToClose: layout.isClipboardClicked = false
            }
        }

        Loader{
            id: notificationLoader
            active: screen.name === Hyprland.focusedMonitor.name
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            readonly property int notificationCount: ServiceNotification.popups.length
            property int displayCount: notificationCount

            height: displayCount > 0
                    ? Math.min(600, 10 + (displayCount * 90))
                    : 0
            width: 300

            Timer {
                id: heightUpdateTimer
                interval: 350
                onTriggered: {
                    notificationLoader.displayCount = notificationLoader.notificationCount
                }
            }

            onNotificationCountChanged: {
                if (notificationCount < displayCount) {
                    heightUpdateTimer.restart()
                } else {
                    displayCount = notificationCount
                }
            }


            Behavior on width{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on height{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            sourceComponent:NotificationPanel{

            }
        }
    }
}
