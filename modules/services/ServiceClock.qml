pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick

Singleton{
    id: root

    SystemClock{
        id: clock
        precision: SystemClock.Seconds
    }

    property var time : Qt.formatDateTime(clock.date, "h:mm a")
    property string hour : Qt.formatDateTime(clock.date, "hh")
    property string minute: Qt.formatDateTime(clock.date, "mm")
    property var seconds: Qt.formatDateTime(clock.date, "ss")
    property var day : Qt.formatDateTime(clock.date, "dddd")
    property var month: Qt.formatDateTime(clock.date, "MMMM")
    property var year: Qt.formatDateTime(clock.date, "yyyy")
    property var date : Qt.formatDateTime(clock.date, "dd")

    // Holiday data - stores holidays for the currently displayed year
    property var holidayData: []
    property int currentHolidayYear: new Date().getFullYear()
    property bool holidaysLoaded: false
    property bool holidayLoadAttempted: false  // Prevent infinite retry loop

    // FileView to monitor holiday cache
    FileView {
        id: holidayFile
        path: Quickshell.env("HOME") + "/.cache/quickshell/holidays/" + root.currentHolidayYear + ".json"

        onLoaded: {
            try {
                root.holidayData = JSON.parse(holidayFile.text());
                root.holidaysLoaded = true;
                root.holidayLoadAttempted = true;
                console.log("Holidays loaded for", root.currentHolidayYear + ":", root.holidayData.length, "holidays");
            } catch (e) {
                console.error("Failed to parse holiday JSON:", e);
                root.holidayData = [];
                root.holidaysLoaded = false;
            }
        }

        onLoadFailed: {
            // Only attempt to run script once per year to prevent infinite loop
            if (!root.holidayLoadAttempted) {
                root.holidayLoadAttempted = true;
                console.log("Holiday cache not found for", root.currentHolidayYear + ", running script...");
                holidayProcess.command = ["bash", Quickshell.env("HOME") + "/.config/quickshell/holidayList.sh", root.currentHolidayYear.toString()];
                holidayProcess.running = true;
            } else {
                console.log("Holiday cache unavailable for", root.currentHolidayYear + ", skipping (already attempted)");
            }
        }
    }

    // Process to run holiday script when cache doesn't exist
    Process {
        id: holidayProcess
        command: []
        running: false

        stdout: SplitParser {
            onRead: data => {
                console.log("Holiday script output:", data);
            }
        }

        onRunningChanged: {
            if (!running && !holidaysLoaded) {
                console.log("Holiday script finished, reloading...");
                // Reload the file after script completes
                holidayFile.reload();
            }
        }
    }

    Component.onCompleted: {
        // FileView will automatically try to load the file for current year
        // If it fails, onLoadFailed will trigger the script
    }

    // Function to load holidays for a specific year
    function ensureHolidaysForYear(year) {
        if (year !== root.currentHolidayYear) {
            root.currentHolidayYear = year;
            root.holidaysLoaded = false;
            root.holidayLoadAttempted = false;  // Reset for new year
            root.holidayData = [];
            // Changing currentHolidayYear will update holidayFile.path, triggering a reload
        }
    }


    function getMonthName(month) {
        const months = [
            "January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"
        ];
        return months[month];
    }

    function getDaysInMonth(year, month) {
        return new Date(year, month + 1, 0).getDate();
    }

    function getFirstDayOfMonth(year, month) {
        return new Date(year, month, 1).getDay();
    }

    function checkHoliday(day, year, month){
        if (!holidaysLoaded || !holidayData) {
            return { isHoliday: false, info: [] };
        }

        // Format date as YYYY-MM-DD for comparison
        const dateStr = year + "-" +
                        String(month + 1).padStart(2, '0') + "-" +
                        String(day).padStart(2, '0');

        // Find all holidays for this date
        const holidays = holidayData.filter(h => h.date === dateStr);

        if (holidays.length > 0) {
            return {
                isHoliday: true,
                info: holidays.map(h => ({
                    name: h.name,
                    date: h.date,
                    dayOfWeek: h.dayOfWeek,
                    dayOfWeekShort: h.dayOfWeekShort
                }))
            };
        }

        return { isHoliday: false, info: [] };
    }

    function generateCalendarGrid(year, month) {
        let grid = [];
        let daysInMonth = getDaysInMonth(year, month);
        let firstDay = getFirstDayOfMonth(year, month);
        let today = new Date();

        // Get previous month info
        let prevMonth = month - 1;
        let prevYear = year;
        if (prevMonth < 0) {
            prevMonth = 11;
            prevYear--;
        }
        let daysInPrevMonth = getDaysInMonth(prevYear, prevMonth);

        // Add days from previous month
        for (let i = firstDay - 1; i >= 0; i--) {
            let day = daysInPrevMonth - i;
            let holidayInfo = checkHoliday(day, prevYear, prevMonth);
            grid.push({
                day: day,
                month: "prev",
                monthIndex: prevMonth,
                year: prevYear,
                isHoliday: holidayInfo.isHoliday,
                info: holidayInfo.info,
                isCurrentMonth: false,
                isToday: today.getFullYear() === prevYear &&
                today.getMonth() === prevMonth &&
                today.getDate() === day
            });
        }

        // Add days of current month
        for (let day = 1; day <= daysInMonth; day++) {
            let holidayInfo = checkHoliday(day, year, month);
            grid.push({
                day: day,
                month: "current",
                monthIndex: month,
                year: year,
                isCurrentMonth: true,
                isHoliday: holidayInfo.isHoliday,
                info: holidayInfo.info,
                isToday: today.getFullYear() === year &&
                today.getMonth() === month &&
                today.getDate() === day
            });
        }

        // Add days from next month to fill the grid (42 cells = 6 rows)
        let remainingCells = 35 - grid.length;
        let nextMonth = month + 1;
        let nextYear = year;
        if (nextMonth > 11) {
            nextMonth = 0;
            nextYear++;
        }

        for (let day = 1; day <= remainingCells; day++) {
            let holidayInfo = checkHoliday(day, nextYear, nextMonth);
            grid.push({
                day: day,
                month: "next",
                monthIndex: nextMonth,
                year: nextYear,
                isCurrentMonth: false,
                isHoliday: holidayInfo.isHoliday,
                info: holidayInfo.info,
                isToday: today.getFullYear() === nextYear &&
                today.getMonth() === nextMonth &&
                today.getDate() === day
            });
        }

        return grid;
    }

}
