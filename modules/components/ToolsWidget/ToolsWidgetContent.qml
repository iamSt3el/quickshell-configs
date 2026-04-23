import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Item{
    id: root
    implicitWidth: stackView.implicitWidth + 20
    implicitHeight: stackView.implicitHeight + 20
    anchors.centerIn: parent

    NumberAnimation on opacity{
        from: 0
        to: 1
        duration: 200
    }

    NumberAnimation on scale{
        from: 0.8
        to: 1
        duration: 200
    }

    Behavior on implicitWidth{
        NumberAnimation{
            duration: 100
            easing.type: Easing.OutQuad
        }
    }

    Behavior on implicitHeight{
        NumberAnimation{
            duration: 100
            easing.type: Easing.OutQuad
        }
    }

    
  

    StackView{
        id: stackView
        anchors.centerIn: parent
        implicitHeight: currentItem.implicitHeight
        implicitWidth: currentItem.implicitWidth


        pushEnter: Transition {
            NumberAnimation {
                duration: 0
            }
        }

        pushExit: Transition {
            NumberAnimation {
                duration: 0
            }
        }

        popEnter: Transition {
            NumberAnimation {
                duration: 0
            }
        }

        popExit: Transition {
            NumberAnimation {
                duration: 0
            }
        }

        initialItem: SubItem{
            overall: true
        }

        component SubItem: Item{
            id: root
            implicitHeight: loader?.implicitHeight
            implicitWidth: loader?.implicitWidth
            property bool show 
            opacity: show ? 1: 0
            scale: show ? 1 : 0.8

            property bool overall: false
            property bool camera: false
            property bool recording: false

            Component.onCompleted: show = true
            StackView.onActivated: show = true
            StackView.onDeactivated: show = false


            Behavior on opacity{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on scale{
                NumberAnimation{
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }

            Loader{
                id: loader
                width: item ? item.implicitWidth : 0
                height: item ? item.implicitHeight : 0
                active: root.overall || root.camera || root.recording
                sourceComponent: root.camera ? cameraToolsComp : root.recording ? recordingToolsComp : overallComp
            }

            Connections{
                target: loader.item
                ignoreUnknownSignals: true
                function onCameraClicked() {
                    stackView.push(subItemComp, { camera: true })
                }
                function onRecordingClicked() {
                    stackView.push(subItemComp, { recording: true })
                }
                function onBackClicked() {
                    stackView.pop()
                }
            }
        }

        Component{ id: overallComp; ToolsWidgetOverall{} }
        Component{ id: cameraToolsComp; CameraTools{} }
        Component{ id: recordingToolsComp; RecordingTools{} }

        Component{
            id: subItemComp
            SubItem{}
        }
    }
}
