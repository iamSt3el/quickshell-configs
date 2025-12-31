import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.settings
import qs.modules.services
import qs.modules.customComponents

Rectangle{
    id: container
    anchors.fill: parent
    property bool isClicked : false
    property string searchText: ""
    color: Settings.layoutColor
    //color: "transparent"
    topRightRadius: 20
    topLeftRadius: 20
    signal toClose



    Component.onCompleted: {
        if(container.isClicked){
            searchInput.forceActiveFocus()
        }
    }

    ColumnLayout{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            color: Colors.surfaceContainer
            radius: 20

            RowLayout{
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                CustomIconImage{
                    icon: "search"
                    size: 20
                }

                TextInput{
                    id: searchInput
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                    verticalAlignment: TextInput.AlignVCenter
                    focus: true
                    clip: true
                    text: ""
                    font.pixelSize: 16
                    color: Colors.inverseSurface
                    onTextChanged: container.searchText = text



                    onAccepted: {
                        const item = clipboardList.itemAtIndex(clipboardList.activeIndex)
                        if (item) {
                            container.toClose()
                            ServiceCliphist.copy(item.modelData)
                        }
                    }

                    Keys.onPressed: (event) => {
                        if (event.key === Qt.Key_Down) {
                            if (clipboardList.activeIndex < clipboardList.count - 1) {
                                clipboardList.activeIndex++
                                clipboardList.positionViewAtIndex(clipboardList.activeIndex, ListView.Contain)
                            }
                            event.accepted = true
                        }
                        else if (event.key === Qt.Key_Up) {
                            if (clipboardList.activeIndex > 0) {
                                clipboardList.activeIndex--
                                clipboardList.positionViewAtIndex(clipboardList.activeIndex, ListView.Contain)
                            }
                            event.accepted = true
                        }
                        else if (event.key === Qt.Key_Delete) {
                            const item = clipboardList.itemAtIndex(clipboardList.activeIndex)
                            if (item) {
                                ServiceCliphist.deleteEntry(item.modelData)
                            }
                            event.accepted = true
                        }
                        else if(event.key === Qt.Key_Escape){
                            container.toClose()
                        }
                    }

                }

            }
        }

        ClippingWrapperRectangle{
            id: clippingWrapper
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 10
            color: "transparent"
            clip: true

            ListView{
                id: clipboardList
                property int activeIndex : 0
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5
                clip: true

                model: {
                    const isHtmlImageEntry = (entry) => {
                        const text = ServiceCliphist.getEntryText(entry)
                        return text.startsWith("<meta") && text.includes("<img")
                    }

                    let filteredEntries = ServiceCliphist.entries.filter(entry => !isHtmlImageEntry(entry))

                    if (container.searchText !== "") {
                        const searchLower = container.searchText.toLowerCase()
                        filteredEntries = filteredEntries.filter(entry => {
                            const text = ServiceCliphist.getEntryText(entry).toLowerCase()
                            return text.includes(searchLower)
                        })
                    }

                    return filteredEntries
                }

                delegate: Rectangle{
                    id: clipItem
                    required property var modelData
                    required property int index
                    property bool active: clipboardList.activeIndex === index

                    width: clipboardList.width
                    height: ServiceCliphist.entryIsImage(modelData) ? 120 : 60
                    color:  active ? Colors.primary : "transparent"
                    radius: 10

                    RowLayout{
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Item{
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            CustomText{
                                visible: !ServiceCliphist.entryIsImage(clipItem.modelData)
                                width: parent.width
                                content: ServiceCliphist.getEntryText(clipItem.modelData)
                                color: clipItem.active ? Colors.primaryText : Colors.surfaceVariantText
                                elide: Text.ElideRight
                                wrapMode: Text.Wrap
                                maximumLineCount: 2
                                verticalAlignment: Text.AlignVCenter
                            }

                            // Image content
                            Loader{
                                visible: ServiceCliphist.entryIsImage(clipItem.modelData)
                                anchors.fill: parent
                                active: ServiceCliphist.entryIsImage(clipItem.modelData)

                                sourceComponent: ClipboardImage{
                                    entry: clipItem.modelData
                                }
                            }
                        }

                        // Delete button
                        Rectangle{
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            color: deleteMouseArea.containsMouse ? Qt.alpha(Colors.error, 0.5) : "transparent"
                            radius: height

                            CustomIconImage{
                                anchors.centerIn: parent
                                icon: "close"
                                size: 20
                                color: clipItem.active ? Colors.primaryText : Colors.surfaceVariantText

                            }

                            MouseArea{
                                id: deleteMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onClicked: {
                                    ServiceCliphist.deleteEntry(clipItem.modelData)
                                }
                            }
                        }
                    }

                    MouseArea{
                        id: clipItemMouseArea
                        anchors.fill: parent
                        anchors.rightMargin: 50
                        hoverEnabled: true      
                        cursorShape: Qt.PointingHandCursor
                        onEntered:{ 
                            clipboardList.activeIndex = clipItem.index

                        }
                        onClicked: {
                            container.toClose()
                            ServiceCliphist.copy(clipItem.modelData)
                        }
                    }
                }
            }
        }

        
    }



    
}
