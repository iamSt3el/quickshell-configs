#!/bin/bash
set -e
cd "$(dirname "$0")"

echo "==> Building WfRecorder QML plugin..."
mkdir -p build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j"$(nproc)"

echo "==> Installing to ~/.local/lib/qt6/qml/WfRecorder/ ..."
mkdir -p "$HOME/.local/lib/qt6/qml"
cmake --install .

echo "==> Done. Restart Quickshell to pick up the plugin."
