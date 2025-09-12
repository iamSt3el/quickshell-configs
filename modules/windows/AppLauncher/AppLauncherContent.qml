import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.modules.util
import qs.modules.components

Column {
    id: contentRoot
    
    required property string searchText
    required property var filteredApps
    required property int selectedIndex
    
    
    signal searchChanged(string text)
    signal appSelected(var app)
    signal indexChanged(int newIndex)
    signal closeRequested()
    
    anchors.fill: parent
    visible: parent.width >= 300
    
    // Search Bar
    Item {
        width: parent.width
        height: 60

        Rectangle {
            anchors.centerIn: parent
            implicitHeight: parent.height - 20
            implicitWidth: parent.width - 10
            color: Colors.surfaceContainerHigh
            radius: 10
            
            RowLayout { 
                anchors.fill: parent
                
                Rectangle {
                    color: Colors.primaryContainer
                    topRightRadius: 20
                    topLeftRadius: 20
                    bottomRightRadius: 20
                    Layout.minimumWidth: 40
                    Layout.minimumHeight: parent.height
                    
                    Image {
                        anchors.centerIn: parent
                        width: 26
                        height: 26
                        sourceSize: Qt.size(width, height)
                        source: IconUtils.getSystemIcon("search")
                    }
                }
                
                TextInput {
                    id: searchInput
                    focus: true
                    clip: true
                    Layout.fillWidth: true
                    text: contentRoot.searchText
                    color: Colors.surfaceText
                    font.pixelSize: 18
                    font.weight: 800
                    
                    onTextChanged: {
                        contentRoot.searchChanged(text)
                    }

                    onAccepted: {
                        if (contentRoot.filteredApps[contentRoot.selectedIndex]) {
                            contentRoot.appSelected(contentRoot.filteredApps[contentRoot.selectedIndex])
                        }
                    }
                    
                    Keys.onEscapePressed: {
                        contentRoot.closeRequested()
                    }
                    
                    Keys.onUpPressed: {
                        let newIndex = Math.max(0, contentRoot.selectedIndex - 1)
                        contentRoot.indexChanged(newIndex)
                    }
                    
                    Keys.onDownPressed: {
                        let newIndex = Math.min(contentRoot.filteredApps.length - 1, contentRoot.selectedIndex + 1)
                        contentRoot.indexChanged(newIndex)
                    }
                }
            }
        }
    }

    // App List
    ClippingWrapperRectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: parent.width - 10
        implicitHeight: parent.height - 70
        radius: 10
        color: "transparent"
        
        ListView {
            id: appList
            anchors.fill: parent
            model: contentRoot.filteredApps
            orientation: Qt.Vertical
            spacing: 10
            clip: true
            
            // Enable better performance
            cacheBuffer: 200
            displayMarginBeginning: 100
            displayMarginEnd: 100

            delegate: AppListDelegate {
                isSelected: contentRoot.selectedIndex === index
                
                onClicked: {
                    contentRoot.appSelected(modelData)
                }
                
                onHovered: function(idx) {
                    contentRoot.indexChanged(idx)
                }
            }
        }
    }
    
    function focusSearchInput() {
        searchInput.forceActiveFocus()
    }
    
    function clearSearch() {
        searchInput.text = ""
    }
}
