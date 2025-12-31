#!/bin/bash
export HOME=/home/steel
export XDG_CONFIG_HOME=/home/steel/.config
export XDG_CACHE_HOME=/tmp/greeter-cache
export QT_QPA_PLATFORM=wayland

echo "Script started at $(date)" > /tmp/greeter-error.log
echo "Running quickshell..." >> /tmp/greeter-error.log
quickshell -p /home/steel/.config/quickshell/greeter.qml >> /tmp/greeter-error.log 2>&1
echo "Quickshell exited with code $?" >> /tmp/greeter-error.log
