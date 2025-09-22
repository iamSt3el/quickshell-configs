pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.util

Singleton {
    id: root

    property string location: "Phagwara"
    property bool useMetric: true
    property int refreshInterval: 900000 // 15 minutes
    property bool isLoading: false
    property bool hasError: false

    // Weather data properties
    property var currentCondition: null
    property var locationData: null
    property var astronomy: null

    // Convenient properties
    readonly property string temperature: currentCondition ?
        (useMetric ? currentCondition.temp_C + "°C" : currentCondition.temp_F + "°F") : "N/A"
    readonly property string feelsLike: currentCondition ?
        (useMetric ? currentCondition.FeelsLikeC + "°C" : currentCondition.FeelsLikeF + "°F") : "N/A"
    readonly property string humidity: currentCondition ? currentCondition.humidity + "%" : "N/A"
    readonly property string description: currentCondition ? currentCondition.weatherDesc[0].value : "No data"
    readonly property string weatherCode: currentCondition ? currentCondition.weatherCode : "113"
    readonly property string cityName: locationData ? locationData.areaName[0].value : "Unknown"
    readonly property string windSpeed: currentCondition ? currentCondition.windspeedKmph + " km/h" : "N/A"

    Timer {
        id: refreshTimer
        interval: root.refreshInterval
        running: true
        repeat: true
        onTriggered: root.fetchWeather()
        Component.onCompleted: root.fetchWeather()
    }

    function fetchWeather() {
        root.isLoading = true
        root.hasError = false

        let command = `curl -s wttr.in/${location}?format=j1`

        weatherProcess.command[2] = command
        weatherProcess.running = true
    }

    Process {
        id: weatherProcess
        command: ["bash", "-c", ""]

        stdout: StdioCollector {
            onStreamFinished: {
                root.isLoading = false
                if (text.length === 0) {
                    root.hasError = true
                    return
                }

                try {
                    const data = JSON.parse(text)

                    if (data.current_condition && data.current_condition.length > 0) {
                        root.currentCondition = data.current_condition[0]
                    }
                    if (data.nearest_area && data.nearest_area.length > 0) {
                        root.locationData = data.nearest_area[0]
                    }
                    if (data.weather && data.weather.length > 0 && data.weather[0].astronomy) {
                        root.astronomy = data.weather[0].astronomy[0]
                    }

                    root.hasError = false
                } catch (e) {
                    root.hasError = true
                    console.error("Weather data parse error:", e.message)
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (text.length > 0) {
                    root.hasError = true
                }
            }
        }
    }

    function isNightTime() {
        if (!astronomy || !astronomy.sunrise || !astronomy.sunset) {
            // Fallback to simple time check if no astronomy data
            const now = new Date()
            const hour = now.getHours()
            return hour < 6 || hour >= 18
        }

        const now = new Date()
        const currentHour = now.getHours()
        const currentMinute = now.getMinutes()
        const currentTime = currentHour * 60 + currentMinute // Convert to minutes

        // Parse sunrise time (format: "06:30 AM")
        const sunriseStr = astronomy.sunrise
        const sunriseMatch = sunriseStr.match(/(\d{1,2}):(\d{2})\s*(AM|PM)/i)
        if (!sunriseMatch) return currentHour < 6 || currentHour >= 18

        let sunriseHour = parseInt(sunriseMatch[1])
        const sunriseMinute = parseInt(sunriseMatch[2])
        const sunriseAMPM = sunriseMatch[3].toUpperCase()

        if (sunriseAMPM === "PM" && sunriseHour !== 12) sunriseHour += 12
        if (sunriseAMPM === "AM" && sunriseHour === 12) sunriseHour = 0
        const sunriseTime = sunriseHour * 60 + sunriseMinute

        // Parse sunset time (format: "07:45 PM")
        const sunsetStr = astronomy.sunset
        const sunsetMatch = sunsetStr.match(/(\d{1,2}):(\d{2})\s*(AM|PM)/i)
        if (!sunsetMatch) return currentHour < 6 || currentHour >= 18

        let sunsetHour = parseInt(sunsetMatch[1])
        const sunsetMinute = parseInt(sunsetMatch[2])
        const sunsetAMPM = sunsetMatch[3].toUpperCase()

        if (sunsetAMPM === "PM" && sunsetHour !== 12) sunsetHour += 12
        if (sunsetAMPM === "AM" && sunsetHour === 12) sunsetHour = 0
        const sunsetTime = sunsetHour * 60 + sunsetMinute

        // It's night if current time is before sunrise or after sunset
        return currentTime < sunriseTime || currentTime >= sunsetTime
    }

    function getWeatherIcon(code) {
        const isNight = isNightTime()

        const dayIconMap = {
            "113": "wi-day-sunny", // Sunny
            "116": "wi-day-cloudy", // Partly cloudy
            "119": "wi-cloudy", // Cloudy
            "122": "wi-cloudy", // Overcast
            "143": "wi-day-fog", // Mist
            "176": "wi-day-showers", // Patchy rain possible
            "179": "wi-day-snow", // Patchy snow possible
            "182": "wi-day-sleet", // Patchy sleet possible
            "185": "wi-day-sleet", // Patchy freezing drizzle possible
            "200": "wi-day-thunderstorm", // Thundery outbreaks possible
            "227": "wi-day-snow-wind", // Blizzard
            "230": "wi-day-snow-wind", // Blizzard
            "248": "wi-fog", // Fog
            "260": "wi-fog", // Freezing fog
            "263": "wi-day-sprinkle", // Patchy light drizzle
            "266": "wi-day-sprinkle", // Light drizzle
            "281": "wi-day-sleet", // Freezing drizzle
            "284": "wi-day-sleet", // Heavy freezing drizzle
            "293": "wi-day-rain", // Patchy light rain
            "296": "wi-day-rain", // Light rain
            "299": "wi-day-rain", // Moderate rain at times
            "302": "wi-day-rain", // Moderate rain
            "305": "wi-day-rain-wind", // Heavy rain at times
            "308": "wi-day-rain-wind", // Heavy rain
            "311": "wi-day-sleet", // Light freezing rain
            "314": "wi-day-sleet", // Moderate or heavy freezing rain
            "317": "wi-day-sleet", // Light sleet
            "320": "wi-day-sleet-storm", // Moderate or heavy sleet
            "323": "wi-day-snow", // Patchy light snow
            "326": "wi-day-snow", // Light snow
            "329": "wi-day-snow", // Patchy moderate snow
            "332": "wi-day-snow", // Moderate snow
            "335": "wi-day-snow-wind", // Patchy heavy snow
            "338": "wi-day-snow-wind", // Heavy snow
            "350": "wi-day-hail", // Ice pellets
            "353": "wi-day-showers", // Light rain shower
            "356": "wi-day-rain", // Moderate or heavy rain shower
            "359": "wi-day-rain-wind", // Torrential rain shower
            "362": "wi-day-sleet", // Light sleet showers
            "365": "wi-day-sleet-storm", // Moderate or heavy sleet showers
            "368": "wi-day-snow", // Light snow showers
            "371": "wi-day-snow-wind", // Moderate or heavy snow showers
            "374": "wi-day-hail", // Light showers of ice pellets
            "377": "wi-day-hail", // Moderate or heavy showers of ice pellets
            "386": "wi-day-storm-showers", // Patchy light rain with thunder
            "389": "wi-day-thunderstorm", // Moderate or heavy rain with thunder
            "392": "wi-day-snow-thunderstorm", // Patchy light snow with thunder
            "395": "wi-day-snow-thunderstorm"  // Moderate or heavy snow with thunder
        }

        const nightIconMap = {
            "113": "wi-night-clear", // Clear night
            "116": "wi-night-alt-partly-cloudy", // Partly cloudy night
            "119": "wi-night-alt-cloudy", // Cloudy night
            "122": "wi-night-alt-cloudy", // Overcast night
            "143": "wi-night-fog", // Mist
            "176": "wi-night-alt-showers", // Patchy rain possible
            "179": "wi-night-alt-snow", // Patchy snow possible
            "182": "wi-night-alt-sleet", // Patchy sleet possible
            "185": "wi-night-alt-sleet", // Patchy freezing drizzle possible
            "200": "wi-night-alt-thunderstorm", // Thundery outbreaks possible
            "227": "wi-night-alt-snow-wind", // Blizzard
            "230": "wi-night-alt-snow-wind", // Blizzard
            "248": "wi-night-fog", // Fog
            "260": "wi-night-fog", // Freezing fog
            "263": "wi-night-alt-sprinkle", // Patchy light drizzle
            "266": "wi-night-alt-sprinkle", // Light drizzle
            "281": "wi-night-alt-sleet", // Freezing drizzle
            "284": "wi-night-alt-sleet", // Heavy freezing drizzle
            "293": "wi-night-alt-rain", // Patchy light rain
            "296": "wi-night-alt-rain", // Light rain
            "299": "wi-night-alt-rain", // Moderate rain at times
            "302": "wi-night-alt-rain", // Moderate rain
            "305": "wi-night-alt-rain-wind", // Heavy rain at times
            "308": "wi-night-alt-rain-wind", // Heavy rain
            "311": "wi-night-alt-sleet", // Light freezing rain
            "314": "wi-night-alt-sleet", // Moderate or heavy freezing rain
            "317": "wi-night-alt-sleet", // Light sleet
            "320": "wi-night-alt-sleet-storm", // Moderate or heavy sleet
            "323": "wi-night-alt-snow", // Patchy light snow
            "326": "wi-night-alt-snow", // Light snow
            "329": "wi-night-alt-snow", // Patchy moderate snow
            "332": "wi-night-alt-snow", // Moderate snow
            "335": "wi-night-alt-snow-wind", // Patchy heavy snow
            "338": "wi-night-alt-snow-wind", // Heavy snow
            "350": "wi-night-alt-hail", // Ice pellets
            "353": "wi-night-alt-showers", // Light rain shower
            "356": "wi-night-alt-rain", // Moderate or heavy rain shower
            "359": "wi-night-alt-rain-wind", // Torrential rain shower
            "362": "wi-night-alt-sleet", // Light sleet showers
            "365": "wi-night-alt-sleet-storm", // Moderate or heavy sleet showers
            "368": "wi-night-alt-snow", // Light snow showers
            "371": "wi-night-alt-snow-wind", // Moderate or heavy snow showers
            "374": "wi-night-alt-hail", // Light showers of ice pellets
            "377": "wi-night-alt-hail", // Moderate or heavy showers of ice pellets
            "386": "wi-night-alt-storm-showers", // Patchy light rain with thunder
            "389": "wi-night-alt-thunderstorm", // Moderate or heavy rain with thunder
            "392": "wi-night-alt-snow-thunderstorm", // Patchy light snow with thunder
            "395": "wi-night-alt-snow-thunderstorm"  // Moderate or heavy snow with thunder
        }

        const iconMap = isNight ? nightIconMap : dayIconMap
        return iconMap[code] || (isNight ? "wi-night-clear" : "wi-day-sunny")
    }

    readonly property string weatherIconPath: {
        const iconName = getWeatherIcon(weatherCode)
        return IconUtils.getSystemIcon(iconName)
    }
}
