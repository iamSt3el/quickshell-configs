import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import QtCore

pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    property string wallpaperDir: "/home/steel/wallpaper"
    property string cacheDir: StandardPaths.writableLocation(StandardPaths.CacheLocation).toString().replace("file://", "") + "/wallpaper-thumbs"
    property int thumbSize: 256
    property string wallpaperScript:"/home/steel/.config/quickshell/scripts/wallpaper.sh"

    property list<string> wallpapers: []
    property var wallpaperMap: ({})
    property var processedFiles: ({})

    property alias folderModel: folderModel
    property alias cacheModel: cacheModel

    property int currentIndex: 0
    property bool isProcessing: false

    Process {
        id: createCacheDir
        command: ["sh", "-c", "mkdir -p '" + root.cacheDir + "' && ls '" + root.cacheDir + "' > /dev/null"]
        running: true
        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("[ServiceWallpaper] Cache directory ready:", root.cacheDir)
                console.log("[ServiceWallpaper] Setting cache folder to:", "file://" + root.cacheDir)
                console.log("[ServiceWallpaper] Setting wallpaper folder to:", "file://" + root.wallpaperDir)
                cacheModel.folder = "file://" + root.cacheDir
                folderModel.folder = "file://" + root.wallpaperDir
            } else {
                console.error("[ServiceWallpaper] Failed to create cache directory:", root.cacheDir)
            }
        }
    }

    FolderListModel {
        id: folderModel
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.bmp", "*.PNG", "*.JPG", "*.JPEG"]
        showDirs: false
        showFiles: true
        showDotAndDotDot: false
        showOnlyReadable: true

        onFolderChanged: {
            console.log("[ServiceWallpaper] Scanning wallpaper folder:", root.wallpaperDir)
        }

        onCountChanged: {
            console.log("[ServiceWallpaper] Found", count, "wallpapers in folder")
            if (count === 0) {
                console.warn("[ServiceWallpaper] No wallpapers found! Check if folder exists:", root.wallpaperDir)
            }
            if (count > 0 && !root.isProcessing) {
                generateThumbnails()
            }
        }

        onStatusChanged: {
            if (status === FolderListModel.Ready && count === 0) {
                console.warn("[ServiceWallpaper] Folder is ready but empty. Path:", root.wallpaperDir)
            }
        }
    }

    FolderListModel {
        id: cacheModel
        nameFilters: ["*.jpg"]
        showDirs: false
        showFiles: true
        showDotAndDotDot: false
        showOnlyReadable: true

        onFolderChanged: {
            console.log("[ServiceWallpaper] Cache folder changed to:", folder)
        }

        onCountChanged: {
            console.log("[ServiceWallpaper] Cache contains", count, "thumbnails")
            updateWallpapersList()
        }

        onStatusChanged: {
            console.log("[ServiceWallpaper] Cache model status:", status)
        }
    }

    function generateThumbnails() {
        if (folderModel.count === 0 || root.isProcessing) return
        console.log("[ServiceWallpaper] Starting thumbnail generation for", folderModel.count, "wallpapers")
        root.isProcessing = true
        currentIndex = 0
        processNextThumbnail()
    }

    function processNextThumbnail() {
        while (currentIndex < folderModel.count) {
            const originalPath = folderModel.get(currentIndex, "filePath")

            if (!root.processedFiles[originalPath]) {
                const hash = Qt.md5(originalPath)
                const thumbPath = root.cacheDir + "/" + hash + ".jpg"

                root.processedFiles[originalPath] = true

                thumbChecker.originalPath = originalPath
                thumbChecker.thumbPath = thumbPath
                thumbChecker.command = ["test", "-f", thumbPath]
                thumbChecker.running = true
                return
            }

            currentIndex++
        }

        // All done
        console.log("[ServiceWallpaper] Thumbnail generation completed. Updating wallpapers list...")
        root.isProcessing = false
        updateWallpapersList()
    }

    Process {
        id: thumbChecker
        property string originalPath: ""
        property string thumbPath: ""

        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("[ServiceWallpaper] Thumbnail exists:", thumbPath)
                root.wallpaperMap[thumbPath] = originalPath
                currentIndex++
                processNextThumbnail()
            } else {
                console.log("[ServiceWallpaper] Generating thumbnail for:", originalPath)
                thumbGenerator.originalPath = originalPath
                thumbGenerator.thumbPath = thumbPath
                thumbGenerator.command = [
                    "convert",
                    originalPath,
                    "-resize", root.thumbSize + "x" + root.thumbSize + "^",
                    "-gravity", "center",
                    "-extent", root.thumbSize + "x" + root.thumbSize,
                    "-quality", "85",
                    thumbPath
                ]
                thumbGenerator.running = true
            }
        }
    }

    Process {
        id: thumbGenerator
        property string originalPath: ""
        property string thumbPath: ""

        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("[ServiceWallpaper] Thumbnail generated successfully:", thumbPath)
                root.wallpaperMap[thumbPath] = originalPath
            } else {
                console.error("[ServiceWallpaper] Failed to generate thumbnail for:", originalPath)
            }
            currentIndex++
            processNextThumbnail()
        }
    }

    function updateWallpapersList() {
        const newWallpapers = []

        console.log("[ServiceWallpaper] Updating wallpapers list from cache...")
        for (let i = 0; i < cacheModel.count; i++) {
            const cachePath = cacheModel.get(i, "filePath")
            console.log("[ServiceWallpaper] Cache file:", cachePath)
            if (cachePath && cachePath.length) {
                newWallpapers.push(cachePath)
            }
        }

        console.log("[ServiceWallpaper] Total wallpapers available:", newWallpapers.length)
        root.wallpapers = newWallpapers
    }

    function getOriginalPath(cachePath: string): string {
        return root.wallpaperMap[cachePath] || cachePath
    }

    function setWallpaper(cachePath: string) {
        const originalPath = getOriginalPath(cachePath)
        if (originalPath) {
            console.log("[ServiceWallpaper] Setting wallpaper:", originalPath)
            wallpaperSetter.exec([wallpaperScript, originalPath])
            wallpapersChanged()
        } else {
            console.error("[ServiceWallpaper] Cannot find original path for:", cachePath)
        }
    }

    Process {
        id: wallpaperSetter

        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("[ServiceWallpaper] Wallpaper set successfully")
            } else {
                console.error("[ServiceWallpaper] Failed to set wallpaper. Exit code:", exitCode)
            }
        }
    }

    function refresh() {
        console.log("[ServiceWallpaper] Refreshing wallpaper list")
        const folder = folderModel.folder
        folderModel.folder = ""
        folderModel.folder = folder
    }
}
