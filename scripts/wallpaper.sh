#!/bin/bash
wallpaper="$1"

# Set wallpaper with awww
awww img "$wallpaper" --transition-type fade --transition-duration 4

# Generate color scheme with matugen
matugen image "$wallpaper" -t "scheme-content" -m "dark"

echo "Wallpaper set and colors generated!"
