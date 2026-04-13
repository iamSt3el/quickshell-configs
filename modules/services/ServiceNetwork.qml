pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Networking
import QtQuick

Singleton {
    id: root

    property var availableNetworks: Networking.devices ?? null
    property bool isConnected: Networking.wifiEnabled
    property var currentNetwork: (availableNetworks?.values?.length ?? 0) > 0 ? availableNetworks.values[0] : null

    property var networks: !currentNetwork?.networks?.values ? [] :
        currentNetwork.networks.values.slice()

    property var connectedNetwork: networks.find(n => n.connected) ?? null
    property var savedNetworks: networks.filter(n => n.known && !n.connected)
    property var available: networks.filter(n => !n.known && !n.connected)
    property var connectedAndSavedNetworks: networks.filter(n => n.connected || n.known )

}
