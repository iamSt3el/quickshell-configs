import QtQuick
import Quickshell

Scope {
    PanelWindow {
        id: demoWindow
        implicitWidth: 400
        implicitHeight: 300
        margins {
            top: 100
        }

        color: "transparent"

        // Background content to show the blur effect
        Rectangle {
            id: backgroundContent
            anchors.fill: parent
            z: 0

            gradient: Gradient {
                GradientStop { position: 0.0; color: "#FF6B6B" }
                GradientStop { position: 0.5; color: "#4ECDC4" }
                GradientStop { position: 1.0; color: "#45B7D1" }
            }


        }

        // Liquid Glass Panel
        Item {
            id: glassPanel
            anchors.centerIn: parent
            width: 360
            height: 260
            z: 1

            // Capture the background
            ShaderEffectSource {
                id: blurSource
                sourceItem: backgroundContent
                anchors.fill: parent
                sourceRect: Qt.rect(glassPanel.x, glassPanel.y, glassPanel.width, glassPanel.height)
                live: true
            }

            // Liquid Glass Shader Effect
            ShaderEffect {
                id: liquidGlass
                anchors.fill: parent

                property variant source: blurSource
                property real blurRadius: 12.0        // Moderate blur for liquid glass
                property real saturation: 1.3         // Enhanced colors through glass
                property real brightness: 1.08        // Slight luminosity
                property real glassOpacity: 0.65      // Semi-transparent base
                property color tint: Qt.rgba(0.95, 0.98, 1.0, 0.06)  // Cool tint (slight blue)
                property real time: 0.0

                NumberAnimation on time {
                    from: 0.0
                    to: 100.0
                    duration: 100000
                    loops: Animation.Infinite
                }

                vertexShader: "file:///home/steel/.config/quickshell/shaders/liquidglass.vert.qsb"
                fragmentShader: "file:///home/steel/.config/quickshell/shaders/liquidglass.frag.qsb"
            }

            // Outer shadow for depth
            Rectangle {
                anchors.fill: parent
                anchors.margins: -2
                color: "transparent"
                border.color: Qt.rgba(0.0, 0.0, 0.0, 0.15)
                border.width: 2
                radius: 22
                z: -1
            }

            // Main glass border
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: Qt.rgba(1.0, 1.0, 1.0, 0.4)
                border.width: 1
                radius: 20
            }

            // Top highlight (light refraction)
            Rectangle {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    margins: 1
                }
                height: parent.height * 0.3
                color: Qt.rgba(1.0, 1.0, 1.0, 0.08)
                radius: 19
                clip: true
            }

            // Content overlay
            Column {
                anchors.centerIn: parent
                spacing: 20

                Text {
                    text: "Liquid Glass"
                    font.pixelSize: 36
                    font.weight: Font.Bold
                    color: "white"
                    anchors.horizontalCenter: parent.horizontalCenter
                    style: Text.Outline
                    styleColor: Qt.rgba(0, 0, 0, 0.4)
                }

                Text {
                    text: "Apple-style vibrancy effect"
                    font.pixelSize: 16
                    color: Qt.rgba(1.0, 1.0, 1.0, 0.95)
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                // Glass button example
                Rectangle {
                    width: 220
                    height: 65
                    radius: 32.5
                    color: Qt.rgba(1.0, 1.0, 1.0, 0.18)
                    border.color: Qt.rgba(1.0, 1.0, 1.0, 0.35)
                    border.width: 1.5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Rectangle {
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                            margins: 1
                        }
                        height: parent.height / 2
                        radius: parent.radius - 1
                        color: Qt.rgba(1.0, 1.0, 1.0, 0.15)
                        opacity: 0.5
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Glass Button"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        color: "white"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.color = Qt.rgba(1.0, 1.0, 1.0, 0.25)
                        onExited: parent.color = Qt.rgba(1.0, 1.0, 1.0, 0.18)
                    }
                }
            }
        }
    }
}
