# Quickshell Desktop Environment

A sophisticated, feature-rich desktop environment built with Quickshell for Arch Linux + Hyprland. Combines elegant design with powerful functionality including real-time system monitoring, music visualization, and comprehensive system controls.

## ✨ Features

### 🏗️ Architecture
- **Modular Design**: Self-contained components with clear separation of concerns
- **Deep Hyprland Integration**: Native workspace management and window positioning
- **Service-Oriented**: Dedicated monitoring services with efficient polling
- **Responsive UI**: Multi-monitor support with proper anchoring system

### 🖥️ Top Bar System
- **WorkspaceRect**: Interactive Hyprland workspace switcher with dynamic sizing
- **MiddleRect**: Nothing Font clock with full-featured calendar popup
- **UtilityRect**: System tray with music visualizer, monitoring, and controls

### 📊 System Monitoring
- **Real-time Metrics**: CPU, RAM, disk usage, and temperature tracking
- **Visual Indicators**: Animated progress bars with Catppuccin color coding
- **Smart Polling**: 1-second intervals with cross-platform sensor fallbacks
- **Hover Popups**: Detailed system information on demand

### 🎵 Media Integration
- **CAVA Visualizer**: 16-bar real-time audio visualization with custom colors
- **MPRIS Support**: Full media player controls with progress tracking
- **Album Art Display**: Embedded artwork with fallback designs
- **Multi-Player Support**: Handles multiple audio sources intelligently

### 🔧 System Controls
- **Bluetooth Management**: Device discovery, connection, and power control
- **Battery Widget**: UPower integration with charging status and percentage
- **Network Controls**: WiFi management via nmtui integration
- **Power Actions**: System shutdown, reboot, and suspend controls

### 🔔 Notification System
- **FreeDesktop Compliance**: Full notification spec with actions, images, markup
- **Queue Management**: FIFO notification handling with proper data structures
- **Visual Feedback**: Slide animations with scale transforms
- **Rich Content**: App icons, summaries, and body text rendering

### 🎨 Advanced UI
- **Custom Shapes**: SVG-style backgrounds with path-based rendering
- **Smooth Animations**: Extensive use of Behavior animations and easing curves
- **Nothing Font Integration**: Custom typography for consistent branding
- **Interactive Calendar**: Full month view with navigation and date selection

## 📂 Project Structure

```
shell.qml                 # Main entry point - loads TopBar + NotificationServer
├── TopBar.qml           # Main panel container
│   ├── WorkspaceRect    # Hyprland workspace indicators (left)
│   ├── MiddleRect       # Clock + calendar popup (center)  
│   └── UtilityRect      # System controls + visualizer (right)
├── SystemMonitor.qml    # Unified monitoring service
├── MonitorPopup.qml     # Hover-triggered metrics display
├── UserPanel.qml        # Media player + user controls
├── NotificationServer   # FreeDesktop notification handling
├── CalenderApp.qml      # Interactive calendar component
└── BluetoothPanel.qml   # Device management interface
```

## 🎯 Implementation Status

### ✅ Fully Implemented
- **TopBar System**: Complete with workspace switching, clock, and utilities
- **System Monitoring**: CPU, RAM, disk, temperature with visual feedback  
- **Music Visualization**: Real-time CAVA integration with 16 animated bars
- **Battery Management**: UPower integration with charge status display
- **Notification Infrastructure**: Complete server with queue management
- **Calendar Application**: Interactive month view with date selection
- **User Dashboard**: Media controls, sliders, and profile information
- **Bluetooth Controls**: Device discovery, connection, and power management
- **Custom UI Components**: Shapes, animations, and responsive layouts

### ⏸️ Disabled (Ready to Enable)
- **PowerPanel**: System power controls (commented in shell.qml:11)
- **NotificationPanel**: Visual notification display (commented in shell.qml:17)
- **Dock**: Application launcher (commented in shell.qml:8)

### 🔧 Enhancement Opportunities
- **Network Panel**: Expand WiFi management beyond nmtui
- **Audio Controls**: Volume mixer integration
- **System Tray**: Traditional application tray implementation
- **Configuration UI**: Runtime customization interface
- **Plugin Architecture**: Extensible widget system

## 🛠️ Prerequisites

- **Arch Linux** (or Arch-based distribution)
- **Hyprland** window manager
- **Quickshell** framework
- **Qt 6** with QML support

## 🚀 Installation

1. **Install Quickshell**:
   ```bash
   # Using AUR helper (yay/paru)
   yay -S quickshell-git
   
   # Or build from source
   git clone https://github.com/outfoxxed/quickshell
   cd quickshell
   cmake -B build -DCMAKE_BUILD_TYPE=Release
   cmake --build build
   sudo cmake --install build
   ```

2. **Clone this configuration**:
   ```bash
   git clone <repository-url> ~/.config/quickshell
   ```

3. **Install dependencies**:
   ```bash
   sudo pacman -S qt6-base qt6-declarative
   ```

4. **Launch Quickshell**:
   ```bash
   quickshell
   ```

## ⚙️ Configuration

The main configuration is in `shell.qml`. Currently enabled components:
- TopBar (workspace indicators, utilities)
- NotificationServer (system notifications)

Commented components can be enabled by uncommenting the respective lines:
```qml
// Dock{}           // Uncomment to enable dock
// PowerPanel{}     // Uncomment to enable power panel
// NotificationPanel{}  // Uncomment to enable notification panel
```

## 🎨 Customization

### Colors
The theme uses Catppuccin colors defined throughout the components:
- Background: `#11111B`, `#1E1E2E`
- Text: `#CDD6F4`, `#F5F5F5`
- Accents: `#A6E3A1`, `#eba0ac`, `#fab387`, `#f5c2e7`

### Fonts
Custom Nothing Font 5x7 is included in the `fonts/` directory.

### Assets
SVG icons are stored in `assets/` and can be easily replaced or customized.

## 🏗️ Architecture

```
shell.qml           # Main shell configuration
├── TopBar.qml      # Top panel with workspaces and utilities
├── SystemMonitor/  # CPU, RAM, disk, temperature monitoring
├── Notifications/  # Notification system
├── Media/          # Music player and visualizer  
├── Panels/         # User, power, bluetooth panels
└── Components/     # Reusable UI components
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Test your changes with Quickshell
4. Submit a pull request

## 📄 License

This project is open source. Please check the license file for details.

## 🙏 Acknowledgments

- **Quickshell** - The powerful shell framework that makes this possible
- **Catppuccin** - Beautiful color theme
- **Hyprland** - Modern Wayland compositor
- **Nothing Font** - Clean, minimal typography

---

*Built with ❤️ for the Arch Linux + Hyprland community*