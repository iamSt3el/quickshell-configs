pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.modules.util
import QtQuick

Loader {
    id: backgroundLoader

    active: true
    sourceComponent: PanelWindow {
            id: panel;
            WlrLayershell.layer: WlrLayer.Overlay
            //WlrLayershell.namespace: "Shell:Background"
            WlrLayershell.exclusionMode: ExclusionMode.Normal
            screen: Quickshell.screens[1]
            implicitWidth: 400
            implicitHeight: 100



            Item{
                id: root
                property bool isToggleOn: true
                implicitHeight: 30
                implicitWidth: 50
                anchors.centerIn: parent

                Rectangle{
                    id: track
                    anchors.fill: parent
                    radius: 20
                    color: root.isToggleOn ? Colors.primaryContainer : Qt.alpha(Colors.surface, 0.2)
                    border{
                        width: root.isToggleOn ? 2 : 2
                        color: Qt.alpha(Colors.surface, 0.8)
                    }

                    Behavior on color{
                        ColorAnimation{
                            duration: 400
                            easing.type: Easing.OutQuad
                        }
                    }

                    MouseArea{
                        id: toggleArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked:{
                            root.isToggleOn = !root.isToggleOn
                        }
                    }

                    Rectangle{
                        id: handle
                        anchors.verticalCenter: parent.verticalCenter
                        implicitWidth:root.isToggleOn? 20 : 15
                        implicitHeight: width
                        radius: 20
                        x: root.isToggleOn? track.width - (width + 6) : 6
                        color: root.isToggleOn ? "#ffffff" : Qt.alpha(Colors.surface, 0.8)

                        Behavior on implicitWidth{
                            NumberAnimation{
                                duration: 300
                                easing.type: Easing.OutQuad
                            }
                        }

                        Behavior on x{
                            NumberAnimation{
                                duration: 300
                                easing.type: Easing.OutElastic

                            }
                        }

                        MouseArea{
                    id: toggleButtonArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor

                    onClicked:{
                        if(root.isToggleOn){
                            root.isToggleOn = false
                            Quickshell.execDetached(["bluetoothctl", "power", "off"])
                        }else{
                            root.isToggleOn = true
                            Quickshell.execDetached(["bluetoothctl", "power", "on"])
                        }
                    }
                }


                    }
                }
            }
           
        }
    }
