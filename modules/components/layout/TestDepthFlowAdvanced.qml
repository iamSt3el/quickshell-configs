import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.modules.utils
import QtQuick.Effects

PanelWindow {
    id: root
    color: "transparent"
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true

    Item {
        anchors.fill: parent

        // Mouse tracking for parallax effect
        MouseArea {
            id: mouseTracker
            anchors.fill: parent
            hoverEnabled: true

            property real offsetX: 0
            property real offsetY: 0

            onPositionChanged: {
                // Normalize mouse position to [-1, 1] range
                offsetX = (mouseX / width - 0.5) * 2.0
                offsetY = (mouseY / height - 0.5) * 2.0
            }

            onExited: {
                // Reset to center when mouse leaves
                offsetX = 0
                offsetY = 0
            }

            // Smooth animation for mouse movement
            Behavior on offsetX {
                NumberAnimation {
                    duration: 800
                    easing.type: Easing.OutQuart
                }
            }
            Behavior on offsetY {
                NumberAnimation {
                    duration: 800
                    easing.type: Easing.OutQuart
                }
            }
        }

        // 3D Parallax Shader Effect with Ray Marching - Advanced Configurable
        ShaderEffect {
            id: shaderEffect
            anchors.fill: parent

            // Source image
            property variant source: Image {
                source: WallpaperTheme.wallpaper
                smooth: true
                mipmap: true
                fillMode: Image.PreserveAspectCrop
            }

            // Depth map (white = foreground/near, black = background/far)
            property variant depthMap: Image {
                source: "file:///home/steel/.config/quickshell/wallpaper_depth.png"
                smooth: true
                mipmap: false
                fillMode: Image.PreserveAspectCrop
            }

            // Mouse offset parameters
            property real offsetX: mouseTracker.offsetX
            property real offsetY: mouseTracker.offsetY

            // Configurable shader parameters
            property real parallaxStrength: strengthSlider.value
            property real height: heightSlider.value
            property real quality: qualitySlider.value
            property real zoom: zoomSlider.value
            property real isometric: isometricSlider.value
            property real steady: steadySlider.value

            // Shader files
            vertexShader: "file:///home/steel/.config/quickshell/shaders/parallax.vert.qsb"
            fragmentShader: "file:///home/steel/.config/quickshell/shaders/parallax_advanced.frag.qsb"
        }

        // Control panel
        Rectangle {
            id: controlPanel
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            width: 320
            height: controlColumn.height + 40
            color: "#DD000000"
            radius: 12
            border.color: "#44FFFFFF"
            border.width: 1

            Column {
                id: controlColumn
                anchors.centerIn: parent
                width: parent.width - 40
                spacing: 15

                Text {
                    text: "3D Parallax Controls"
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Parallax Strength
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Strength: " + strengthSlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: strengthSlider
                        width: parent.width
                        from: 0.0
                        to: 0.2
                        value: 0.08
                    }
                }

                // Height (depth intensity)
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Height: " + heightSlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: heightSlider
                        width: parent.width
                        from: 0.0
                        to: 0.6
                        value: 0.30
                    }
                }

                // Quality
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Quality: " + qualitySlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: qualitySlider
                        width: parent.width
                        from: 0.0
                        to: 1.0
                        value: 0.7
                    }
                }

                // Zoom
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Zoom: " + zoomSlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: zoomSlider
                        width: parent.width
                        from: 0.8
                        to: 1.5
                        value: 1.0
                    }
                }

                // Isometric (perspective blend)
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Isometric: " + isometricSlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: isometricSlider
                        width: parent.width
                        from: 0.0
                        to: 1.0
                        value: 0.3
                    }
                }

                // Steady (focal plane)
                Column {
                    width: parent.width
                    spacing: 5
                    Text {
                        text: "Steady: " + steadySlider.value.toFixed(2)
                        color: "#CCFFFFFF"
                        font.pixelSize: 12
                    }
                    Slider {
                        id: steadySlider
                        width: parent.width
                        from: 0.0
                        to: 1.0
                        value: 0.3
                    }
                }

                // Mouse position info
                Rectangle {
                    width: parent.width
                    height: 60
                    color: "#22FFFFFF"
                    radius: 6

                    Column {
                        anchors.centerIn: parent
                        spacing: 5
                        Text {
                            text: "Mouse: " + mouseTracker.offsetX.toFixed(2) + ", " + mouseTracker.offsetY.toFixed(2)
                            color: "white"
                            font.pixelSize: 11
                            font.family: "monospace"
                        }
                        Text {
                            text: "Move mouse to see effect"
                            color: "#AAFFFFFF"
                            font.pixelSize: 10
                        }
                    }
                }

                // Preset buttons
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 10

                    Button {
                        text: "Subtle"
                        onClicked: {
                            strengthSlider.value = 0.04
                            heightSlider.value = 0.20
                            qualitySlider.value = 0.6
                            isometricSlider.value = 0.2
                        }
                    }

                    Button {
                        text: "Default"
                        onClicked: {
                            strengthSlider.value = 0.08
                            heightSlider.value = 0.30
                            qualitySlider.value = 0.7
                            isometricSlider.value = 0.3
                        }
                    }

                    Button {
                        text: "Intense"
                        onClicked: {
                            strengthSlider.value = 0.15
                            heightSlider.value = 0.50
                            qualitySlider.value = 0.9
                            isometricSlider.value = 0.5
                        }
                    }
                }
            }
        }

        // Instructions
        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: 20
            width: instructionsText.width + 20
            height: instructionsText.height + 20
            color: "#AA000000"
            radius: 8

            Text {
                id: instructionsText
                anchors.centerIn: parent
                color: "#CCFFFFFF"
                font.pixelSize: 11
                text: "Algorithm: DepthFlow Ray Marching\n" +
                      "Dual-pass ray-surface intersection\n" +
                      "Move mouse for 3D parallax effect"
            }
        }
    }
}
