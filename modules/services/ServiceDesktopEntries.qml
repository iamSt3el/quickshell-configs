pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Widgets

Singleton {
    id: root

    property var allApplications: DesktopEntries.applications
    property var filteredApps: []
    property string currentSearchText: ""
    property int selectedIndex: 0
    
    
    Component.onCompleted: {
        // Initialize with first 20 apps
        if (allApplications) {
            filteredApps = allApplications.values.slice(0, 20)
        }
    }
    
    onAllApplicationsChanged: {
        if (allApplications && currentSearchText === "") {
            filteredApps = allApplications.values.slice(0, 20)
        }
    }
    
    function updateSearch(searchText) {
        currentSearchText = searchText
        selectedIndex = 0
        
        if (!allApplications) {
            filteredApps = []
            return
        }
        
        if (searchText === "") {
            // Show initial 20 apps when search is empty
            filteredApps = allApplications.values.slice(0, 20)
            return
        }
        
        if (searchText.length > 0) {
            // Simple text matching
            filteredApps = allApplications.values.filter(function(app) {
                return app.name.toLowerCase().includes(searchText.toLowerCase()) ||
                       (app.description && app.description.toLowerCase().includes(searchText.toLowerCase()))
            })
        }
    }
    
    
    function executeApp(app) {
        if (app && app.execute) {
            app.execute()
        }
    }
    
    function setSelectedIndex(index) {
        if (index >= 0 && index < filteredApps.length) {
            selectedIndex = index
        }
    }
    
    function getSelectedApp() {
        if (selectedIndex >= 0 && selectedIndex < filteredApps.length) {
            return filteredApps[selectedIndex]
        }
        return null
    }
    
    // Navigation helpers
    function selectNext() {
        setSelectedIndex(Math.min(filteredApps.length - 1, selectedIndex + 1))
    }
    
    function selectPrevious() {
        setSelectedIndex(Math.max(0, selectedIndex - 1))
    }
    
    function executeSelected() {
        var app = getSelectedApp()
        if (app) {
            executeApp(app)
            return true
        }
        return false
    }
}