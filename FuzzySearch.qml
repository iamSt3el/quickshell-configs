import QtQuick

QtObject {
    id: fuzzySearch
    
    function fuzzyMatch(pattern, text) {
        pattern = String(pattern || "").toLowerCase()
        text = String(text || "").toLowerCase()
        
        if (pattern === "") return { score: 0, matched: true }
        if (text === "") return { score: -1, matched: false }
        
        let patternIdx = 0
        let score = 0
        let consecutiveMatches = 0
        let maxConsecutive = 0
        
        for (let i = 0; i < text.length && patternIdx < pattern.length; i++) {
            if (text[i] === pattern[patternIdx]) {
                patternIdx++
                consecutiveMatches++
                score += consecutiveMatches * 2
                maxConsecutive = Math.max(maxConsecutive, consecutiveMatches)
            } else {
                consecutiveMatches = 0
            }
        }
        
        if (patternIdx !== pattern.length) {
            return { score: -1, matched: false }
        }
        
        score += maxConsecutive * 5
        score -= text.length - pattern.length
        
        if (text.startsWith(pattern)) {
            score += 50
        }
        
        return { score: score, matched: true }
    }
    
    function searchApplications(apps, searchText) {
        if (!apps || !apps.values) {
            return []
        }
        
        if (!searchText || searchText.trim() === "") {
            return apps.values
        }
        
        let results = []
        let appValues = apps.values
        
        for (let i = 0; i < appValues.length; i++) {
            let app = appValues[i]
            let nameMatch = fuzzyMatch(searchText, app.name || "")
            let descMatch = fuzzyMatch(searchText, app.description || "")
            let execMatch = fuzzyMatch(searchText, app.exec || "")
            
            let bestMatch = Math.max(nameMatch.score, descMatch.score * 0.7, execMatch.score * 0.5)
            
            if (nameMatch.matched || descMatch.matched || execMatch.matched) {
                results.push({
                    app: app,
                    score: bestMatch,
                    nameMatched: nameMatch.matched,
                    descMatched: descMatch.matched,
                    execMatched: execMatch.matched
                })
            }
        }
        
        results.sort(function(a, b) {
            return b.score - a.score
        })
        
        return results.map(function(result) {
            return result.app
        })
    }
}