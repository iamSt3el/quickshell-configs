pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.modules.utils
import qs.modules.settings
import qs.modules.customComponents
import qs.modules.services 


Rectangle {
    id: root
    required property LockContext context
    focus: true
    property bool inputExpanded: false
    color: Colors.surface

    Keys.onPressed: (event) => {
        if(!inputExpanded){
            inputExpanded = true
            input.forceActiveFocus();
            if(event.text.length > 0 && !event.modifiers){
                input.text = event.text;
            }
        }
    }

    Image{
        id: background
        source: WallpaperTheme.wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize: Qt.size(width, height)

        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 0.1
            blurMax: 40
            autoPaddingEnabled: false
        }
    }

    ColumnLayout{
        anchors.centerIn: parent
        spacing: 0
        RowLayout{
            id: clockRow
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing:0
            CustomText{
                content: ServiceClock.hour
                size: 160
                style: Text.Raised
                styleColor: Colors.outline
                font.bold: false


            }

            CustomText{
                content: ":"
                size: 120
                bottomPadding: 32
                style: Text.Raised
                weight: 400
                color: Colors.outline
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: ServiceClock.minute
                size: 160
                style: Text.Raised
                styleColor: Colors.outline
                font.bold: false

            }

            CustomText{
                Layout.preferredWidth: 80
                content: ServiceClock.seconds
                size: 60
                style: Text.Raised
                weight: 400
                color: Colors.outline
                styleColor: Colors.outline
                font.bold: false
            }
        }

        RowLayout{
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            spacing: 10
            CustomIconImage{
                icon: "calender"
                size: 30
            }
            CustomText{
                content: ServiceClock.day
                size: 30
                style: Text.Raised
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: "."
                size: 40
                style: Text.Raised
                bottomPadding: 15
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: ServiceClock.month
                size: 30
                style: Text.Raised
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: ServiceClock.date
                size: 30
                style: Text.Raised
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: "."
                size: 40
                style: Text.Raised
                bottomPadding: 15
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }

            CustomText{
                content: ServiceClock.year
                size: 30
                style: Text.Raised
                weight: 400
                styleColor: Colors.outline
                font.bold: false
            }
        }
    }



    RowLayout{
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 20
        spacing: 10
        anchors{
            bottom: parent.bottom
            bottomMargin: 20
        }

        CustomRectangle{
            Layout.preferredWidth: 160
            Layout.preferredHeight: 80
            radius: 20
            background: background


            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 0
                ClippingWrapperRectangle{
                    Layout.preferredHeight: 50
                    Layout.preferredWidth: 50
                    radius: height

                    border{
                        width: 1
                        color: Colors.outline
                    }

                    Image{
                        anchors.fill: parent
                        sourceSize: Qt.size(width, height)
                        source: Settings.profile
                    }
                }

                ColumnLayout{
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 10
                    Layout.margins: 10
                    CustomText{
                        Layout.fillHeight: true
                        content: "St3el"
                        size: 18
                    }
                    CustomText{
                        Layout.fillHeight: true
                        content: "Hyprland"
                        color: Colors.outline
                        size: 14
                    }
                }
            }

        }
        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CustomRectangle{
            Layout.preferredHeight: 80
            Layout.preferredWidth: 500
            

            transform: Translate {
                id: shakeTransform
                x: 0
            }
            radius: 20
            background: background


            // Reusable shake animation component
            component ShakeAnim: NumberAnimation {
                target: shakeTransform
                property: "x"
                duration: 100
                easing.type: Easing.InOutQuad
            }

            // Shake animation on auth failure
            SequentialAnimation {
                id: shakeAnimation
                running: root.context.showFailure

                ShakeAnim { to: -10; duration: 50; easing.type: Easing.OutQuad }
                ShakeAnim { to: 10 }
                ShakeAnim { to: -8 }
                ShakeAnim { to: 8 }
                ShakeAnim { to: -4 }
                ShakeAnim { to: 4 }
                ShakeAnim { to: 0; duration: 50; easing.type: Easing.InQuad }
            }

            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                Rectangle{
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    color: Colors.surfaceContainerHigh
                    radius: 20
                    CustomIconImage{
                        anchors.centerIn: parent
                        icon: "lock"
                        size: 26
                    }
                }

                TextField{
                    id: input
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    placeholderText: "Enter password"
                    placeholderTextColor: Colors.outline
                    inputMethodHints: Qt.ImhSensitiveData
                    background: null
                    clip: true
                    text: ""
                    font.pixelSize: 20
                    font.weight: 600
                    color: Colors.surfaceText
                    echoMode: TextInput.Password
                    verticalAlignment: TextInput.AlignVCenter
                    enabled: !root.context.unlockInProgress


                    onTextChanged: {
                        root.context.currentText = this.text;
                    }
                    onAccepted: root.context.tryUnlock();


                    Connections {
                        target: root.context

                        function onCurrentTextChanged() {
                            input.text = root.context.currentText;
                        }
                    }
                } 

                Rectangle{
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    radius: 20
                    visible: input.text.length > 0

                    color: Colors.primary

                    Loader{
                        active: !root.context.unlockInProgress
                        anchors.centerIn: parent
                        sourceComponent:CustomIconImage{
                            anchors.centerIn: parent
                            icon: "rightArrow"
                            size: 26
                            color: Colors.primaryText
                        }
                    }

                    Loader{
                        active: root.context.unlockInProgress
                        anchors.centerIn: parent
                        sourceComponent: CustomLoader{
                            anchors.centerIn: parent
                            size: 40
                            running: true
                        }
                    }

                }
            }
        }

        Item{
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        CustomRectangle{
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            radius: 10
            background: background
            CustomIconImage{
                anchors.centerIn: parent
                icon: "restart"
                size: 20
            }
        }

        CustomRectangle{
            Layout.preferredHeight: 50
            Layout.preferredWidth: 50
            radius: 10
            background: background
            CustomIconImage{
                anchors.centerIn: parent
                icon: "power"
                size: 20
            }
        }
    }
}
