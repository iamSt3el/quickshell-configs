import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes

Scope {
    id: root
    Variants {
        model: Quickshell.screens
        PanelWindow {
            required property var modelData
            screen: modelData
            id: dock
            property var openWindows: []
            property bool isVisible: true
                property bool isIconHovered: false
                    property string winAddress: ""
                        property int hoveredIconIndex: -1  // Track which icon is hovered
                            color: "transparent"

                            WlrLayershell.layer: WlrLayer.Overlay
                            exclusionMode: ExclusionMode.Normal
                            implicitHeight: isVisible ? 60 : 20
                            implicitWidth: Math.max(60, openWindows.length * 60 + 35)

                            Component.onCompleted: {
                                hyprctlProcess.running = true
                            }

                            anchors {
                                bottom: true
                            }

                            // Move the parseWindowDetails function inside PanelWindow
                            function parseWindowDetails(data)
                            {
                                let parts = data.split(",")
                                console.log("Raw event data:", data)
                                console.log("Split parts:", parts)

                                return {
                                    address: parts[0] || "",
                                    workspace: parts[1] || "",
                                    windowClass: parts[2] || "",
                                    windowTitle: parts[3] || ""
                                }
                            }

                            // Timer to hide the dock after mouse leaves
                            Timer {
                                id: hideTimer
                                interval: 800
                                onTriggered: {
                                    dock.isVisible = false
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    dock.isVisible = true
                                }
                            }

                            Process {
                                id: hyprctlProcess
                                command: ["hyprctl", "clients", "-j"]
                                running: false

                                stdout: StdioCollector {
                                    onStreamFinished: {
                                        try {
                                            var windowData = JSON.parse(this.text)
                                            var filteredWindows = []

                                            for (var i = 0; i < windowData.length; i++) {
                                                var window = windowData[i]
                                                if (window.title === "" || window.workspace.id < 0)
                                                {
                                                    continue
                                                }

                                                let add = window.address.replace(/^0x/, "")

                                                filteredWindows.push({
                                                address: add,
                                                windowClass: window.class,
                                                windowTitle: window.title,
                                                workspace: window.workspace.id,
                                            })
                                        }

                                        dock.openWindows = filteredWindows
                                    } catch (e) {
                                    console.warn("Error parsing hyprctl output:", e)
                                }
                            }
                        }
                    }

                    Connections {
                        target: Hyprland

                        function onRawEvent(event)
                        {
                            if (event.name === "openwindow")
                            {
                                console.log("Raw openwindow event data:", event.data)
                                const newWin = dock.parseWindowDetails(event.data)

                                console.log("Parsed window - Address:", newWin.address, "Title:", newWin.windowTitle)

                                const updated = dock.openWindows.slice() // shallow clone
                                updated.push(newWin)

                                dock.openWindows = updated

                                console.log("Opened Window:", updated[updated.length - 1].address)
                            }

                            if (event.name === "closewindow")
                            {
                                const closedAddress = event.data.split(", ")[0]

                                console.log("Closed window address:", closedAddress)

                                // Filter out the closed window
                                const updated = dock.openWindows.filter(
                                    win => win.address !== closedAddress
                                )

                                // Assign to trigger QML update
                                dock.openWindows = updated
                            }
                        }
                    }

                    function setHovering(iconIndex, address)
                    {
                        isIconHovered = !isIconHovered
                        hoveredIconIndex = iconIndex
                        winAddress = "0x"+address
                        //console.log("0x"+address)

                    }
                 PopupWin {
                    id: popupWin
                    isHovered: isIconHovered
                    dockRect: dockRect  // Pass the main dock rectangle reference
                    iconIndex: hoveredIconIndex  // Pass the hovered icon index
                    windowAddress: winAddress
                }

                Rectangle {
                    id: dockRect
                    //implicitWidth: 90
                    implicitWidth: Math.max(60, openWindows.length * 60)

                    implicitHeight: 50
                    color: "#06070e"
                    //radius: 10
                    topLeftRadius: 10
                    topRightRadius: 10
                    visible: dock.isVisible

                    anchors {
                       // leftMargin: 10
                        //rightMargin: 10
                        // bottom: parent.bottom
                        //fill: parent
                        horizontalCenter: parent.horizontalCenter
                    }



                    Row {
                        anchors {
                            centerIn: parent
                        }

                        Repeater {
                            model: dock.openWindows

                            delegate: DockAppIcons {
                                windowData: modelData
                                popupRef: popupWin  // Pass the popup reference

                                onIconHovered: hideTimer.stop()
                                onIconLeft: hideTimer.start()
                                onHovered: setHovering(index, modelData.address)  // Pass the index of the hovered icon
                            }
                        }
                    }
                }
                Shape {
                    visible: dockRect.visible
                    ShapePath {
                        fillColor: "#06070e"
                        strokeWidth: 0
                        //strokeColor: "#06070e"

                        startX: 0
                        startY: dock.height

                        PathArc {
                            relativeX: 18
                            relativeY: -10
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }
                        PathLine{
                            relativeX: dock.width - 36
                            relativeY: 0
                        }
                        PathArc{
                            relativeX: 21
                            relativeY: 10
                            radiusY: 15
                            radiusX: 20
                            direction: PathArc.Counterclockwise
                        }


                        PathLine{
                            relativeX: -(dock.width)
                            relativeY: 0
                        }

                    }
                }
            }
        }
    }
