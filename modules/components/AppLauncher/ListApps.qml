import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

ListView{
    id: appList
    width: parent.width
    height: parent.height
    orientation: Qt.Vertical
    spacing: 10
    clip: true
    property int activeIndex: 0
    property bool animationsEnabled: false

    model: ScriptModel {
        values: appLauncher.filteredApps
        onValuesChanged: appList.animationsEnabled = true
    }

    add: Transition {
        enabled: appList.animationsEnabled

        NumberAnimation {
            properties: "opacity,scale"
            from: 0
            to: 1
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    remove: Transition {
        enabled: appList.animationsEnabled

        NumberAnimation {
            properties: "opacity,scale"
            from: 1
            to: 0
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    move: Transition {
        NumberAnimation {
            property: "y"
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            properties: "opacity,scale"
            to: 1
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    addDisplaced: Transition {
        NumberAnimation {
            property: "y"
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            properties: "opacity,scale"
            to: 1
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    displaced: Transition {
        NumberAnimation {
            property: "y"
            duration: 400
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            properties: "opacity,scale"
            to: 1
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    delegate: Rectangle{
        id: childIcon
        implicitHeight: 80
        implicitWidth: 280
        property bool active: appList.activeIndex === index
        color: active? Colors.primary : "transparent"
        radius: 20



        Behavior on color{
            ColorAnimation{
                duration: 100
            }
        }

        RowLayout{
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            Image{
                height: 50
                width: 50
                sourceSize: Qt.size(width, height)
                source: IconUtil.getIconPath(modelData.icon)
            }
            ColumnLayout{
                CustomText{
                    Layout.fillWidth: true
                    width: parent.width
                    content: modelData.name
                    size: 16
                    color: childIcon.active ? Colors.primaryText : Colors.surfaceVariantText
                }

                CustomText{
                    Layout.fillWidth: true
                    width: parent.width
                    content: modelData.genericName || modelData.comment
                    size: 14
                    color: childIcon.active ? Colors.outline : Colors.outline
                }
            }
        }

        MouseArea{
            id: appArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered:{
                appList.activeIndex = index
            }
            onClicked: {
                if(modelData){
                    modelData.execute()
                    appLauncher.closed()
                }
            }
        }
    }
}


