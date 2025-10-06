import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components
import QtQuick.Effects
import qs.modules.services
import QtQuick.Layouts

Flickable{
    id: root
    contentHeight: userSection.implicitHeight + 20
    clip: true

    function openImagePicker() {
        ServiceFilePicker.pickImageFile("Choose User Image")
    }

    Rectangle{
        width: parent.width
        height: userSection.implicitHeight + 30
        radius: 16
        color: Colors.surfaceContainer

        ColumnLayout{
            id: userSection
            anchors.fill: parent
            anchors.margins: 15
            spacing: 12

        // Section header
        RowLayout{
            spacing: 8
            Image{
                width: 24
                height: 24
                source: IconUtils.getSystemIcon("user")
                sourceSize: Qt.size(width, height)
                layer.enabled: true
                layer.effect: MultiEffect{
                    brightness: 1
                    colorization: 1.0
                    colorizationColor: Colors.primary
                }
            }
            StyledText{
                content: "User Profile"
                size: 18
                font.weight: 600
                color: Colors.primary
            }
        }

        // User content
        RowLayout{
            Layout.fillWidth: true
            spacing: 15

            // Profile image
            ClippingRectangle{
                id: imageContainer
                Layout.preferredWidth: 70
                Layout.preferredHeight: 70
                radius: 12
                color: Qt.alpha(Colors.surface, 0.5)
                clip: true

                Image{
                    id: userImage
                    anchors.fill: parent
                    source: ServiceUserSettings.settings.userImagePath ? Qt.resolvedUrl(ServiceUserSettings.settings.userImagePath) : ""
                    fillMode: Image.PreserveAspectCrop
                    visible: ServiceUserSettings.settings.userImagePath !== ""
                    sourceSize: Qt.size(height, width)
                    smooth: true
                }

                Image{
                    id: placeholderIcon
                    anchors.centerIn: parent
                    width: parent.width * 0.5
                    height: width
                    source: IconUtils.getSystemIcon("user")
                    visible: ServiceUserSettings.settings.userImagePath === ""
                    sourceSize: Qt.size(width, height)

                    layer.enabled: true
                    layer.effect: MultiEffect{
                        brightness: 1
                        colorization: 1.0
                        colorizationColor: Colors.primary
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: openImagePicker()

                    Rectangle{
                        anchors.fill: parent
                        color: Qt.alpha(Colors.primary, 0.1)
                        radius: imageContainer.radius
                        visible: parent.containsMouse
                    }
                }
            }

            // User info
            ColumnLayout{
                Layout.fillWidth: true
                spacing: 8

                StyledText{
                    content: "Username"
                    size: 13
                    color: Colors.surfaceText
                    opacity: 0.7
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    radius: 8
                    color: Colors.surface
                    border.color: Colors.outline
                    border.width: 1

                    TextInput{
                        id: nameInput
                        anchors.fill: parent
                        anchors.margins: 12
                        text: ServiceUserSettings.settings.userName
                        color: Colors.surfaceText
                        font.pixelSize: 14
                        selectByMouse: true
                        verticalAlignment: TextInput.AlignVCenter

                        onEditingFinished: {
                            ServiceUserSettings.setUserName(text)
                        }
                    }
                }

                StyledText{
                    content: "Click profile image to change"
                    size: 11
                    color: Colors.surfaceText
                    opacity: 0.5
                }
            }
        }
        }
    }
}