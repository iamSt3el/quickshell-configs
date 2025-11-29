pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Widgets


Singleton{
    id: root

    property var allApplications: DesktopEntries.applications
    property var filteredApps: allApplications
    property string currentSearchText: ""
    property int selectedIndex: 0


    function updateSearch(searchText){
        currentSearchText = searchText
        selectedIndex = 0

        if (searchText.length > 0) {
            filteredApps = allApplications.values.filter(function(app) {
                return app.name.toLowerCase().includes(searchText.toLowerCase()) ||
                       (app.description && app.description.toLowerCase().includes(searchText.toLowerCase()))
            })
        }
    }
}
