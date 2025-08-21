# Quickshell Desktop Environment

A modern, customizable desktop environment built with Quickshell for Arch Linux + Hyprland. Features a clean, minimal interface with system monitoring, notifications, and media controls.

## 🚀 Features

### ✅ Implemented
- **Top Bar**: Elegant top panel with workspace indicators
- **System Monitoring**: Real-time CPU, RAM, disk usage, and temperature monitoring with visual indicators
- **System Monitor Popup**: Detailed system metrics with animated progress bars
- **Notification System**: Complete notification server and panel infrastructure  
- **Media Controls**: Custom music player with visualizer
- **Power Management**: System power controls (shutdown, reboot, suspend)
- **User Panel**: User information and session management
- **Bluetooth Panel**: Bluetooth device management interface
- **Calendar Integration**: Built-in calendar application
- **Custom Components**: Reusable sliders, utility windows, and animated elements
- **Asset Management**: Complete icon set with SVG assets
- **Custom Fonts**: Nothing Font 5x7 integration

### 🎨 Design
- **Catppuccin Theme**: Modern dark color scheme
- **Smooth Animations**: Fluid transitions and interactive feedback
- **Responsive Layout**: Adapts to different screen configurations
- **SVG Icons**: Crisp, scalable vector graphics

## 📋 Todo / Planned Features

### 🔧 Core Functionality
- [ ] **Dock/Taskbar**: Application launcher and running app indicators
- [ ] **Window Management**: Workspace switching and window controls
- [ ] **Audio Controls**: Volume mixer and audio device switching
- [ ] **Network Panel**: WiFi management and connection status
- [ ] **Battery Widget**: Power level and charging status for laptops

### 🎯 Enhancements
- [ ] **Customization Settings**: Theme switching and layout options
- [ ] **Plugin System**: Extensible widget architecture
- [ ] **Multi-Monitor Support**: Enhanced multi-screen layout management
- [ ] **Weather Widget**: Local weather information display
- [ ] **Quick Actions**: Frequently used system shortcuts
- [ ] **System Tray**: Traditional system tray implementation

### 🐛 Improvements
- [ ] **Performance Optimization**: Reduce resource usage
- [ ] **Error Handling**: Robust error management and recovery
- [ ] **Configuration Management**: User-friendly config system
- [ ] **Documentation**: Comprehensive setup and customization guide

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