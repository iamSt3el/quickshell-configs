import QtQuick
import QtQuick.Layouts
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

        // 3D Parallax Shader Effect with Ray Marching
        ShaderEffect {
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

            // Parallax parameters
            property real offsetX: mouseTracker.offsetX
            property real offsetY: mouseTracker.offsetY
            property real parallaxStrength: 0.08  // Adjust this for more/less effect

            // Shader files
            vertexShader: "file:///home/steel/.config/quickshell/shaders/parallax.vert.qsb"
            fragmentShader: "file:///home/steel/.config/quickshell/shaders/parallax.frag.qsb"
        }

        // Instructions overlay (remove after testing)
        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
            width: instructionsText.width + 20
            height: instructionsText.height + 20
            color: "#AA000000"
            radius: 8

            Text {
                id: instructionsText
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 14
                text: "Move mouse to see 3D parallax effect\n" +
                      "Offset: " + mouseTracker.offsetX.toFixed(2) + ", " +
                      mouseTracker.offsetY.toFixed(2) + "\n" +
                      "Strength: " + parent.parent.parent.children[1].parallaxStrength
            }
        }
    }
}
