import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: root
    
    property string mangaName: ""
    property string currentChapter: ""
    property string downloadPath: "/home/steel/manga/" + mangaName + "/" + currentChapter
    property var chapterImages: []
    
    signal imagesReady()
    signal chapterNotFound(string chapter)
    
    function loadChapter(manga, chapter) {
        mangaName = manga;
        currentChapter = chapter;
        chapterImages = [];
        
        console.log("Loading chapter:", chapter);
        
        // Check if images exist locally first
        localChecker.command = ["bash", "-c", `ls "${downloadPath}"/*.jpg "${downloadPath}"/*.png 2>/dev/null | wc -l`];
        localChecker.running = true;
    }
    
    function downloadImages() {
        const chapterUrl = `https://manhwaz.com/webtoon/${mangaName}/${currentChapter}`;
        
        const scriptContent = `#!/bin/bash
            # Create download directory
            mkdir -p "${downloadPath}"
            
            # Check if chapter exists first
            echo "Checking if chapter exists..."
            response=\$(curl -s -w "%{http_code}" -o /dev/null "${chapterUrl}" \\
                -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \\
                -H "Referer: https://manhwaz.com/")
                
            if [ "\$response" != "200" ]; then
                echo "CHAPTER_NOT_FOUND"
                exit 1
            fi
            
            # Extract image URLs and sort them properly
            echo "Extracting image URLs..."
            curl -s "${chapterUrl}" \\
            -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \\
            -H "Referer: https://manhwaz.com/" \\
            -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \\
            | grep -oP 'src="https://cdn\\.manhwaz\\.com/manga/[^"]*\\.(jpg|png)"' \\
            | sed 's/src="//g' | sed 's/"//g' > "${downloadPath}/urls.txt"
            
            # Count total URLs
            total_urls=\$(wc -l < "${downloadPath}/urls.txt")
            if [ \$total_urls -eq 0 ]; then
                echo "CHAPTER_NOT_FOUND"
                exit 1
            fi
            echo "Found \$total_urls images to download"
            
            # Download images sequentially with proper naming
            counter=1
            while IFS= read -r url && [ \$counter -le \$total_urls ]; do
                if [[ -n "$url" ]]; then
                    extension="\${url##*.}"
                    filename="\$(printf "%03d.%s" \$counter "\$extension")"
                    echo "Downloading \$counter/\$total_urls: \$filename"
                    
                    # Download with retry logic
                    for attempt in 1 2 3; do
                        if curl -s "$url" \\
                            -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \\
                            -H "Referer: https://manhwaz.com/" \\
                            -o "${downloadPath}/\$filename"; then
                            echo "SUCCESS:\$counter:\$filename"
                            break
                        else
                            echo "RETRY:\$counter:\$attempt"
                            sleep 1
                        fi
                    done
                    ((counter++))
                fi
            done < "${downloadPath}/urls.txt"
            
            echo "DOWNLOAD_COMPLETE"
        `;
        
        imageDownloader.command = ["bash", "-c", scriptContent];
        imageDownloader.running = true;
    }
    
    function loadLocalImages() {
        const scriptContent = `#!/bin/bash
            if [ -d "${downloadPath}" ]; then
                find "${downloadPath}" -name "*.jpg" -o -name "*.png" | sort -V | head -50
            fi
        `;
        
        localImageLoader.command = ["bash", "-c", scriptContent];
        localImageLoader.running = true;
    }
    
    Process {
        id: localChecker
        
        stdout: SplitParser {
            onRead: data => {
                const count = parseInt(data.trim());
                if (count > 0) {
                    console.log("Found", count, "local images, loading...");
                    loadLocalImages();
                } else {
                    console.log("No local images found, downloading...");
                    downloadImages();
                }
            }
        }
    }
    
    Process {
        id: imageDownloader
        
        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0) return;
                
                if (data.startsWith("SUCCESS:")) {
                    const parts = data.split(":");
                    const imageNumber = parts[1];
                    const filename = parts[2];
                    console.log("Downloaded image", imageNumber + ":", filename);
                } else if (data.startsWith("RETRY:")) {
                    const parts = data.split(":");
                    const imageNumber = parts[1];
                    const attempt = parts[2];
                    console.log("Retrying image", imageNumber, "attempt", attempt);
                } else if (data.startsWith("Found")) {
                    console.log(data);
                } else if (data === "CHAPTER_NOT_FOUND") {
                    console.log("Chapter not found:", root.currentChapter);
                    root.chapterNotFound(root.currentChapter);
                } else if (data === "DOWNLOAD_COMPLETE") {
                    console.log("Download complete, loading images in order...");
                    // Load all images in proper order after download completes
                    loadLocalImages();
                }
            }
        }
    }
    
    Process {
        id: localImageLoader
        
        stdout: SplitParser {
            onRead: data => {
                if (data.length === 0) return;
                if (data.includes('.jpg') || data.includes('.png')) {
                    root.chapterImages.push("file://" + data);
                }
            }
        }
        
        onExited: {
            // Sort images after all are loaded to prevent mixing
            root.chapterImages.sort((a, b) => {
                const aNum = parseInt(a.match(/(\d+)\.(jpg|png)$/)?.[1] || "0");
                const bNum = parseInt(b.match(/(\d+)\.(jpg|png)$/)?.[1] || "0");
                return aNum - bNum;
            });
            
            // Trigger model update once
            root.chapterImages = [...root.chapterImages];
            
            if (root.chapterImages.length > 0) {
                console.log("Loaded", root.chapterImages.length, "local images in order");
                root.imagesReady();
            }
        }
    }
}
