#!/bin/bash

# Directory to search (default: current directory)
DIR="${1:-.}"

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' not found"
    exit 1
fi

echo "Counting lines in QML files in: $DIR"
echo "==========================================="

# Find all .qml files and count lines
total_lines=0
file_count=0

while IFS= read -r file; do
    lines=$(wc -l < "$file")
    total_lines=$((total_lines + lines))
    file_count=$((file_count + 1))
    echo "$lines lines: $file"
done < <(find "$DIR" -type f -name "*.qml")

echo "==========================================="
echo "Total files: $file_count"
echo "Total lines: $total_lines"
