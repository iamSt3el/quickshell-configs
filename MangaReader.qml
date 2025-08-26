import Quickshell
import QtQuick
import QtQuick.Controls
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes


Scope{
    id: root

    property var activePanels: ({})

    IpcHandler {
        target: "manga"

        function togglePanel(): void {
            var focusedMonitor = Hyprland.focusedMonitor;
            
            if (focusedMonitor) {
                // Find the panel that corresponds to the focused monitor
                for (var i = 0; i < Quickshell.screens.length; i++) {
                    var screen = Quickshell.screens[i];
                    var hyprMonitor = Hyprland.monitorFor(screen);
                    
                    if (hyprMonitor && hyprMonitor.name === focusedMonitor.name) {
                        var panel = root.activePanels[screen.name];
                        if (panel) {
                            panel.visible = !panel.visible;
                            return;
                        }
                    }
                }
            } 
        }
    }

    Variants{
        model: Quickshell.screens

        PanelWindow{
            id: mangaPanel
            required property var modelData
            screen: modelData

            color: "transparent"

            property bool isMangaPanelVisible: false
            property var chapterImages: []

            visible: false
            
            Component.onCompleted: {
                root.activePanels[modelData.name] = mangaPanel;
            }
            
            property bool hasLoadedChapter: false
            
            onVisibleChanged: {
                if (visible && !hasLoadedChapter) {
                    // Only load chapter once when panel becomes visible
                    hasLoadedChapter = true;
                    mangaDownloader.loadChapter("juvenile-prison", "chapter-54");
                }
            }

            MangaDownloader {
                id: mangaDownloader
                
                onImagesReady: {
                    mangaPanel.chapterImages = chapterImages;
                }
                
                onChapterNotFound: {
                    console.log("Chapter", chapter, "does not exist!");
                }
            }
            
            anchors{
                left: true
            } 



            exclusionMode: ExclusionMode.Normal
            WlrLayershell.layer: WlrLayershell.Overlay

            implicitWidth: 400
            implicitHeight: 1000

            Item{
                id: wrapper
                anchors.fill: parent

                Shape{
                    //preferredRendererType: Shape.CurveRenderer

                    ShapePath{
                        fillColor: "#11111b"
                        strokeWidth: 0
                        //strokeColor: "blue"
                        startX: 0
                        startY: 0


                        PathArc{
                            relativeX: 20
                            relativeY: 20
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }
                        
                        PathLine{
                            relativeX: 0
                            relativeY: wrapper.height - 40
                        }


                        PathArc{
                            relativeX: -20
                            relativeY: 20
                            radiusX: 20
                            radiusY: 15
                            direction: PathArc.Counterclockwise
                        }


                    }
                }


                Rectangle{
                    id: container
                    implicitHeight: parent.height - 40
                    implicitWidth: parent.width
                    //visible: false

                    bottomRightRadius: 20
                    topRightRadius: 20


                    anchors{
                        verticalCenter: parent.verticalCenter
                    }
                    color: "#11111b"

                    Column{

                        anchors.fill:parent

                        Rectangle{
                            implicitWidth: parent.width - 10
                            implicitHeight: 40
                            //color: "#fab387"
                            color: "transparent"
                            radius: 10
                            anchors.horizontalCenter: parent.horizontalCenter


                            Row{
                                spacing: 5
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.rightMargin: 10
                                anchors.right: parent.right
                                Rectangle{
                                    implicitWidth: 60
                                    implicitHeight: 30
                                    radius: 10
                                    color: "#b4befe"

                                    Text{
                                        text: "Prev"
                                        anchors.centerIn: parent
                                        color: "#181825"
                                        font.pixelSize: 16
                                    }

                                    MouseArea{
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked:{
                                            var currentNum = parseInt(mangaDownloader.currentChapter.replace("chapter-", ""));
                                            var prevNum = currentNum - 1;
                                            if (prevNum > 0) {
                                                mangaDownloader.loadChapter("juvenile-prison", "chapter-" + prevNum);
                                            }
                                        }
                                    }
                                }

                                Rectangle{
                                    implicitWidth: 60
                                    implicitHeight: 30
                                    radius: 10
                                    color: "#b4befe" 
                                    
                                    Text{
                                        text: "Next"
                                        anchors.centerIn: parent
                                        color: "#181825"
                                        font.pixelSize: 16
                                    }  
                                    MouseArea{
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked:{
                                            var currentNum = parseInt(mangaDownloader.currentChapter.replace("chapter-", ""));
                                            var nextNum = currentNum + 1;
                                            mangaDownloader.loadChapter("juvenile-prison", "chapter-" + nextNum);
                                        }
                                    }
                                }
                            }

                        }

                        Flickable {
                            id: imageFlickable
                            width: parent.width
                            height: parent.height - 50
                            clip: true
                            
                            contentWidth: width
                            contentHeight: imageColumn.height
                            
                            ScrollBar.vertical: ScrollBar {
                                policy: ScrollBar.AsNeeded
                                interactive: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                onWheel: function(wheel) {
                                    var scrollAmount = wheel.angleDelta.y * 2;
                                    imageFlickable.contentY = Math.max(0, Math.min(imageFlickable.contentY - scrollAmount, imageFlickable.contentHeight - imageFlickable.height));
                                }
                            }

                            Column {
                                id: imageColumn
                                width: parent.width
                                spacing: 0

                                Repeater {
                                    model: mangaPanel.chapterImages
                                    
                                    delegate: Rectangle {
                                        width: imageColumn.width
                                        height: Math.max(mangaImage.implicitHeight + 10, 100)
                                        color: "transparent"

                                        Image {
                                            id: mangaImage
                                            source: modelData
                                            anchors.horizontalCenter: parent.horizontalCenter
                                            width: parent.width - 20
                                            fillMode: Image.PreserveAspectFit
                                            asynchronous: true
                                            cache: true
                                            
                                            onStatusChanged: {
                                                if (status === Image.Error) {
                                                    console.log("Failed to load image at index", index, ":", source);
                                                }
                                            }
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                color: "#2a2a2a"
                                                visible: mangaImage.status === Image.Loading
                                                
                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "Loading page " + (index + 1)
                                                    color: "#666"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
              
            }

        }
    }
   
    
}

