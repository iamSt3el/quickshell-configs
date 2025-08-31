import Quickshell
import QtQuick
import qs.util

Item {
    id: root
    
    // Public properties
    property date currentDate: new Date()
    property date selectedDate: new Date()
    property int currentMonth: currentDate.getMonth()
    property int currentYear: currentDate.getFullYear()
    
    Colors {
        id: colors
    }
    
    // Helper functions
    function getDaysInMonth(month, year) {
        return new Date(year, month + 1, 0).getDate()
    }
    
    function getFirstDayOfMonth(month, year) {
        return new Date(year, month, 1).getDay()
    }
    
    function getMonthName(month) {
        const months = [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ]
        return months[month]
    }
    
    function isToday(day, month, year) {
        const today = new Date()
        return day === today.getDate() && 
               month === today.getMonth() && 
               year === today.getFullYear()
    }
    
    function isSelected(day, month, year) {
        return day === selectedDate.getDate() && 
               month === selectedDate.getMonth() && 
               year === selectedDate.getFullYear()
    }
    
    Rectangle {
        anchors.fill: parent
        color: colors.surfaceVariant
        radius: 12
        
        Column {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10
            
            // Header with month/year and navigation
            Row {
                width: parent.width
                height: 40
                
                // Previous month button
                Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: colors.surfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "‹"
                        font.pixelSize: 18
                        color: colors.surfaceText
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (currentMonth === 0) {
                                currentMonth = 11
                                currentYear--
                            } else {
                                currentMonth--
                            }
                        }
                    }
                }
                
                // Month and year display
                Item {
                    width: parent.width - 70
                    height: parent.height
                    
                    Text {
                        anchors.centerIn: parent
                        text: getMonthName(currentMonth) + " " + currentYear
                        font.pixelSize: 16
                        font.bold: true
                        color: colors.surfaceText
                    }
                }
                
                // Next month button
                Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: colors.surfaceVariant
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Text {
                        anchors.centerIn: parent
                        text: "›"
                        font.pixelSize: 18
                        color: colors.surfaceText
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (currentMonth === 11) {
                                currentMonth = 0
                                currentYear++
                            } else {
                                currentMonth++
                            }
                        }
                    }
                }
            }
            
            // Day headers
            Row {
                width: parent.width
                height: 25
                
                Repeater {
                    model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                    
                    Item {
                        width: parent.width / 7
                        height: parent.height
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            font.pixelSize: 12
                            font.bold: true
                            color: colors.outline
                        }
                    }
                }
            }
            
            // Calendar grid
            Grid {
                width: parent.width
                height: parent.height - 75
                columns: 7
                rows: 6
                
                Repeater {
                    model: 42 // 6 weeks * 7 days
                    
                    Rectangle {
                        width: parent.width / 7
                        height: parent.height / 6
                        color: {
                            if (dayMouseArea.containsMouse && isCurrentMonth) {
                                return colors.surface
                            } else if (isCurrentMonth && isToday(dayNumber, currentMonth, currentYear)) {
                                return colors.primary
                            } else if (isCurrentMonth && isSelected(dayNumber, currentMonth, currentYear)) {
                                return colors.primaryContainer
                            } else {
                                return "transparent"
                            }
                        }
                        radius: 6
                        
                        property int dayNumber: {
                            const firstDay = getFirstDayOfMonth(currentMonth, currentYear)
                            const daysInMonth = getDaysInMonth(currentMonth, currentYear)
                            const dayIndex = index - firstDay + 1
                            
                            if (index < firstDay) {
                                // Previous month days
                                const prevMonth = currentMonth === 0 ? 11 : currentMonth - 1
                                const prevYear = currentMonth === 0 ? currentYear - 1 : currentYear
                                const daysInPrevMonth = getDaysInMonth(prevMonth, prevYear)
                                return daysInPrevMonth - (firstDay - index - 1)
                            } else if (dayIndex > daysInMonth) {
                                // Next month days
                                return dayIndex - daysInMonth
                            } else {
                                // Current month days
                                return dayIndex
                            }
                        }
                        
                        property bool isCurrentMonth: {
                            const firstDay = getFirstDayOfMonth(currentMonth, currentYear)
                            const daysInMonth = getDaysInMonth(currentMonth, currentYear)
                            return index >= firstDay && index < firstDay + daysInMonth
                        }
                        
                        Text {
                            anchors.centerIn: parent
                            text: dayNumber
                            font.pixelSize: 13
                            color: {
                                if (isCurrentMonth && isToday(dayNumber, currentMonth, currentYear)) {
                                    return colors.primaryText
                                } else if (isCurrentMonth && isSelected(dayNumber, currentMonth, currentYear)) {
                                    return colors.primaryContainerText
                                } else if (isCurrentMonth) {
                                    return colors.surfaceText
                                } else {
                                    return colors.outline
                                }
                            }
                            font.bold: (isCurrentMonth && isToday(dayNumber, currentMonth, currentYear)) || 
                                       (isCurrentMonth && isSelected(dayNumber, currentMonth, currentYear))
                        }
                        
                        MouseArea {
                            id: dayMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            
                            onClicked: {
                                if (parent.isCurrentMonth) {
                                    selectedDate = new Date(currentYear, currentMonth, dayNumber)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}