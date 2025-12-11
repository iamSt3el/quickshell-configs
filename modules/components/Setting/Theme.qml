import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Item{
    anchors.fill: parent
    anchors.margins: 5
    
    Flickable{
        anchors.fill: parent  
        contentHeight: column.implicitHeight
        contentWidth: width   
        clip: true
        
        ColumnLayout{
            id: column
            width: parent.width  
            spacing: 15          
            
            RowLayout{
                Layout.margins: 5
                IconImage {
                    implicitSize: 26
                    Layout.alignment: Qt.AlignVCenter
                    source: IconUtil.getSystemIcon("color")
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: Colors.primary
                        Behavior on colorizationColor{
                            ColorAnimation{
                                duration: 200
                            }
                        }
                        brightness: 0
                    } 
                }

                CustomText{
                    content: "Theme"
                    size: 20
                    color: Colors.primary
                }
            }

            ColumnLayout{
                Layout.margins: 5
                spacing: 0
                CustomText{
                    content: "Matugen Settings"
                    size: 18
                }

                RowLayout{
                    Layout.topMargin: 10
                    spacing: 5


                    ClippingWrapperRectangle{
                        Layout.preferredWidth: 240
                        Layout.preferredHeight: 160
                        radius: 10

                        Image{
                            anchors.fill: parent
                            source: Settings.wallpaper
                            fillMode: Image.PreserveAspectCrop
                            sourceSize: Qt.size(width, height)
                        }

                        layer.enabled: true
                        layer.effect: MultiEffect{
                            shadowEnabled: true
                            shadowBlur: 0.2
                            shadowOpacity: 1.0
                            shadowColor: Qt.alpha(Colors.shadow, 1)
                        }
                    }

                    ColumnLayout{
                        Layout.fillWidth: true
                        Rectangle{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 35
                            color: Colors.surfaceContainerHigh
                            radius: 10
                            RowLayout{
                                id: childRow
                                anchors.fill: parent
                                anchors.margins: 5
                                CustomText{
                                    Layout.fillWidth: true
                                    content: "Matugen"
                                    size: 14

                                }
                                CustomToogle{}
                            }
                        }

                        Rectangle{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 35
                            color: Colors.surfaceContainerHigh
                            radius: 10
                            RowLayout{
                                spacing: 60
                                anchors.fill: parent
                                anchors.margins: 5
                                CustomIconImage{
                                    icon: "wallpaper"
                                    size: 20
                                }

                                CustomText{
                                    Layout.fillWidth: true
                                    content: "⌘ + Ctrl + W"
                                    size: 14
                                }
                            }
                        }
                        RowLayout{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Rectangle{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: Settings.matugenSetting === "Light" ? Colors.primary : Colors.surfaceContainerHigh
                                radius: 10

                                CustomIconImage{
                                    anchors.centerIn: parent
                                    icon: "sun"
                                    size: 24
                                    color: Settings.matugenSetting === "Light" ? Colors.primaryText : Colors.surfaceVariantText
                                    
                                }

                                Behavior on color{
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked:{
                                        if(Settings.matugenSetting !== "Light"){
                                            Settings.setMatugenSetting("Light")
                                        }
                                    }
                                }
                            }
                            Rectangle{
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                color: Settings.matugenSetting === "Dark" ? Colors.primary : Colors.surfaceContainerHigh
                                Behavior on color{
                                    ColorAnimation {
                                        duration: 200
                                    }
                                }
                                radius: 10
                                CustomIconImage{
                                    anchors.centerIn: parent
                                    color: Settings.matugenSetting === "Dark" ? Colors.primaryText : Colors.surfaceVariantText
                                    icon: "moon"
                                    size: 24
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked:{
                                        if(Settings.matugenSetting !== "Dark"){
                                            Settings.setMatugenSetting("Dark")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Flow {
                id: flow
                Layout.leftMargin: 5
                Layout.rightMargin: 5
                Layout.fillWidth: true
                spacing: 2

                Repeater {
                    model: Settings.matugen
                    delegate: Rectangle {
                        id: button
                        required property int index
                        required property var modelData
                        property bool active: Settings.matugenTheme === modelData.name
                        property bool leftmost: index === 0
                        property bool rightmost: index === Settings.matugen.length - 1

                        onYChanged: {
                            if (index === 0) {
                                button.leftmost = true
                            } else {
                                var prev = flow.children[index - 1]
                                var thisIsOnNewLine = prev && prev.y !== button.y
                                button.leftmost = thisIsOnNewLine
                                prev.rightmost = thisIsOnNewLine
                            }
                        }

                        implicitWidth: childText.width + 20
                        implicitHeight: childText.height + 20

                        topLeftRadius: (active || leftmost) ? height / 2 : 5
                        topRightRadius: (active || rightmost) ? height / 2 : 5
                        bottomLeftRadius: (active || leftmost) ? height / 2 : 5
                        bottomRightRadius: (active || rightmost) ? height / 2 : 5

                        color: active ? Colors.primary : Colors.surfaceContainerHigh

                        Behavior on topLeftRadius {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                        Behavior on topRightRadius {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                        Behavior on bottomLeftRadius {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                        Behavior on bottomRightRadius {
                            NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                        }
                        Behavior on color {
                            ColorAnimation { duration: 100 }
                        }

                        CustomText {
                            id: childText
                            anchors.centerIn: parent
                            content: modelData.name
                            size: 13
                            color: button.active ? Colors.primaryText : Colors.surfaceVariantText
                            weight: 600
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Settings.setMatugenTheme(modelData.name)
                                Quickshell.execDetached(["matugen", "image", Settings.wallpaper, "-t", modelData.cmd])
                            }
                        }
                    }
                }
            }



        }
    }
}

