import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland

Item{
    id: calanderItem
    property bool calenderVisible: false 
    property var clockRect: null
    property real scaleProgress: scaleTransform.yScale

    
    PopupWindow{
        id: calenderApp
        anchor.window: topBar
        implicitWidth: clockWrapper.width
        implicitHeight: 320
        color: "transparent"
        visible: calenderVisible
        anchor{
            rect.x: middleItem.x + (middleRectWrapper.width / 2)
            rect.y: middleRectWrapper.height 
            gravity: Edges.Bottom
        }
        
        Rectangle{
            id: calenderContent
            implicitHeight: parent.height
            implicitWidth: parent.width
            color: "#11111B"
            bottomLeftRadius: 20
            bottomRightRadius: 20
            
            // Initial state for sliding animation only
            y: -50  // Start slightly above
            
            transform: Scale{
                id: scaleTransform
                origin.x: calenderContent.width / 2
                origin.y: 0
                yScale: 0.3
            }
 
            // Calendar implementation
            SystemClock {
                id: systemClock
                precision: SystemClock.Seconds
            }
            
            property date currentDate: systemClock.date
            property int currentMonth: currentDate.getMonth()
            property int currentYear: currentDate.getFullYear()
            property int today: currentDate.getDate()
            
            property var monthNames: [
                "January", "February", "March", "April", "May", "June",
                "July", "August", "September", "October", "November", "December"
            ]
            
            property var weekDayNames: ["S", "M", "T", "W", "T", "F", "S"]
            
            function getDaysInMonth(month, year) {
                return new Date(year, month + 1, 0).getDate();
            }
            
            function getFirstDayOfMonth(month, year) {
                return new Date(year, month, 1).getDay();
            }
            
            function getDaysInPrevMonth(month, year) {
                if (month === 0) {
                    return new Date(year - 1, 12, 0).getDate();
                }
                return new Date(year, month, 0).getDate();
            }
            
                        
            Column {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20
                
                // Header
                Row {
                    width: parent.width
                    height: 40
                    
                    Rectangle {
                        width: 30
                        height: 30
                        color: "transparent"
                        radius: 6
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "‹"
                            font.family: nothingFonts.name
                            font.pixelSize: 18
                            color: Qt.rgba(1, 1, 1, 0.6)
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (calenderContent.currentMonth === 0) {
                                    calenderContent.currentMonth = 11;
                                    calenderContent.currentYear--;
                                } else {
                                    calenderContent.currentMonth--;
                                }
                                calendarGrid.updateCalendar();
                            }
                            
                            onEntered: {
                                parent.color = Qt.rgba(1, 1, 1, 0.1)
                            }
                            onExited: {
                                parent.color = "transparent"
                            }
                        }
                    }
                    
                    Item {
                        width: parent.width - 60
                        height: parent.height
                        
                        
                        Text {
                            anchors.centerIn: parent
                            text: calenderContent.monthNames[calenderContent.currentMonth] + " " + calenderContent.currentYear
                            font.pixelSize: 16
                            font.family: nothingFonts.name
                            font.weight: Font.Medium
                            color: "#cdd6f4"
                        }
                    }
                    
                    Rectangle {
                        width: 30
                        height: 30
                        color: "transparent"
                        radius: 6
                        anchors.verticalCenter: parent.verticalCenter
                        
                        Text {
                            anchors.centerIn: parent
                            text: "›"
                            font.family: nothingFonts.name
                            font.pixelSize: 18
                            color: Qt.rgba(1, 1, 1, 0.6)
                        }
                        
                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (calenderContent.currentMonth === 11) {
                                    calenderContent.currentMonth = 0;
                                    calenderContent.currentYear++;
                                } else {
                                    calenderContent.currentMonth++;
                                }
                                calendarGrid.updateCalendar();
                            }
                            
                            onEntered: {
                                parent.color = Qt.rgba(1, 1, 1, 0.1)
                            }
                            onExited: {
                                parent.color = "transparent"
                            }
                        }
                    }
                }
                
                // Separator line
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Qt.rgba(1, 1, 1, 0.1)
                    
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }
                
                // Weekday headers
                Grid {
                    width: parent.width
                    columns: 7
                    columnSpacing: 8
                    
                    Repeater {
                        model: calenderContent.weekDayNames
                        
                        Rectangle {
                            width: (parent.width - 6 * 8) / 7
                            height: 32
                            color: "transparent"
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.pixelSize: 11
                                font.family: nothingFonts.name
                                font.weight: Font.Medium
                                color: Qt.rgba(1, 1, 1, 0.5)
                            }
                        }
                    }
                }
                
                // Calendar grid
                Grid {
                    id: calendarGrid
                    width: parent.width
                    columns: 7
                    columnSpacing: 4
                    rowSpacing: 4
                    
                    property var calendarDays: []
                    
                    function updateCalendar() {
                        calendarDays = [];
                        
                        var daysInMonth = calenderContent.getDaysInMonth(calenderContent.currentMonth, calenderContent.currentYear);
                        var firstDay = calenderContent.getFirstDayOfMonth(calenderContent.currentMonth, calenderContent.currentYear);
                        var daysInPrevMonth = calenderContent.getDaysInPrevMonth(calenderContent.currentMonth, calenderContent.currentYear);
                        
                        // Previous month trailing days
                        for (var i = firstDay - 1; i >= 0; i--) {
                            calendarDays.push({
                                day: daysInPrevMonth - i,
                                isCurrentMonth: false,
                                isToday: false
                            });
                        }
                        
                        // Current month days
                        for (var day = 1; day <= daysInMonth; day++) {
                            var isToday = (day === calenderContent.today && 
                                          calenderContent.currentMonth === calenderContent.currentDate.getMonth() && 
                                          calenderContent.currentYear === calenderContent.currentDate.getFullYear());
                            
                            calendarDays.push({
                                day: day,
                                isCurrentMonth: true,
                                isToday: isToday
                            });
                        }
                        
                        // Next month leading days
                        var totalCells = Math.ceil((firstDay + daysInMonth) / 7) * 7;
                        var remainingCells = totalCells - (firstDay + daysInMonth);
                        for (var nextDay = 1; nextDay <= remainingCells; nextDay++) {
                            calendarDays.push({
                                day: nextDay,
                                isCurrentMonth: false,
                                isToday: false
                            });
                        }
                        
                        dayRepeater.model = calendarDays;
                    }
                    
                    Component.onCompleted: updateCalendar()
                    
                    Repeater {
                        id: dayRepeater
                        
                        Rectangle {
                            width: (calendarGrid.width - 6 * 4) / 7
                            height: width
                            radius: 8
                            color: {
                                if (modelData.isToday) {
                                    return Qt.rgba(1, 1, 1, 0.15);
                                }
                                if (dayMouseArea.containsMouse && modelData.isCurrentMonth) {
                                    return Qt.rgba(1, 1, 1, 0.08);
                                }
                                return "transparent";
                            }
                            
                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                            
                            Text {
                                anchors.centerIn: parent
                                text: modelData.day
                                font.pixelSize: 13
                                font.family: nothingFonts.name
                                font.weight: modelData.isToday ? Font.DemiBold : Font.Normal
                                color: {
                                    if (!modelData.isCurrentMonth) {
                                        return Qt.rgba(1, 1, 1, 0.2);
                                    }
                                    return "#cdd6f4";
                                }
                            }
                            
                            MouseArea {
                                id: dayMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: modelData.isCurrentMonth ? Qt.PointingHandCursor : Qt.ArrowCursor
                                
                                
                                onClicked: {
                                    if (modelData.isCurrentMonth) {
                                        console.log("Selected date:", modelData.day, calenderContent.monthNames[calenderContent.currentMonth], calenderContent.currentYear);
                                        // Add your date selection logic here
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Update calendar when system date changes
            Connections {
                target: systemClock
                function onDateChanged() {
                    var newToday = systemClock.date.getDate();
                    if (newToday !== calenderContent.today) {
                        calenderContent.currentDate = systemClock.date;
                        calenderContent.today = newToday;
                        calendarGrid.updateCalendar();
                    }
                }
            }
        }
        
        // Opening animation with sliding effects only
        ParallelAnimation {
            id: openAnimation
            
            NumberAnimation {
                target: calenderContent
                property: "y"
                to: 0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.2
            }
            
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 1.0
                duration: 300
                easing.type: Easing.OutCubic
                easing.overshoot: 1.1
            }
        }
        
        // Closing animation
        ParallelAnimation{
            id: closeAnimation
            
            NumberAnimation {
                target: calenderContent
                property: "y"
                to: -30
                duration: 200
                easing.type: Easing.InCubic
            }
            
            NumberAnimation {
                target: scaleTransform
                property: "yScale"
                to: 0.1
                duration: 200
                easing.type: Easing.InCubic
            }
            
            onFinished: {
                calenderVisible = false
                // Reset for next open
                calenderContent.y = -50
                scaleTransform.yScale = 0.3
            }
        }
        
        function open(){
            calenderVisible = true
            openAnimation.start()
        }
        
        function close(){
            closeAnimation.start()
        }

       
    }
    
    function open(){
        calenderApp.open()
    }
    
    function close(){
        calenderApp.close()
    }
}
