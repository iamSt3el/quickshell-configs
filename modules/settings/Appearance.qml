import Quickshell
import QtQuick

pragma Singleton
pragma ComponentBehavior: Bound

Singleton{
    id: root

    property QtObject size
    property QtObject rounding

    size : QtObject{
        property int arcHeight: 10
        property int arcWidth: 20
        property int lineWidth: 8
    }

    rounding : QtObject{
        property int arcY: 10
        property int arcX: 18
    }
}
