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

GridView{
    id: appList
    anchors.fill: parent
    cellWidth: (width) / 4
    cellHeight: 100
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
        width: appList.cellWidth
        height: appList.cellHeight
        color: "transparent"

        radius: 10
        ColumnLayout{
            anchors.fill: parent
            spacing: 0
            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                radius: 10
                color: appList.activeIndex === index ? Colors.primary : "transparent"
                Image{
                    anchors.centerIn: parent
                    height: 60
                    width: 60
                    sourceSize: Qt.size(width, height)
                    asynchronous: true
                    source: IconUtil.getIconPath(modelData.icon)
                }
            }
            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true
                CustomText{
                    anchors.top: parent.top
                    width: parent.width
                    height: parent.height
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    content: modelData.name
                    size: 12
                }
            }
        }

    }
}
