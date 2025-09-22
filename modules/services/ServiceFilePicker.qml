pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import qs.modules.services

Singleton{
    id: root

    signal fileSelected(string filePath)
    signal pickingCanceled()

    property bool isPickingFile: false

    Process {
        id: filePickerProcess

        stdout: StdioCollector {
            onStreamFinished: {
                const output = this.text.trim()
                root.isPickingFile = false

                if (output && output.length > 0 && output !== "No file picker available") {
                    ServiceUserSettings.setUserImagePath(output)
                    root.fileSelected(output)
                } else {
                    root.pickingCanceled()
                }
            }
        }
    }

    function pickImageFile(title = "Choose Image") {
        if (isPickingFile) return

        isPickingFile = true
        filePickerProcess.exec([
            "sh", "-c",
            "if command -v zenity >/dev/null 2>&1; then " +
            "zenity --file-selection --title='" + title + "' --file-filter='Image files | *.jpg *.jpeg *.png *.gif *.bmp *.svg *.webp'; " +
            "elif command -v kdialog >/dev/null 2>&1; then " +
            "kdialog --getopenfilename ~ 'Image files (*.jpg *.jpeg *.png *.gif *.bmp *.svg *.webp)'; " +
            "elif command -v yad >/dev/null 2>&1; then " +
            "yad --file --title='" + title + "' --file-filter='Image files | *.jpg *.jpeg *.png *.gif *.bmp *.svg *.webp'; " +
            "else " +
            "echo 'No file picker available'; " +
            "fi"
        ])
    }

    function pickAnyFile(title = "Choose File") {
        if (isPickingFile) return

        isPickingFile = true
        filePickerProcess.exec([
            "sh", "-c",
            "if command -v zenity >/dev/null 2>&1; then " +
            "zenity --file-selection --title='" + title + "'; " +
            "elif command -v kdialog >/dev/null 2>&1; then " +
            "kdialog --getopenfilename ~; " +
            "elif command -v yad >/dev/null 2>&1; then " +
            "yad --file --title='" + title + "'; " +
            "else " +
            "echo 'No file picker available'; " +
            "fi"
        ])
    }

    function pickFolder(title = "Choose Folder") {
        if (isPickingFile) return

        isPickingFile = true
        filePickerProcess.exec([
            "sh", "-c",
            "if command -v zenity >/dev/null 2>&1; then " +
            "zenity --file-selection --directory --title='" + title + "'; " +
            "elif command -v kdialog >/dev/null 2>&1; then " +
            "kdialog --getexistingdirectory ~; " +
            "elif command -v yad >/dev/null 2>&1; then " +
            "yad --file --directory --title='" + title + "'; " +
            "else " +
            "echo 'No file picker available'; " +
            "fi"
        ])
    }
}