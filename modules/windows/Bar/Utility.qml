import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import qs.modules.util
import qs.modules.services
import qs.modules.components
import QtQuick.Effects

Item{
    id: wrapper
    width: utilityWrapper.width + 20
    height: parent.height
    property var screen
    property bool bluetoothOpen: ServiceStateManager.isBluetoothPanelVisible(screen)
    anchors{
        right: parent.right
    }

    
    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 1.0
        shadowColor: Qt.alpha(Colors.shadow, 1)
    }
    Shape{
        preferredRendererType: Shape.CurveRenderer
        ShapePath{
            fillColor: Colors.surfaceContainer
            strokeWidth: 0
            startX: utilityWrapper.x - 20
            startY: 0

            PathArc{
                relativeX: Dimensions.position.x
                relativeY: Dimensions.position.y
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
            }

            PathLine{
                relativeX: utilityWrapper.width - 20
                relativeY: 0
            }

            PathLine{
                relativeX: 0
                relativeY: utilityWrapper.height - 10
            }

            PathArc{
                relativeX: Dimensions.position.x
                relativeY: Dimensions.position.y
                radiusX: Dimensions.radius.large
                radiusY: Dimensions.radius.medium
            }

            PathLine{
                relativeX: 0
                relativeY: - utilityWrapper.height - 10
            }

        }
    }
    Rectangle{
        id: utilityWrapper
        //visible: false
        implicitWidth: utilityRow.width + 20
        implicitHeight: 40
        color: Colors.surfaceContainer
        bottomLeftRadius: 20
        anchors{
            right: parent.right
        }

        Row{
            id: utilityRow
            height: parent.height
            anchors.centerIn: parent
            spacing: 10

            Loader{
                anchors.verticalCenter: parent.verticalCenter
                active: ServiceTools.isRecording
                visible: active  // Hide when inactive
                width: active ? implicitWidth : 0  // Don't take up space when inactive
                sourceComponent: Component{
                    RecordingIndicator{}
                }
            }

        
            Loader{
                anchors.verticalCenter: parent.verticalCenter
                active: ServiceSystemTray.isActive
                visible: active  // Hide when inactive
                width: active ? implicitWidth : 0  // Don't take up space when inactive
                sourceComponent: Component{
                    SystemTray{}
                }
            }

            NetworkSpeed{}


            UtilityIcons{
                id: utilityIcons
                onBluetoothClicked: {
                    if (wrapper.bluetoothOpen) {
                        // Panel is open, start close sequence with animation
                        bluetoothLoader.item.close()  // Call close function directly
                        bluetoothCloseTimer.start()
                    } else {
                        // Panel is closed, open it
                        ServiceStateManager.toggleBluetoothPanel(wrapper.screen)
                    }
                }
            }

            CustomCircularProgress{
                property string icon:{
                    var value = ServiceBrightness.getBrightness(screen)
                    if( value > 0.6) return "brightness-full"
                    if( value > 0.1) return "brightness-medium"
                    return "brightness-low"
                }
                isInteractive: true
                iconSource: IconUtils.getSystemIcon(icon)
                progress: ServiceBrightness.getBrightness(screen)
                onWheelChanged: function(delta) {ServiceBrightness.updateBrightness(screen, delta * 5)}
            }

            CustomCircularProgress{
                isInteractive: true
                property string icon:{
                    if(ServicePipewire.isMuted) return "speaker-muted"
                    if(ServicePipewire.volume > 0.5) return "speaker"
                    if(ServicePipewire.volume > 0.2) return "speaker-medium"
                    if(ServicePipewire.volume <= 0.2) return "speaker-low"
                    return "speaker"
                }
                iconSource: IconUtils.getSystemIcon(icon)
                onWheelChanged: function(delta) { ServicePipewire.updateVolume(delta * 0.01) }
                onClicked: ServicePipewire.updateState()
                progress: ServicePipewire.volume
            }
            //VolumeIcon{}
            
            CustomCircularProgress{
                isInteractive: false
                property string icon:{
                    if(ServiceUPower.isCharging) return "battery-charging"
                    if(ServiceUPower.powerLevel < 0.6) return "battery-medium"
                    if(ServiceUPower.powerLevel < 0.3) return "battery-low"
                    return "battery"
                }
                iconSource: IconUtils.getSystemIcon(icon)
                progress: ServiceUPower.powerLevel
            }
        }
    }

    Timer {
        id: bluetoothCloseTimer
        interval: 250  // Slightly longer than animation (200ms)
        onTriggered: {
            ServiceStateManager.getVisibilities(wrapper.screen).bluetoothPanel = false
        }
    }

    Loader{
        id: bluetoothLoader
        active: wrapper.bluetoothOpen
        sourceComponent: Component{
            Bluetooth{
                shouldShow: wrapper.bluetoothOpen
            }
        }
    }
}
