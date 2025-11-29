import Quickshell
import QtQuick
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import Quickshell.Hyprland
import Quickshell.Widgets
import qs.modules.customComponents

Item{
    id: appLauncher
    height: container.height
    width: container.width
    anchors.verticalCenter: parent.verticalCenter
    property alias container: container
    property int selectedIndex
    property var filteredApps:ServiceApps.filteredApps 

    GlobalShortcut{
        name: "appLauncher"

        onPressed:{
            if(Hyprland.focusedMonitor.name === layout.screen.name){
                container.isClicked = !container.isClicked
                if(container.isClicked){
                        searchInput.forceActiveFocus()
                }
            }
        }
    }
    
    Rectangle{
        id: container
        property bool isClicked: false
        implicitWidth: isClicked ? 300 : 8
        implicitHeight: 600
        color: Settings.layoutColor
        topRightRadius: 20
        bottomRightRadius: 20
        clip: true
        
        Behavior on implicitWidth{
            NumberAnimation{
                duration: 400
                easing.type: Easing.OutQuad
            }
        }

        Column{
            anchors.fill: parent
            visible: container.implicitWidth > 50

            Item{
                width: parent.width
                height: parent.height * 0.1
                Rectangle{
                    implicitWidth: parent.width - 20
                    implicitHeight: parent.height - 20
                    radius: 10
                    color: Colors.inversePrimary
                    anchors.centerIn: parent
                    
                    Row{
                        anchors.fill: parent
                        Item{
                            height: parent.height
                            width: parent.height
                            IconImage{
                                anchors.centerIn: parent
                                source: IconUtil.getSystemIcon("search")
                                implicitSize: 20
                            }
                        }

                        TextInput{
                            id: searchInput
                            focus: true
                            clip: true
                            width: parent.width - parent.height
                            text: ""
                            height: parent.height - 12
                            font.pixelSize: 18
                            font.weight: 800
                            anchors.verticalCenter: parent.verticalCenter
                            color: Colors.primaryText
                            
                            Connections{
                                target: container
                                function onIsClickedChanged(){
                                    if(!container.isClicked){
                                        searchInput.text = ""
                                    }
                                }
                            }
                            
                            onTextChanged: {
                                ServiceApps.updateSearch(text) 
                            }

                            onAccepted:{
                                if(filteredApps[appLauncher.selectedIndex]){
                                    filteredApps[appLauncher.selectedIndex].execute()
                                    container.isClicked = false
                                }
                            }

                            Keys.onEscapePressed:{
                                container.isClicked = false
                            }
                        }
                    }
                }
            }
            
            Item{
                width: parent.width
                height: parent.height * 0.9
                ClippingWrapperRectangle{
                    implicitWidth: parent.width - 20
                    implicitHeight: parent.height - 20
                    anchors.centerIn: parent
                    radius: 10
                    color: "transparent"

                    ListView{
                        id: appList
                        width: parent.width
                        height: parent.height
                        model: appLauncher.filteredApps
                        orientation: Qt.Vertical
                        spacing: 10
                        clip: true

                        delegate: Rectangle{
                            implicitHeight: 80
                            implicitWidth: 280
                            color: appLauncher.selectedIndex === index? Colors.primary : Settings.layoutColor
                            radius: 10

                            border{
                                width: appLauncher.selectedIndex === index ? 1 : 0
                                color: Colors.outline
                            }

                            Behavior on color{
                                ColorAnimation{
                                    duration: 100
                                }
                            }

                            Row{
                                anchors.fill: parent

                                Item{
                                    width: parent.width * 0.2
                                    height: parent.height

                                    Image{
                                        anchors.centerIn: parent
                                        height: parent.height - 30
                                        width: parent.height - 30
                                        source: IconUtil.getIconPath(modelData.icon)
                                    }
                                }

                                Item{
                                    width: parent.width * 0.8
                                    height: parent.height

                                    CustomText{
                                        anchors.left: parent.left
                                        anchors.leftMargin: 10
                                        anchors.verticalCenter: parent.verticalCenter
                                        content: modelData.name
                                        size: 16
                                        color: appLauncher.selectedIndex === index ? Colors.primaryText : Colors.surfaceText
                                    } 
                                }
                            }
                            
                            MouseArea{
                                id: appArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onEntered:{
                                    appLauncher.selectedIndex = index
                                }
                                onClicked: {
                                    if(modelData){
                                        modelData.execute()
                                        container.isClicked = false
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
