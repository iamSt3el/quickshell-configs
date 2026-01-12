import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents
import qs.modules.services

ColumnLayout{
    id: root
    anchors.fill: parent
    anchors.margins: 10
    spacing: 10

    property var currentYear: new Date().getFullYear()
    property var currentMonth: new Date().getMonth()
    // property var currentSelectedDate

    // Ensure holidays are loaded when year changes
    onCurrentYearChanged: {
        ServiceClock.ensureHolidaysForYear(currentYear);
    }

    Component.onCompleted: {
        ServiceClock.ensureHolidaysForYear(currentYear);

        // // Set current date's holiday info by default
        // const today = new Date();
        // const todayInfo = ServiceClock.checkHoliday(
        //     today.getDate(),
        //     today.getFullYear(),
        //     today.getMonth()
        // );
        // root.currentSelectedDate = todayInfo.info;
    }

    Rectangle{
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        color: Colors.surfaceContainer
        radius: 20

        RowLayout{
            anchors.fill: parent
            anchors.margins: 10
            Rectangle{
                Layout.preferredHeight: left.height + 5
                Layout.preferredWidth: left.width + 10
                radius: 8
                //color: Colors.surfaceContainerHighest
                color: leftArea.containsMouse ? Colors.surfaceContainerHighest : "transparent"

                CustomIconImage{
                    id: left
                    anchors.centerIn: parent
                    icon: "left"
                    size: 20
                }

                Behavior on color{
                    ColorAnimation{
                        duration: 200
                    }
                }

                MouseArea{
                    id: leftArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        root.currentMonth--;
                        if (root.currentMonth < 0) {
                            root.currentMonth = 11;
                            root.currentYear--;
                        }
                    }
                }
            }
            Item{
                Layout.fillWidth: true
                Layout.fillHeight: true
                CustomText{
                    anchors.centerIn: parent
                    content:  ServiceClock.getMonthName(root.currentMonth) + ", " + root.currentYear
                    size: 16
                }
            }
            Rectangle{
                Layout.preferredHeight: right.height + 5
                Layout.preferredWidth: right.width + 10
                radius: 8
                //color: Colors.surfaceContainerHighest
                color: rightArea.containsMouse ? Colors.surfaceContainerHighest : "transparent"

                CustomIconImage{
                    id: right
                    anchors.centerIn: parent
                    icon: "right"
                    size: 20
                }
                Behavior on color{
                    ColorAnimation{
                        duration: 200
                    }
                }

                MouseArea{
                    id: rightArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: {
                        root.currentMonth++;
                        if (root.currentMonth > 11) {
                            root.currentMonth = 0;
                            root.currentYear++;
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: Colors.surfaceContainer
        radius: 20
        clip: true

        ColumnLayout{
            anchors.fill: parent

            Rectangle{
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Colors.surfaceContainer
                radius: 20
                clip: true

                ColumnLayout{
                    anchors.fill: parent
                    anchors.margins: 10

                    GridLayout{
                        //Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        columns: 7
                        columnSpacing: 5

                        Repeater{
                            model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                            Item{
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                CustomText{
                                    anchors.centerIn: parent
                                    weight: 600
                                    content: modelData
                                    size: 18
                                }
                            }
                        }
                    }

                    GridLayout{
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        columns: 7
                        columnSpacing: 5
                        rowSpacing: 5

                        Repeater{
                            model: ServiceClock.generateCalendarGrid(root.currentYear, root.currentMonth)

                            Rectangle{
                                Layout.preferredHeight: 40
                                Layout.fillWidth: true
                                color:{
                                    if(modelData.isToday) return Colors.primary
                                    if(dateArea.containsMouse) return Colors.tertiary
                                    if(!modelData.isCurrentMonth) return "transparent"
                                    return "transparent"
                                }
                                radius: width

                                Rectangle{
                                    anchors.top: parent.top
                                    anchors.topMargin: 2
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    visible: modelData.isHoliday
                                    implicitHeight: 4
                                    implicitWidth: 4
                                    color: Colors.outline
                                    radius: width
                                }

                                Behavior on color{
                                    ColorAnimation{
                                        duration: 200
                                    }
                                }

                                CustomText{
                                    anchors.centerIn: parent
                                    content: modelData.day || ''
                                    size: 18    
                                    weight: 600
                                    color:{
                                        if(dateArea.containsMouse) return Colors.tertiaryText
                                        if(modelData.isToday) return Colors.primaryText
                                        if(modelData.isCurrentMonth) return Colors.surfaceText
                                        return Qt.alpha(Colors.surfaceText, 0.5)
                                    }
                                }

                                MouseArea{
                                    id: dateArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    // onClicked:{
                                    //     root.currentSelectedDate = modelData.info
                                    // }
                                }

                                CustomToolTip{
                                    content: {
                                        if (modelData.isHoliday && modelData.info && modelData.info.length > 0) {
                                            // Join all holiday names with newlines
                                            return modelData.info.map(h => h.name).join("\n");
                                        }
                                        return "";
                                    }
                                    visible: modelData.isHoliday && dateArea.containsMouse
                                }
                            }
                        }
                    }
                }
            }


            // ListView{
            //     Layout.fillWidth: true
            //     Layout.preferredHeight: 200
            //     Layout.margins: 5
            //     orientation: Qt.Vertical
            //     spacing: 8
            //     clip: true
            //     model: root.currentSelectedDate
            //
            //     delegate: Rectangle{
            //         width: ListView.view.width
            //         height: 60
            //         color: Colors.surfaceContainerHighest
            //         radius: 20
            //
            //         CustomText{
            //             anchors.centerIn: parent
            //             content: modelData.name
            //             size: 14
            //         }
            //     }
            // }
        }
    }


}
