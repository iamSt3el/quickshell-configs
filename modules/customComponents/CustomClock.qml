import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Effects
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services

Rectangle{
    id: root
    implicitWidth: 600
    implicitHeight: 200
    radius: 20
    anchors.centerIn: parent

    property string hourDigit1: ServiceClock.hour[0];
    property string hourDigit2: ServiceClock.hour[1];
    property string minuteDigit1: ServiceClock.minute[0];
    property string minuteDigit2: ServiceClock.minute[1];
    property real fontSize: 160



    color: "transparent"
    RowLayout {
        anchors.centerIn: parent
        spacing: -26

        Item {
            width: text1.width
            height: text1.height

            CustomText {
                id: text1
                content: hourDigit1
                size: root.fontSize
                font.bold: true
                color:Colors.surfaceText
                layer.enabled: true
                visible: false
                font.family: "Titan One"
                style: Text.Raised
                styleColor: Colors.outline
            }

            Item {
                id: maskItem
                width: parent.width
                height: parent.height
                layer.enabled: true  
                visible: false

                CustomText {
                    id: child
                    content: hourDigit2
                    size: root.fontSize + 10
                    x: text1.width - 30
                    y: -5
                    font.bold: true
                    font.family: "Titan One"
                    color: "white"
                    style: Text.Raised
                    styleColor: Colors.outlin
                }
            }

            MultiEffect {
                source: text1
                anchors.fill: text1
                maskEnabled: true
                maskSource: maskItem
                maskInverted: true  
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        } 
        CustomText {
            content: hourDigit2
            size: root.fontSize
            font.bold: true
            color:Colors.primary
            font.family: "Titan One"
            style: Text.Raised
            styleColor: Colors.outlin
        }

        CustomText{
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            content: ":"
            size: 150
            font.family: "Titan One"
            bottomPadding: 30
            color: Colors.primary
            style: Text.Raised
            styleColor: Colors.outlin
        }

        Item {
            Layout.preferredWidth: text2.width
            Layout.preferredHeight: text2.height

            CustomText {
                id: text2
                content: minuteDigit1
                size: root.fontSize
                font.bold: true
                color:Colors.surfaceText
                layer.enabled: true
                visible: false
                font.family: "Titan One"
                renderType: Text.NativeRendering
                style: Text.Raised
                styleColor: Colors.outlin
            }

            Item {
                id: maskItem2
                width: parent.width
                height: parent.height
                layer.enabled: true 
                visible: false

                CustomText {
                    id: child2
                    content: minuteDigit2
                    size: root.fontSize + 10
                    x: text2.width - 30
                    y: -5
                    font.bold: true
                    font.family: "Titan One"
                    color: "white"
                    style: Text.Raised
                    styleColor: Colors.outlin
                }
            }

            MultiEffect {
                source: text2
                anchors.fill: text2
                maskEnabled: true
                maskSource: maskItem2
                maskInverted: true  
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        } 
        CustomText {
            content: minuteDigit2
            size: root.fontSize
            font.bold: true
            color:Colors.primary
            font.family: "Titan One"
            style: Text.Raised
            styleColor: Colors.outlin
        }

    }
}
