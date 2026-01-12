import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.customComponents
import qs.modules.utils
import qs.modules.settings
import qs.modules.services


PopupWindow{
    id: root
    implicitWidth: 240
    implicitHeight: child.implicitHeight
    visible: true
    color: "transparent"
    signal close

    anchor{
        window: layout
        rect.x: utility.x
        rect.y: utility.y + utility.height + 2
    }

    HyprlandFocusGrab{
        id: focusGrab
        active: true
        windows: [QsWindow.window]
        onCleared: root.close()
    }

    Rectangle{
        id: child
        implicitWidth: parent.width
        implicitHeight: col.implicitHeight + 20
        scale: 0.8
        opacity: 0

        NumberAnimation on opacity{
            from: 0
            to: 1
            duration: 100
            running: true
        }

        NumberAnimation on scale{
            from: 0.8
            to: 1
            duration: 100
            running: true
        }

        color: Settings.layoutColor
        radius: 20


        ColumnLayout{
            id: col
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            RowLayout{
                CustomIconImage{
                    icon: "volume"
                    size: 18
                }
                CustomText{
                    Layout.fillWidth: true
                    content: "Output Devices"
                    size: 14
                }
            }
            CustomList{
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                list: ServicePipewire.sinks
                currentVal: ServicePipewire.sink ? ServicePipewire.sink.description : ""

                onIsListClickedChanged:{
                    if(isListClicked)
                    focusGrab.active = false
                    else 
                    focusGrab.active = true
                }

                onListChildClicked: (child) => ServicePipewire.setAudioSink(child)


            }

            RowLayout{
                CustomIconImage{
                    icon: "mic"
                    size: 18
                }
                CustomText{
                    Layout.fillWidth: true
                    content: "Input Devices"
                    size: 14
                }
            }
            CustomList{
                Layout.fillWidth: true
                Layout.preferredHeight: 30
                list: ServicePipewire.sources
                currentVal: ServicePipewire.source ? ServicePipewire.source.description : ""
                onIsListClickedChanged:{
                    if(isListClicked)
                    focusGrab.active = false
                    else 
                    focusGrab.active = true
                }

                onListChildClicked: (child) => ServicePipewire.setAudioSource(child)
            }
        }
    }
}
