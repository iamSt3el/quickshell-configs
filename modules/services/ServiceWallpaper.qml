import Quickshell
import Quickshell.Io
import Qt.labs.folderlistmodel
import QtCore
import qs.modules.settings
import qs.modules.utils

pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root

    property string wallpaperDir: "/home/steel/wallpaper"
    property string cacheDir: StandardPaths.writableLocation(StandardPaths.CacheLocation).toString().replace("file://", "") + "/wallpaper-thumbs"
    property int thumbSize: 256
    property string wallpaperScript:"/home/steel/.config/quickshell/scripts/wallpaper.sh"
    property string scheme: SettingsConfig.matugenScheme
    property string theme: SettingsConfig.matugenTheme

    property list<string> wallpapers: []
    property var filteredWallpapers: []
    property string currentSearchText: ""
    property var wallpaperMap: ({})
    property var processedFiles: ({})

    // ── Online / Wallhaven ──────────────────────────────────────────────────
    property bool onlineMode: false
    property list<var> onlineWallpapers: []
    property bool isFetchingOnline: false
    property int  onlinePage: 1
    property bool hasMorePages: false
    property string _fetchBuffer: ""
    property string _pendingDownloadPath: ""
    property string onlineError: ""

    onOnlineModeChanged: {
        if (onlineMode) {
            onlineWallpapers = []
            onlinePage = 1
            onlineError = ""
        }
    }

    function buildWallhavenUrl(page) {
        const p = []
        p.push("categories=" + SettingsConfig.wallhavenCategories)
        p.push("purity="     + SettingsConfig.wallhavenPurity)
        p.push("sorting="    + SettingsConfig.wallhavenSorting)
        p.push("order="      + SettingsConfig.wallhavenOrder)
        if (SettingsConfig.wallhavenSorting === "toplist")
            p.push("topRange=" + SettingsConfig.wallhavenTopRange)
        if (SettingsConfig.wallhavenAtleast.length > 0)
            p.push("atleast=" + SettingsConfig.wallhavenAtleast)
        if (SettingsConfig.wallhavenRatios.length > 0)
            p.push("ratios=" + SettingsConfig.wallhavenRatios)
        if (currentSearchText.length > 0)
            p.push("q=" + encodeURIComponent(currentSearchText))
        if (SettingsConfig.wallhavenApiKey.length > 0)
            p.push("apikey=" + SettingsConfig.wallhavenApiKey)
        p.push("page=" + page)
        return "https://wallhaven.cc/api/v1/search?" + p.join("&")
    }

    function fetchWallhaven(resetPage) {
        if (isFetchingOnline) return
        if (resetPage) {
            onlinePage = 1
            onlineWallpapers = []
        }
        isFetchingOnline = true
        onlineError = ""
        _fetchBuffer = ""
        const url = buildWallhavenUrl(onlinePage)
        console.log("[ServiceWallpaper] Fetching Wallhaven page", onlinePage, "–", url)
        wallhavenFetcher.command = ["bash", "-c", "curl -s '" + url + "'"]
        wallhavenFetcher.running = true
    }

    function _parseWallhavenResults(json) {
        try {
            const data = JSON.parse(json)

            // API-level error (e.g. bad API key, invalid params)
            if (data.error) {
                onlineError = data.error
                console.error("[ServiceWallpaper] Wallhaven API error:", data.error)
                isFetchingOnline = false
                return
            }

            const items = data.data || []
            const meta  = data.meta || {}

            const parsed = items.map(item => ({
                id:         item.id,
                thumbUrl:   item.thumbs.large,
                fullUrl:    item.path,
                resolution: item.resolution,
                fileType:   item.file_type
            }))

            onlineWallpapers = (onlinePage === 1)
                ? parsed
                : [...onlineWallpapers, ...parsed]

            hasMorePages = (meta.current_page || 1) < (meta.last_page || 1)
            onlineError = ""
            console.log("[ServiceWallpaper] Wallhaven: got", parsed.length,
                        "wallpapers, page", meta.current_page, "/", meta.last_page)
        } catch (e) {
            // Non-JSON response — usually the rate-limit plain-text message
            const msg = json.trim()
            onlineError = msg.length > 0 ? msg : "Failed to parse response"
            console.error("[ServiceWallpaper] Wallhaven parse error:", e, "| body:", msg)
        }
        isFetchingOnline = false
    }

    function fetchNextPage() {
        if (!hasMorePages || isFetchingOnline) return
        onlinePage++
        fetchWallhaven(false)
    }

    function downloadAndSetWallpaper(wallpaper) {
        if (_pendingDownloadPath.length > 0) {
            console.warn("[ServiceWallpaper] Download already in progress")
            return
        }
        const ext = wallpaper.fullUrl.split('.').pop().split('?')[0] || "jpg"
        const savePath = root.wallpaperDir + "/" + wallpaper.id + "." + ext
        _pendingDownloadPath = savePath
        console.log("[ServiceWallpaper] Downloading wallpaper", wallpaper.id, "->", savePath)
        wallhavenDownloader.command = [
            "bash", "-c",
            "curl -sL '" + wallpaper.fullUrl + "' -o '" + savePath + "'"
        ]
        wallhavenDownloader.running = true
    }
    // ── End Online ──────────────────────────────────────────────────────────

    onWallpapersChanged: updateSearch(currentSearchText)

    function fuzzyQuery(search: string): var {
        const existing = new Set(wallpapers)
        const preps = []
        for (let i = 0; i < folderModel.count; i++) {
            const orig = folderModel.get(i, "filePath")
            const cachePath = root.cacheDir + "/" + Qt.md5(orig) + ".jpg"
            if (existing.has(cachePath)) {
                preps.push({
                    content: Fuzzy.prepare(orig.split("/").pop()),
                    cachePath: cachePath
                })
            }
        }
        return Fuzzy.go(search, preps, { all: true, key: "content" })
            .map(r => r.obj.cachePath)
    }

    function updateSearch(searchText) {
        currentSearchText = searchText
        filteredWallpapers = searchText.length > 0 ? fuzzyQuery(searchText) : [...wallpapers]
    }

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
            wallpaperSetter.exec([wallpaperScript, originalPath, root.scheme, root.theme])
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

    // ── Wallhaven processes ─────────────────────────────────────────────────
    Process {
        id: wallhavenFetcher
        stdout: SplitParser {
            onRead: line => { root._fetchBuffer += line }
        }
        onExited: (exitCode) => {
            if (exitCode === 0) {
                root._parseWallhavenResults(root._fetchBuffer)
            } else {
                root.onlineError = "Network error — check your connection (curl exit " + exitCode + ")"
                console.error("[ServiceWallpaper] Wallhaven curl failed, exit:", exitCode)
                root.isFetchingOnline = false
            }
            root._fetchBuffer = ""
        }
    }

    Process {
        id: wallhavenDownloader
        onExited: (exitCode) => {
            if (exitCode === 0) {
                console.log("[ServiceWallpaper] Download complete:", root._pendingDownloadPath)
                wallpaperSetter.exec([wallpaperScript, root._pendingDownloadPath, root.scheme, root.theme])
                root.refresh()
            } else {
                console.error("[ServiceWallpaper] Download failed for:", root._pendingDownloadPath)
            }
            root._pendingDownloadPath = ""
        }
    }
    // ── End Wallhaven processes ─────────────────────────────────────────────
}
