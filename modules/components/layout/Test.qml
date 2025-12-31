import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.utils
import QtQuick.Effects
import qs.modules.customComponents

PanelWindow{
    id: root
    color: "transparent"
    property bool isClicked: false
    anchors.top: true
    anchors.left: true
    anchors.right: true
    anchors.bottom: true
    Rectangle{
        implicitWidth: close.width + 20
        implicitHeight: close.height + 20
        radius: 20
        color: Colors.surface
        CustomIconImage{
            id: close
            anchors.centerIn: parent
            icon: "close"
            size: 20
        }
    }
    Item {
        anchors.fill: parent

        // Mouse tracking
        MouseArea {
            id: mouseTracker
            anchors.fill: parent
            hoverEnabled: true

            property real offsetX: 0
            property real offsetY: 0

            onPositionChanged: {
                offsetX = (mouseX / width - 0.5) * 2.0
                offsetY = (mouseY / height - 0.5) * 2.0
            }

            onExited: {
                offsetX = 0
                offsetY = 0
            }

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

            // Mouse offset parameters
            property real offsetX: mouseTracker.offsetX
            property real offsetY: mouseTracker.offsetY
            property real parallaxStrength: 0.1 // Parallax intensity - test value
            property real aspectRatio: source.sourceSize.width / source.sourceSize.height

            // DepthFlow shaders with ray marching
            vertexShader: "file:///home/steel/.config/quickshell/shaders/parallax.vert.qsb"
            fragmentShader: "file:///home/steel/.config/quickshell/shaders/parallax.frag.qsb"
        }
    }

}
