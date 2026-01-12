import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Item{
    id: appLauncher
    anchors.fill: parent
    property var filteredApps:ServiceApps.filteredApps 

    Component.onCompleted:{
        timer.start()
        searchInput.forceActiveFocus()
    }
    signal closed

    onClosed: {
        col.visible = false
        searchInput.text = ""
        ServiceApps.reset()
        appList.activeIndex = 0
        appList.animationsEnabled = false
    }

    Rectangle{
        id: container
        anchors.fill: parent
        color: Settings.layoutColor
        topRightRadius: 20
        bottomRightRadius: 20
        clip: true

        Timer{
            id: timer
            interval: 300
            onTriggered:{
                col.visible = true
            }
        }


        ColumnLayout{
            id: col
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            visible: false
            
            opacity: 0
            scale: 0.8
                
            NumberAnimation on opacity{
                from: 0
                to: 1
                duration: 100
                running: col.visible
            }

            NumberAnimation on scale{
                from: 0.8
                to: 1
                duration: 100
                running: col.visible
            }

            Rectangle{
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                radius: 20
                color: Colors.surfaceContainer

                RowLayout{
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 10
                    CustomIconImage{
                        icon: "search"
                        size: 20
                    }

                    TextInput{
                        id: searchInput
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        focus: true
                        clip: true
                        width: parent.width - parent.height
                        text: ""
                        height: parent.height - 12
                        font.pixelSize: 16
                        font.weight: 800
                        color: Colors.inverseSurface
                        // Connections{
                        //     target: container
                        //     function onIsClickedChanged(){
                        //         if(!container.isClicked){
                        //             searchInput.text = ""
                        //         }
                        //     }
                        // }

                        onTextChanged: {
                            ServiceApps.updateSearch(text) 
                        }

                        onAccepted:{
                            if(filteredApps[appList.activeIndex]){
                                filteredApps[appList.activeIndex].execute()
                                appLauncher.closed()
                            }
                        }

                        Keys.onPressed: (event) => {
                            if(event.key === Qt.Key_Down){
                                if(appList.activeIndex < appList.count - 1){
                                    appList.activeIndex++
                                    appList.positionViewAtIndex(appList.activeIndex, ListView.Contain)
                                }
                            }

                            else if(event.key === Qt.Key_Up){
                                if(appList.activeIndex > 0){
                                    appList.activeIndex--
                                    appList.positionViewAtIndex(appList.activeIndex, ListView.Contain)
                                }
                            }else if(event.key === Qt.Key_Escape){
                                appLauncher.closed()
                            }

                        }

                    }
                }
            }

            ClippingWrapperRectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                radius: 10
                color: "transparent"

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

            }
        }
    }
}

