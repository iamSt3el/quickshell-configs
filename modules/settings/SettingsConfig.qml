pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property alias general: settingsAdapter.general
    property alias theme: settingsAdapter.theme
    property alias wallhaven: settingsAdapter.wallhaven
    property alias ai: settingsAdapter.ai
    property alias manga: settingsAdapter.manga

    Timer {
        id: writeTimer
        interval: 100
        repeat: false
        onTriggered: settingsFile.writeAdapter()
    }

    Timer {
        id: reloadTimer
        interval: 100
        repeat: false
        onTriggered: settingsFile.reload()
    }

    FileView {
        id: settingsFile
        path: Quickshell.env("HOME") + "/.cache/quickshell/settings.json"
        watchChanges: true
        onFileChanged: reloadTimer.restart()
        onAdapterUpdated: writeTimer.restart()
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                writeTimer.restart()
            }
        }

        adapter: JsonAdapter {
            id: settingsAdapter

            property var general: ({
                dock: true,
                dockAutoHide: true,
                dockMusicPlayer: true,
                appGrid: false,
                pinnedApps: [],
                musicVisOn: true
            })

            property var theme: ({
                matugenScheme: "scheme-content",
                matugenTheme: "Light",
                firstColor: "#ffffff",
                secondColor: "#ffffff",
                thirdColor: "#ffffff"
            })

            property var wallhaven: ({
                apiKey: "",
                categories: "111",
                purity: "100",
                sorting: "toplist",
                order: "desc",
                topRange: "1M",
                atleast: "",
                ratios: ""
            })

            property var ai: ({
                googleApiKey: ""
            })

            property var manga: ({
                scrollSpeed: 5,
                pageSpacing: 4,
                defaultSite: "comix",
                preloadPages: 1500,
                filterAdult: true
            })
        }
    }
}
