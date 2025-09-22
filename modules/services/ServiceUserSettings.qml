pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io

Singleton{
    id: root

    property alias settings: userSettingsJsonAdapter
    property string filePath: Quickshell.shellPath("user-settings.json")

    Timer {
        id: fileWriteTimer
        interval: 100
        repeat: false
        onTriggered: {
            userSettingsFileView.writeAdapter()
        }
    }

    FileView {
        id: userSettingsFileView
        path: root.filePath

        onAdapterUpdated: fileWriteTimer.restart()
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound) {
                fileWriteTimer.restart();
            }
        }

        adapter: JsonAdapter {
            id: userSettingsJsonAdapter
            property string userImagePath: ""
            property string userName: "steel"
        }
    }

    function setUserImagePath(path) {
        settings.userImagePath = path
    }

    function setUserName(name) {
        settings.userName = name
    }
}