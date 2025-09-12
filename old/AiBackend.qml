import QtQuick

Item {
    id: backend
    
    // Google Gemini API Configuration
    property string apiKey: "AIzaSyAlloUClKdRegH-pERfnmdrotLDL2HXIDQ"
    property string apiEndpoint: "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    property bool isLoading: false
    
    // Signals
    signal responseReceived(string response)
    signal errorOccurred(string errorMessage)
    signal loadingStateChanged(bool loading)
    
    function sendToGemini(prompt) {
        if (!prompt || isLoading) return
        
        isLoading = true
        loadingStateChanged(true)
        
        var xhr = new XMLHttpRequest()
        xhr.open("POST", apiEndpoint + "?key=" + apiKey)
        xhr.setRequestHeader("Content-Type", "application/json")
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                isLoading = false
                loadingStateChanged(false)
                
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText)
                    var text = response.candidates[0].content.parts[0].text
                    responseReceived(text)
                } else {
                    var errorMsg = "❌ Error " + xhr.status + ": "
                    if (xhr.status === 400) {
                        errorMsg += "Invalid request. Check your API key."
                    } else if (xhr.status === 401) {
                        errorMsg += "Unauthorized. Please check your API key."
                    } else if (xhr.status === 403) {
                        errorMsg += "Forbidden. Check your API permissions."
                    } else if (xhr.status === 429) {
                        errorMsg += "Rate limit exceeded. Try again later."
                    } else if (xhr.status === 500) {
                        errorMsg += "Server error. Try again later."
                    } else {
                        errorMsg += "Unknown error occurred."
                    }
                    errorOccurred(errorMsg)
                }
            }
        }
        
        var requestData = {
            "contents": [{
                "parts": [{
                    "text": prompt
                }]
            }]
        }
        
        xhr.send(JSON.stringify(requestData))
    }
}
