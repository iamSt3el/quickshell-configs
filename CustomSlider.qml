import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import Quickshell.Hyprland
import QtQuick.Shapes
import Quickshell.Services.Pipewire


Item{
    id: sliderItem
    width: 50
    height: parent ? parent.height : 100
    property var icon
    property string sliderType: "generic"
    
    // Use shared system controller for synchronized values across monitors
    property real currentBrightness: SystemController.currentBrightness
    property real currentVolume: SystemController.currentVolume
    property real maxBrightness: SystemController.maxBrightness
    
    // Functions that delegate to SystemController
    function setVolume(percentage) {
        SystemController.setVolume(percentage);
    }
    
    function setBrightness(percentage) {
        SystemController.setBrightness(percentage);
    }
    
    function updateVolumeSliderPosition() {
        if (sliderType === "volume") {
            let percentage = currentVolume;
            sliderBall.y = (1 - percentage) * (slider.height - sliderBall.height);
        }
    }
    
    function updateSliderPosition() {
        if (sliderType === "brightness" && maxBrightness > 0) {
            let percentage = currentBrightness / maxBrightness;
            sliderBall.y = (1 - percentage) * (slider.height - sliderBall.height);
        }
    }
    
    Rectangle{
        id: slider
        implicitHeight: parent.height - 20
        implicitWidth: 40
        color: "#585B70"
        radius: 10
        anchors{
            centerIn: parent
        }
        Rectangle{
            id: sliderFill
            implicitHeight: {
                if (sliderType === "brightness") {
                    return maxBrightness > 0 ? (currentBrightness / maxBrightness) * parent.height : parent.height * 0.5;
                } else if (sliderType === "volume") {
                    return currentVolume * parent.height;
                } else {
                    return parent.height - sliderBall.y;
                }
            }
            implicitWidth: parent.width
            color: "#B4BEFE"
            radius: 10
            anchors{
                bottom: parent.bottom
            }
        }
        
        Rectangle{
            id: sliderBall
            implicitWidth: parent.width
            implicitHeight: parent.width 
            color: "#D9D9D9"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter

            MouseArea{
                id: sliderBallArea
                hoverEnabled: true
                anchors.fill: parent
                drag.target: sliderBall
                drag.axis: Drag.YAxis
                drag.minimumY: 0
                drag.maximumY: slider.height - (slider.width)

                cursorShape: Qt.PointingHandCursor
                
                onPositionChanged: {
                    if (drag.active) {
                        let percentage = (1 - (sliderBall.y / (slider.height - sliderBall.height))) * 100;
                        percentage = Math.max(0, Math.min(100, percentage));
                        
                        if (sliderType === "brightness") {
                            setBrightness(percentage);
                        } else if (sliderType === "volume") {
                            setVolume(percentage);
                        }
                    }
                }
            }

            Image{
                anchors.centerIn: parent
                source: icon ? "./assets/" + icon : ""
                width: 20
                height: 20
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                layer.effect: ColorOverlay{
                    color: "#11111B"
                }
            }
        }

    }
    
    // Watch for changes from SystemController (synchronized across all monitors)
    onCurrentVolumeChanged: {
        if (sliderType === "volume" && !sliderBallArea.drag.active) {
            updateVolumeSliderPosition();
        }
    }
    
    onCurrentBrightnessChanged: {
        if (sliderType === "brightness" && !sliderBallArea.drag.active) {
            updateSliderPosition();
        }
    }
    
    Component.onCompleted: {
        if (sliderType === "volume") {
            updateVolumeSliderPosition();
        } else if (sliderType === "brightness") {
            updateSliderPosition();
        }
    }
}

