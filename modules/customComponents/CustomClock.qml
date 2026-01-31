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

Item{
    id: root
    anchors.centerIn: parent
    implicitWidth: row.implicitWidth

    property string hourDigit1: {
        if(ServiceClock.hour > 12) return 0;
        else if(ServiceClock.hour >= 10) return ServiceClock.hour[0];
        return ServiceClock.hour[0];
    }
    property string hourDigit2: {
        if(ServiceClock.hour > 12) return ServiceClock.hour - 12;
        else if(ServiceClock.hour >= 10) return ServiceClock.hour[1];
        return ServiceClock.hour[1];
    }
    property string minuteDigit1: ServiceClock.minute[0];
    property string minuteDigit2: ServiceClock.minute[1];
    property real fontSize: 30
    property real fontX: 5



    //color: "transparent"
    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: -3

        Item {
            width: text1.width
            height: text1.height

            CustomText {
                id: text1
                content: hourDigit1
                size: root.fontSize
                color:Colors.surfaceText
                layer.enabled: true
                visible: false
                font.family: "Titan One"
                style: Text.Raised
                styleColor: Colors.outline
                weight: 600
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
                    x: text1.width - root.fontX
                    y: -5
                    font.family: "Titan One"
                    color: "white"
                    style: Text.Raised
                    styleColor: Colors.outline
                    weight: 600
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
            color:Colors.primary
            font.family: "Titan One"
            style: Text.Raised
            styleColor: Colors.outline
            weight: 600
        }

        CustomText{
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            content: ":"
            size: root.fontSize
            font.family: "Titan One"
            bottomPadding: 5
            color: Colors.primary
            style: Text.Raised
            styleColor: Colors.outline
            weight: 600
        }

        Item {
            Layout.preferredWidth: text2.width
            Layout.preferredHeight: text2.height

            CustomText {
                id: text2
                content: minuteDigit1
                size: root.fontSize
                color:Colors.surfaceText
                layer.enabled: true
                visible: false
                font.family: "Titan One"
                renderType: Text.NativeRendering
                style: Text.Raised
                styleColor: Colors.outline
                weight: 600
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
                    x: text2.width - root.fontX
                    y: -5
                    font.family: "Titan One"
                    color: "white"
                    style: Text.Raised
                    styleColor: Colors.outline
                    weight: 600
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
            color:Colors.primary
            font.family: "Titan One"
            style: Text.Raised
            styleColor: Colors.outline
            weight: 600
        }

    }
}
