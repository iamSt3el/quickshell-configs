import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle{
    anchors.fill: parent
    //color: Settings.layoutColor
    //topLeftRadius: 20
    color: "transparent"
    clip: true

    ListView{
        id: list
        anchors.fill: parent
        anchors.margins: 10
        orientation: Qt.Vertical
        model: ScriptModel{
            values: [...ServiceNotification.popups].reverse()
        }

        spacing: 5

        add: Transition {
            NumberAnimation{
                property: "x"
                from: list.width
                to: 0
                duration: 300
                easing.type: Easing.OutQuad
            }
        }

        addDisplaced: Transition{
            NumberAnimation{
                property: "y"
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        move: Transition {
            NumberAnimation {
                property: "y"
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        displaced: Transition {
            NumberAnimation {
                property: "y"
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        delegate: Rectangle{
            id: itemWrapper
            implicitHeight: 80
            implicitWidth: parent ? parent.width : 0
            color: Colors.surfaceContainer
            radius: 10


            SequentialAnimation {
                id: removeAnimation
                PropertyAction {
                    target: itemWrapper;
                    property: "ListView.delayRemove";
                    value: true 
                }
                NumberAnimation {
                    target: itemWrapper
                    property: "x"
                    from: 0
                    to: list.width
                    duration: 300
                    easing.type: Easing.InQuad
                }
                PropertyAction { 
                    target: itemWrapper;
                    property: "ListView.delayRemove";
                    value: false 
                }
            }
            ListView.onRemove: removeAnimation.start()


            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15
                Rectangle{
                    Layout.preferredWidth: 40
                    Layout.preferredHeight: 40
                    Layout.alignment: Qt.AlignTop
                    radius: 10
                    color: Colors.surfaceContainerHighest
                    Image{
                        anchors.centerIn: parent
                        source : IconUtil.getIconPath(modelData.appIcon)
                        width: 35
                        height: 35
                        sourceSize: Qt.size(width, height)

                    }    
                }

                ColumnLayout{
                    spacing: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    CustomText{
                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                        content: modelData.appName
                        size: 16
                    }

                    CustomText{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        content: modelData.summary
                        size: 14
                    }
                }
            }
        }
    }
}
