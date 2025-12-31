import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Scope {
    id:root
    property int sidesMargin: 20
    property int bgSidesMargin: 10

    PanelWindow {
        id: bar

        color: "transparent"
        visible: true
        implicitHeight: 30

        anchors {
            left: true
            right: true
            top: true
        }
         margins.top: 10

        Rectangle {
            color: Theme.bg
            radius: 15
            implicitHeight: bar.implicitHeight
            anchors {
                fill: parent
                leftMargin: bgSidesMargin
                rightMargin: bgSidesMargin
            }

            Item {
                implicitWidth: upClock.implicitWidth
                implicitHeight: bar.implicitHeight

                anchors {
                    centerIn: parent
                }

                Rectangle {
                    id: upClock

                    implicitHeight: clockwid.implicitHeight
                    implicitWidth: clockwid.implicitWidth
                    color: "transparent"

                    anchors {
                        centerIn:parent
                    }

 //                   ClockWidget {
  //                      id: clockwid
 //                   }

                }

            }
            //everything

            RowLayout {
                anchors {
                    fill: parent
                }
                // WORKSPACES

                Rectangle {
                    height: bar.implicitHeight
                    width: 200
                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    Layout.leftMargin: sidesMargin
                    color: "red"

 //                   Workspaces {
 //                       id: workid
  //                  }

                }
                // OTHER THINGS

                Rectangle {
                    implicitHeight: bar.implicitHeight
                    implicitWidth: 30
                    color: Theme.fg
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: sidesMargin
                }

            }

        }

    }

}
