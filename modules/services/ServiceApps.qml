pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Widgets
import qs.modules.utils

Singleton{
    id: root
  
    property real scoreThreshold: 0.2
    property var allApplications: DesktopEntries.applications
    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values)
    .sort((a, b) => a.name.localeCompare(b.name))

    property var displayableApps: {
        return allApplications.values.filter(function(app) {
            return !app.runInTerminal
        })
    }

    property var filteredApps: [...list]
    property string currentSearchText: ""
    property int selectedIndex: 0


    readonly property var preppedNames: list.map(a => ({
        name: Fuzzy.prepare(`${a.name} `),
        entry: a
    }))

    function reset(): void{
        filteredApps = [...list]
    }


    function fuzzyQuery(search: string): var { 
        if (root.sloppySearch) {
            const results = list.map(obj => ({
                entry: obj,
                score: Levendist.computeScore(obj.name.toLowerCase(), search.toLowerCase())
            })).filter(item => item.score > root.scoreThreshold)
            .sort((a, b) => b.score - a.score)
            return results
            .map(item => item.entry)
        }

        return Fuzzy.go(search, preppedNames, {
            all: true,
            key: "name"
        }).map(r => {
            return r.obj.entry
        });
    }


    function updateSearch(searchText){
        currentSearchText = searchText
        selectedIndex = 0

        if (searchText.length > 0) {
            filteredApps = fuzzyQuery(searchText)
        } else {
            filteredApps = [...list]
        }
    }
}
