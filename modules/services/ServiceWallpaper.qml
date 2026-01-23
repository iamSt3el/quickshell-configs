import Quickshell
import Qt.labs.folderlistmodel
pragma Singleton
pragma ComponentBehavior: Bound

Singleton {
    id: root
    property list<string> wallpapers: [] 
    property alias folderModel: folderModel // Expose for direct binding when needed
    
    FolderListModel {
        id: folderModel
        folder: "file:///home/steel/.cache/waypaper"
        nameFilters: ["*.png"]
        showDirs: false  
        showFiles: true  
        showDotAndDotDot: false
        showOnlyReadable: true
        sortReversed: false
        onCountChanged: {
            root.wallpapers = []
            for (let i = 0; i < folderModel.count; i++) {
                const path = folderModel.get(i, "filePath") || FileUtils.trimFileProtocol(folderModel.get(i, "fileURL"))
                if (path && path.length) root.wallpapers.push(path)
            }
        }
    }
}
