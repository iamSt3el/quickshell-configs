import Quickshell
import QtQuick

pragma Singleton
pragma ComponentBehavior: Bound

Singleton{
    id: root

    property QtObject size
    property QtObject rounding
    property QtObject duration
    property QtObject radius
    property QtObject margin
    property QtObject spacing

    size : QtObject{
        property int barHeight: 40
        property int arcHeight: 10
        property int arcWidth: 20
        property int lineWidth: 8
        property int notificationPanelWidth: 300
        property int notificationPanelHeight: 550
        property int dashboardPanelWidth: 300
        property int dashboardPanelHeight: 550
        property int batteryPanelWidth: 240
        property int batteryPanelHeight: 260
        property int widgetHeight: 25
        property int iconSizeNormal: 20
        property int batteryWidgetHeight: 40
        property int osdWidth: 200
        property int osdHeight: 60
        property int calanderWidth: 400
        property int calanderHeight: 400
        property int clockHeight: 40
        property int wallpaperPanelWidth: 1200
        property int wallpaperPanelHeight: 520
    }

    rounding : QtObject{
        property int arcY: 10
        property int arcX: 18
    }

    duration : QtObject{
        property int small: 100
        property int normal: 300
        property int large: 400
    }

    radius : QtObject{
        property int small:  5
        property int medium: 10
        property int large: 15
        property int extraLarge: 20
    }

    margin : QtObject{
        property int small:  5
        property int medium: 10
        property int large: 15
    }

    spacing : QtObject{
        property int small:  5
        property int medium: 10
        property int large: 15
    }






}
