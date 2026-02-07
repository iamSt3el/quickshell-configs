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
import qs.modules.components.Dock
import qs.modules.components.Osd
import qs.modules.services
import qs.modules.customComponents


PanelWindow{
    id: layout
    color: "transparent"
    anchors{
        top: true 
        left: true
        right: true
        bottom: true
    }

    WlrLayershell.keyboardFocus:WlrKeyboardFocus.None


 
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
            x: isToolsWidgetClicked ? loader.x : 0;
            y: isToolsWidgetClicked ? loader.y : 0;
            width: isToolsWidgetClicked ? loader.width : 0;
            height: isToolsWidgetClicked ? loader.height : 0;
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
            x: notificationLoader.x
            y: notificationLoader.y
            width: notificationLoader.width
            height: notificationLoader.height
            intersection: Intersection.Subtract
        }

        Region{
            x: clock.x
            y: clock.y
            width: clock.width
            height: clock.height
            intersection: Intersection.Subtract
        } 
        //
        // Region{
        //     x: demo.x
        //     y: demo.y
        //     width: demo.width
        //     height: demo.height
        //     intersection: Intersection.Subtract
        // }
    }


    // Rectangle{
    //     id: demo
    //     implicitHeight: 100
    //     implicitWidth: 100
    //     radius: height
    //     anchors.centerIn: parent
    //
    //     CustomLoader{
    //         anchors.centerIn: parent
    //         size: 80
    //     }
    // } 



    Rectangle{
        id: maskRect
        implicitHeight: parent.height
        implicitWidth: parent.width
        anchors.bottom: parent.bottom
        //color: isToolsWidgetClicked ? Qt.alpha(Colors.outline, 0.8) : "transparent"
       color: "transparent"
        // layer.enabled: true
        // layer.effect: MultiEffect{
        //     saturation: 0.5
        //     blurEnabled: true
        //     blurMax: 47
        //     blur: 1
        // }
    }


    //CustomClock{}

    //
    // Loader{
    //     id: osd
    //     active: layout.showOsd
    //     visible: active
    //     sourceComponent:Osd{
    //         onClose: layout.showOsd = false
    //     }
    // }
    



    property bool isToolsWidgetClicked: false
    property bool isSettingClicked: false
    property bool isNotificationVisible: !ServiceNotification.muted && !utility.isClicked && notificationLoader.displayCount > 0
    property bool showOsd: false

    Item{
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
        }

        Shape{
            preferredRendererType: Shape.CurveRenderer   

            ShapePath{
                strokeWidth: 0
                strokeColor: "transparent"
                fillColor: Settings.layoutColor
                //fillColor: "transparent"
                startX: 0
                startY: 0

                PathLine{
                    relativeX: 0
                    relativeY: workspaces.implicitHeight + Appearance.size.arcHeight
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: -Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }

                PathLine{
                    relativeX: 0
                    relativeY: -workspaces.implicitHeight + (Appearance.size.arcHeight + Appearance.size.lineWidth)
                }

                PathLine{
                    relativeX: workspaces.implicitWidth - Appearance.size.arcWidth
                    relativeY: 0
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: -Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }

                PathLine{
                    x: clock.x - Appearance.size.arcWidth
                    y: clock.y + Appearance.size.lineWidth
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }

                PathLine{
                    relativeX: clock.implicitWidth
                    relativeY: 0
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: -Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }


                PathLine{
                    x: utility.x - Appearance.size.arcWidth
                    y: utility.y + Appearance.size.lineWidth
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }

                PathLine{
                    relativeX: utility.width - Appearance.size.arcWidth
                    relativeY: 0
                }

                PathLine{
                    relativeX: 0
                    relativeY: utility.height - (Appearance.size.arcHeight + Appearance.size.lineWidth)
                }

                PathArc{
                    relativeX: Appearance.size.arcWidth
                    relativeY: Appearance.size.arcHeight
                    radiusX: Appearance.rounding.arcX
                    radiusY: Appearance.rounding.arcY
                }

                PathLine{
                    relativeX: 0
                    relativeY: -utility.height - (Appearance.size.arcHeight)
                }

                PathLine{
                    x: 0
                    y: 0
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
                    onToogled: layout.isToolsWidgetClicked = false

                }
            }
        }




        Loader{
            id: notificationLoader
            active: layout.isNotificationVisible
            anchors.bottom: parent.bottom
            anchors.right: parent.right

            readonly property int notificationCount: ServiceNotification.popups.length
            property int displayCount: notificationCount

            height: displayCount > 0
            ? Math.min(600, 10 + (displayCount * 90))
            : 8
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
                    duration: 300
                    easing.type: Easing.OutQuad
                }
            }

            sourceComponent:NotificationPanel{
            }
        }
    }
}
