pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Widgets
import Quickshell.Wayland
import qs.modules.utils
import qs.modules.settings

Singleton{
    id: root
  
    property real scoreThreshold: 0.2
    property var allApplications: DesktopEntries.applications
    property real totalApps: allApplications.values.length
    readonly property list<DesktopEntry> list: Array.from(DesktopEntries.applications.values)
    .sort((a, b) => a.name.localeCompare(b.name))   
    readonly property list<DesktopEntry> pinnedApps: list.filter(app => SettingsConfig.pinnedApps.includes(app.id))

    readonly property var dockModel: {
        const map = new Map()

        for (const id of SettingsConfig.pinnedApps) {
            map.set(id.toLowerCase(), { appId: id, pinned: true, toplevels: [] })
        }

        for (const toplevel of ToplevelManager.toplevels.values) {
            const appId = toplevel.appId?.toLowerCase() ?? ""
            if (!appId) continue
            if (!map.has(appId))
                map.set(appId, { appId: toplevel.appId, pinned: false, toplevels: [] })
            map.get(appId).toplevels.push(toplevel)
        }

        return Array.from(map.values())
    }

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




    function isPinned(app): bool {
        return SettingsConfig.pinnedApps.includes(app.id)
    }

    function pin(app): void {
        if (!SettingsConfig.pinnedApps.includes(app.id))
            SettingsConfig.pinnedApps = [...SettingsConfig.pinnedApps, app.id]
    }

    function unpin(app): void {
        SettingsConfig.pinnedApps = SettingsConfig.pinnedApps.filter(id => id !== app.id)
    }

    function togglePin(app): void {
        if (isPinned(app)) unpin(app)
        else pin(app)
    }

    function isPinnedById(appId: string): bool {
        return SettingsConfig.pinnedApps.some(id => id.toLowerCase() === appId.toLowerCase())
    }

    function togglePinById(appId: string): void {
        if (isPinnedById(appId))
            SettingsConfig.pinnedApps = SettingsConfig.pinnedApps.filter(id => id.toLowerCase() !== appId.toLowerCase())
        else
            SettingsConfig.pinnedApps = [...SettingsConfig.pinnedApps, appId]
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
