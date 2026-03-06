import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Controls
import qs.modules.utils
import qs.modules.services
import qs.modules.settings
import qs.modules.customComponents

Rectangle{
    anchors.fill: parent
    topLeftRadius: Appearance.radius.large
    topRightRadius: Appearance.radius.extraLarge
    color: Colors.surface
    anchors.bottom:  parent.bottom


    Behavior on implicitHeight{
        NumberAnimation{
            duration: Appearance.duration.normal
            easing.type: Easing.OutQuad
        }
    }
    //
    // Connections{
    //     target: loader
    //     function onAnimationChanged(){
    //         if(loader.animation){
    //             timer.start();
    //         }else{
    //             colLoader.active = false
    //         }
    //     }
    // }
    //
    Timer{
        id: timer
        interval: 300
        running: true
        onTriggered:{
            colLoader.active = true
        }
    }
    Loader{
        id: colLoader
        active: false
        visible: active
        anchors.fill: parent
        sourceComponent: ColumnLayout {
            id: col
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            Component.onCompleted: searchInput.forceActiveFocus()

            NumberAnimation on opacity {
                from: 0; to: 1; duration: 100; running: col.visible
            }
            NumberAnimation on scale {
                from: 0.8; to: 1; duration: 100; running: col.visible
            }

            // ── Top bar (local + online share one rectangle) ─────────────────
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                clip: true
                radius: Appearance.radius.extraLarge
                color: Colors.surfaceContainer

                // ── Local content ─────────────────────────────────────────────
                RowLayout {
                    id: localContent
                    anchors.fill: parent
                    anchors.rightMargin: 10
                    anchors.leftMargin: 10
                    spacing: 10
                    enabled: !ServiceWallpaper.onlineMode
                    opacity: ServiceWallpaper.onlineMode ? 0 : 1
                    scale: ServiceWallpaper.onlineMode ? 0.92 : 1
                    Behavior on opacity { NumberAnimation { duration: Appearance.duration.normal } }
                    Behavior on scale   { NumberAnimation { duration: Appearance.duration.normal; easing.type: Easing.OutQuad } }

                    Rectangle {
                        Layout.preferredHeight: 35
                        Layout.preferredWidth: 400
                        radius: 20
                        color: Colors.surfaceContainerHighest
                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 5
                            anchors.leftMargin: 10
                            spacing: 10
                            MaterialIconSymbol { content: "search"; iconSize: 18 }
                            TextInput {
                                id: searchInput
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                font.pixelSize: 16
                                font.weight: 800
                                color: Colors.inverseSurface
                                onTextChanged: ServiceWallpaper.updateSearch(text)
                                Keys.onEscapePressed: text = ""
                            }
                        }
                    }
                    Item { Layout.fillWidth: true }
                    Rectangle {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: 40
                        radius: 20
                        color: Colors.surfaceContainerHighest
                        MaterialIconSymbol { anchors.centerIn: parent; content: "refresh"; iconSize: 20 }
                        CustomMouseArea { cursorShape: Qt.PointingHandCursor; anchors.fill: parent; onClicked: ServiceWallpaper.refresh() }
                    }
                    Rectangle {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: _onlineRow.implicitWidth + 30
                        radius: 20
                        color: Colors.surfaceContainerHighest
                        RowLayout {
                            id: _onlineRow
                            anchors.fill: parent
                            anchors.leftMargin: 10; anchors.rightMargin: 10
                            spacing: 6
                            MaterialIconSymbol { content: "public"; iconSize: 18 }
                            CustomText { content: "Online"; size: 12 }
                        }
                        CustomMouseArea {
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: { ServiceWallpaper.onlineMode = true; ServiceWallpaper.fetchWallhaven(true) }
                        }
                    }
                    Rectangle {
                        Layout.preferredHeight: 30
                        Layout.preferredWidth: _countRow.implicitWidth + 30
                        radius: 20
                        color: Colors.surfaceContainerHighest
                        RowLayout {
                            id: _countRow
                            anchors.fill: parent
                            anchors.leftMargin: 10; anchors.rightMargin: 10
                            spacing: 10
                            MaterialIconSymbol { content: "wallpaper"; iconSize: 18 }
                            CustomText { content: ServiceWallpaper.cacheModel.count + " wallpapers"; size: 12 }
                        }
                    }
                }

                // ── Online content ────────────────────────────────────────────
                RowLayout {
                    id: onlineConfigCol
                    anchors.fill: parent
                    anchors.leftMargin: 10; anchors.rightMargin: 10
                    spacing: 6
                    enabled: ServiceWallpaper.onlineMode
                    opacity: ServiceWallpaper.onlineMode ? 1 : 0
                    scale: ServiceWallpaper.onlineMode ? 1 : 0.92
                    Behavior on opacity { NumberAnimation { duration: Appearance.duration.normal } }
                    Behavior on scale   { NumberAnimation { duration: Appearance.duration.normal; easing.type: Easing.OutQuad } }

                    property var sortOpts: [
                        ["Recent",   "date_added"], ["Hot",      "toplist"],
                        ["Views",    "views"],      ["Fav",      "favorites"],
                        ["Random",   "random"],     ["Relevant", "relevance"]
                    ]
                    property var rangeOpts: ["1d", "3d", "1w", "1M", "3M", "6M", "1y"]

                    function toggleCat(pos) {
                        let c = SettingsConfig.wallhavenCategories.split("")
                        c[pos] = c[pos] === "1" ? "0" : "1"
                        if (!c.includes("1")) return
                        SettingsConfig.wallhavenCategories = c.join("")
                    }
                    function togglePur(pos) {
                        let p = SettingsConfig.wallhavenPurity.split("")
                        p[pos] = p[pos] === "1" ? "0" : "1"
                        if (!p.includes("1")) return
                        SettingsConfig.wallhavenPurity = p.join("")
                    }

                    // Back button
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _backRow.implicitWidth + 20
                        RowLayout {
                            id: _backRow
                            anchors.centerIn: parent
                            spacing: 4
                            MaterialIconSymbol { content: "arrow_back"; iconSize: 14; customColor: Colors.surfaceText }
                            CustomText { content: "Local"; size: 11; customColor: Colors.surfaceText }
                        }
                        CustomMouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: ServiceWallpaper.onlineMode = false
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Sorting group
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _sortRow.implicitWidth + 6
                        RowLayout {
                            id: _sortRow
                            anchors.centerIn: parent
                            spacing: 2
                            Repeater {
                                model: onlineConfigCol.sortOpts.length
                                delegate: Rectangle {
                                    required property int index
                                    readonly property string val: onlineConfigCol.sortOpts[index][1]
                                    readonly property string lbl: onlineConfigCol.sortOpts[index][0]
                                    property bool active: SettingsConfig.wallhavenSorting === val
                                    height: 24; radius: 12
                                    implicitWidth: _sLbl.implicitWidth + 14
                                    color: active ? Colors.primary : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    CustomText {
                                        id: _sLbl
                                        anchors.centerIn: parent
                                        content: parent.lbl; size: 11
                                        customColor: parent.active ? Colors.primaryText : Colors.surfaceText
                                    }
                                    CustomMouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: SettingsConfig.wallhavenSorting = parent.val
                                    }
                                }
                            }
                        }
                    }

                    // TopRange group (only when sorting=toplist)
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _rangeRow.implicitWidth + 6
                        visible: SettingsConfig.wallhavenSorting === "toplist"
                        RowLayout {
                            id: _rangeRow
                            anchors.centerIn: parent
                            spacing: 2
                            Repeater {
                                model: onlineConfigCol.rangeOpts.length
                                delegate: Rectangle {
                                    required property int index
                                    readonly property string val: onlineConfigCol.rangeOpts[index]
                                    property bool active: SettingsConfig.wallhavenTopRange === val
                                    height: 24; radius: 12
                                    implicitWidth: _rLbl.implicitWidth + 14
                                    color: active ? Colors.primary : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    CustomText {
                                        id: _rLbl
                                        anchors.centerIn: parent
                                        content: parent.val; size: 11
                                        customColor: parent.active ? Colors.primaryText : Colors.surfaceText
                                    }
                                    CustomMouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: SettingsConfig.wallhavenTopRange = parent.val
                                    }
                                }
                            }
                        }
                    }

                    // Order group (↓ ↑)
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _orderRow.implicitWidth + 6
                        RowLayout {
                            id: _orderRow
                            anchors.centerIn: parent
                            spacing: 2
                            Repeater {
                                model: [["arrow_downward", "desc"], ["arrow_upward", "asc"]]
                                delegate: Rectangle {
                                    required property var modelData
                                    property bool active: SettingsConfig.wallhavenOrder === modelData[1]
                                    height: 24; width: 28; radius: 12
                                    color: active ? Colors.primary : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                    MaterialIconSymbol {
                                        anchors.centerIn: parent
                                        content: parent.modelData[0]; iconSize: 14
                                        customColor: parent.active ? Colors.primaryText : Colors.surfaceText
                                    }
                                    CustomMouseArea {
                                        anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                        onClicked: SettingsConfig.wallhavenOrder = parent.modelData[1]
                                    }
                                }
                            }
                        }
                    }

                    // Categories group
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _catRow.implicitWidth + 6
                        RowLayout {
                            id: _catRow
                            anchors.centerIn: parent
                            spacing: 2
                            Rectangle {
                                property bool active: SettingsConfig.wallhavenCategories[0] === "1"
                                height: 24; radius: 12; implicitWidth: _cg.implicitWidth + 14
                                color: active ? Colors.primary : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _cg; anchors.centerIn: parent; content: "General"; size: 11; customColor: parent.active ? Colors.primaryText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.toggleCat(0) }
                            }
                            Rectangle {
                                property bool active: SettingsConfig.wallhavenCategories[1] === "1"
                                height: 24; radius: 12; implicitWidth: _ca.implicitWidth + 14
                                color: active ? Colors.primary : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _ca; anchors.centerIn: parent; content: "Anime"; size: 11; customColor: parent.active ? Colors.primaryText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.toggleCat(1) }
                            }
                            Rectangle {
                                property bool active: SettingsConfig.wallhavenCategories[2] === "1"
                                height: 24; radius: 12; implicitWidth: _cp.implicitWidth + 14
                                color: active ? Colors.primary : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _cp; anchors.centerIn: parent; content: "People"; size: 11; customColor: parent.active ? Colors.primaryText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.toggleCat(2) }
                            }
                        }
                    }

                    // Purity group
                    Rectangle {
                        height: 28; radius: 14
                        color: Colors.surfaceContainerHighest
                        implicitWidth: _purRow.implicitWidth + 6
                        RowLayout {
                            id: _purRow
                            anchors.centerIn: parent
                            spacing: 2
                            Rectangle {
                                property bool active: SettingsConfig.wallhavenPurity[0] === "1"
                                height: 24; radius: 12; implicitWidth: _ps.implicitWidth + 14
                                color: active ? Colors.primary : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _ps; anchors.centerIn: parent; content: "SFW"; size: 11; customColor: parent.active ? Colors.primaryText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.togglePur(0) }
                            }
                            Rectangle {
                                property bool active: SettingsConfig.wallhavenPurity[1] === "1"
                                height: 24; radius: 12; implicitWidth: _pk.implicitWidth + 14
                                color: active ? Colors.primary : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _pk; anchors.centerIn: parent; content: "Sketchy"; size: 11; customColor: parent.active ? Colors.primaryText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.togglePur(1) }
                            }
                            Rectangle {
                                visible: SettingsConfig.wallhavenApiKey.length > 0
                                property bool active: SettingsConfig.wallhavenPurity[2] === "1"
                                height: 24; radius: 12; implicitWidth: _pn.implicitWidth + 14
                                color: active ? Colors.error : "transparent"
                                Behavior on color { ColorAnimation { duration: 150 } }
                                CustomText { id: _pn; anchors.centerIn: parent; content: "NSFW"; size: 11; customColor: parent.active ? Colors.errorText : Colors.surfaceText }
                                CustomMouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: onlineConfigCol.togglePur(2) }
                            }
                        }
                    }

                    // Fetch button
                    Rectangle {
                        width: 28; height: 28; radius: 14
                        color: ServiceWallpaper.isFetchingOnline ? Colors.surfaceContainerHighest : Colors.primary
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MaterialIconSymbol {
                            anchors.centerIn: parent
                            content: ServiceWallpaper.isFetchingOnline ? "hourglass_empty" : "search"
                            iconSize: 16
                            customColor: ServiceWallpaper.isFetchingOnline ? Colors.surfaceText : Colors.primaryText
                        }
                        CustomMouseArea {
                            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                            onClicked: if (!ServiceWallpaper.isFetchingOnline) ServiceWallpaper.fetchWallhaven(true)
                        }
                    }
                }
            }
            // ── End top bar ───────────────────────────────────────────────────

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true

                // Centered fetch / error overlay
                Rectangle {
                    anchors.centerIn: parent
                    visible: ServiceWallpaper.onlineMode &&
                             (ServiceWallpaper.isFetchingOnline || ServiceWallpaper.onlineError.length > 0)
                    z: 1
                    implicitWidth: _overlayRow.implicitWidth + 32
                    implicitHeight: _overlayRow.implicitHeight + 20
                    radius: 14
                    color: Colors.surfaceContainer

                    RowLayout {
                        id: _overlayRow
                        anchors.centerIn: parent
                        spacing: 8
                        MaterialIconSymbol {
                            content: ServiceWallpaper.onlineError.length > 0 ? "error" : "downloading"
                            iconSize: 20
                            customColor: ServiceWallpaper.onlineError.length > 0 ? Colors.error : Colors.surfaceText
                        }
                        CustomText {
                            content: ServiceWallpaper.onlineError.length > 0
                                ? ServiceWallpaper.onlineError
                                : "Fetching wallpapers…"
                            size: 13
                            customColor: ServiceWallpaper.onlineError.length > 0 ? Colors.error : Colors.surfaceText
                        }
                    }
                }

            GridView{
                id: grid
                anchors.fill: parent
                cellWidth: width / 4
                cellHeight: height / (4 / 2)
                model: ScriptModel {
                    values: ServiceWallpaper.onlineMode
                        ? ServiceWallpaper.onlineWallpapers
                        : ServiceWallpaper.filteredWallpapers
                }
                clip: true

                interactive: true
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: CustomScrollBar{}

                onAtYEndChanged: {
                    if (atYEnd && ServiceWallpaper.onlineMode)
                        ServiceWallpaper.fetchNextPage()
                }

                delegate: Rectangle{
                    id: wallpaperItemImageContainer
                    required property var modelData
                    width: grid.cellWidth
                    height: grid.cellHeight
                    radius: 10
                    color: area.containsMouse ? Colors.primary : "transparent"

                    Image{
                        id: thumbnail
                        anchors.fill: parent
                        anchors.margins: 5
                        sourceSize: Qt.size(width, height)
                        asynchronous: true
                        anchors.centerIn: parent
                        smooth: true
                        cache: true
                        source: ServiceWallpaper.onlineMode
                            ? wallpaperItemImageContainer.modelData.thumbUrl
                            : "file://" + wallpaperItemImageContainer.modelData
                        fillMode: Image.PreserveAspectCrop
                        Behavior on anchors.margins{
                            NumberAnimation{
                                duration: 200
                                easing.type: Easing.OutQuad
                            }
                        }

                        layer.enabled: true
                        layer.effect: OpacityMask {
                            maskSource: Rectangle {
                                width: thumbnail.width
                                height: thumbnail.height
                                radius: 10
                            }
                        }
                    }

                    // loading spinner for online thumbnails still fetching
                    Rectangle {
                        anchors.centerIn: parent
                        width: 28; height: 28
                        radius: 14
                        color: Colors.surfaceContainer
                        visible: ServiceWallpaper.onlineMode && thumbnail.status === Image.Loading

                        MaterialIconSymbol {
                            anchors.centerIn: parent
                            content: "hourglass_empty"
                            iconSize: 16
                        }
                    }

                    MouseArea{
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (ServiceWallpaper.onlineMode)
                                ServiceWallpaper.downloadAndSetWallpaper(wallpaperItemImageContainer.modelData)
                            else
                                ServiceWallpaper.setWallpaper(wallpaperItemImageContainer.modelData)
                        }
                    }
                }

            } // GridView

            } // Item
        }
    }
}
