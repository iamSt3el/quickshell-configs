import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Widgets
import QtQuick.Layouts
import qs.modules.util
import qs.modules.components
import qs.modules.services
import Quickshell.Wayland
import QtQuick.Effects

PanelWindow{
    id: appLauncherPanel
    implicitWidth: 350
    implicitHeight: 600

    focusable: true

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Normal
    anchors{
        left: true
    }
    color: "transparent"

    Connections {
        target: ServiceIpcHandler
        function onRequestAppLauncherClose() {
            close()
        }
    }

    Component.onCompleted: {
        open()
    }

    Item{
        id: item
        height: parent.height
        width: 0 
        anchors.left: parent.left
        anchors.top: parent.top

        layer.enabled: item.width > 100 ? true : false
        layer.effect: MultiEffect{
            shadowEnabled: true
            shadowBlur: 0.4
            shadowOpacity: 1.0
            shadowColor: Qt.alpha(Colors.shadow, 1)
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
        }

        Shape{
            id: shapeElement
            preferredRendererType: Shape.CurveRenderer         
            
            transform: Scale{
                    id: shapeScale
                    origin.x: 0
                    origin.y: 0
                    xScale: 0
            }

            ShapePath{
                fillColor: Colors.surfaceContainer
                strokeWidth: 0
                startX: 0
                startY: 0

       

                PathArc{
                    relativeX: Dimensions.position.x
                    relativeY: Dimensions.position.x
                    radiusX: Dimensions.radius.large
                    radiusY: Dimensions.radius.large
                    direction: PathArc.Counterclockwise
                }
                PathLine{
                    relativeY: wrapper.height
                    relativeX: 0
                }
                PathArc{
                    relativeX: -Dimensions.position.x
                    relativeY: Dimensions.position.x
                    radiusX: Dimensions.radius.large
                    radiusY: Dimensions.radius.large
                    direction: PathArc.Counterclockwise
                }
            }
        }


        Rectangle{
            id: wrapper
            width: item.width 
            implicitHeight: parent.height - 40
            color: Colors.surfaceContainer
            topRightRadius: 20
            bottomRightRadius: 20
            anchors{
                verticalCenter: parent.verticalCenter
            }


            
            AppLauncherContent {
                id: launcherContent
                anchors.fill: parent
                searchText: ServiceDesktopEntries.currentSearchText
                filteredApps: ServiceDesktopEntries.filteredApps
                selectedIndex: ServiceDesktopEntries.selectedIndex
                
                onSearchChanged: function(text) {
                    ServiceDesktopEntries.updateSearch(text)
                }
                
                onAppSelected: function(app) {
                    ServiceDesktopEntries.executeApp(app)
                    close()
                    launcherContent.clearSearch()
                }
                
                onIndexChanged: function(newIndex) {
                    ServiceDesktopEntries.setSelectedIndex(newIndex)
                }
                
                onCloseRequested: {
                    close()
                }
            }
        }
    }


    SequentialAnimation {
        id: openAnimation
        
        ParallelAnimation {
            NumberAnimation {
                target: wrapper
                property: "width"
                from: 0
                to: 30
                duration: 400
                easing.type: Easing.OutQuad
            }
            
            NumberAnimation {
                target: shapeScale
                property: "xScale"
                from: 0
                to: 1.0
                duration: 400
                easing.type: Easing.OutQuad
            }
        }
        
        NumberAnimation {
            target: wrapper
            property: "width"
            from: 30
            to: 350
            duration: 200
            easing.type: Easing.OutQuad
        }
        
        onFinished: {
            launcherContent.focusSearchInput()
        }
    }
    
    SequentialAnimation {
        id: closeAnimation
        
        NumberAnimation {
            target: wrapper
            property: "width"  
            from: 350
            to: 30
            duration: 200
            easing.type: Easing.InQuad
        }
        
        ParallelAnimation {
            NumberAnimation {
                target: shapeScale
                property: "xScale"
                from: 1.0
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
            
            // Width 30 → 0
            NumberAnimation {
                target: wrapper
                property: "width"
                from: 30
                to: 0
                duration: 400
                easing.type: Easing.InQuad
            }
        }
        
        onFinished: {
            // Animation finished - set state to false
            ServiceIpcHandler.isAppLauncherVisible = false
        }
    }
    
    function open(){
        openAnimation.start()
    }
    

    function close(){
        closeAnimation.start()
    }
}


