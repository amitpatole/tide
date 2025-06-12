# TIDE v1.1.1 - Production Release

**TIDE (Terminal IDE with Copilot)** - A modern, VSCode-like terminal IDE with GitHub Copilot integration.

## 🚀 Latest Release - v1.1.1 (Production)

### What's New in v1.1.1
- ✅ **Enhanced Color Scheme** - High contrast, fully visible interface
- ✅ **Visible Copilot Input Box** - Clear, functional chat interface  
- ✅ **Improved Setup Wizard** - Interactive GitHub Copilot configuration
- ✅ **Better UX** - Enhanced dialog boxes and user interactions
- ✅ **VSCode-like Interface** - Complete 4-panel layout (Explorer, Editor, Copilot, Terminal)

## 📦 Available Binaries

### Interactive Version (Primary)
- `tide-linux-x64-1.1.1.bin` (55.3 MB) - Linux x64
- `tide-macos-x64-1.1.1.bin` (60.3 MB) - macOS x64  
- `tide-windows-x64-1.1.1.bin.exe` (46.7 MB) - Windows x64

### VSCode-like Version (Advanced)
- `tide-vscode-linux-x64-1.1.1.bin` (46.5 MB) - Linux x64
- `tide-vscode-macos-x64-1.1.1.bin` (51.5 MB) - macOS x64
- `tide-vscode-windows-x64-1.1.1.bin.exe` (37.9 MB) - Windows x64

## 🛠️ Quick Installation

### One-line Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/amitpatole/tide/main/install.sh | bash
```

### PowerShell (Windows)
```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/amitpatole/tide/main/install.ps1'))
```

### Manual Download
Download the appropriate binary for your platform and make it executable:
```bash
chmod +x tide-*-1.1.1.bin
./tide-*-1.1.1.bin --version
```

## 🎯 Features

### Core Features
- **File Explorer** - Navigate and manage files with icons
- **Code Editor** - Edit files with syntax highlighting and line numbers
- **Terminal Integration** - Execute commands in integrated terminal
- **GitHub Copilot** - AI-powered code assistance and chat

### Interface Panels
1. **Explorer (Left 25%)** - File tree navigation
2. **Editor (Center 50%)** - Code editing with cursor tracking
3. **Copilot (Right 25%)** - Chat interface with GitHub Copilot
4. **Terminal (Bottom 30%)** - Command execution with history

### Controls
- **Tab** - Switch between panels
- **Arrow Keys** - Navigate within active panel
- **Enter** - Open file/Execute command
- **Ctrl+C** - Exit

## 🤖 GitHub Copilot Setup

1. Install TIDE: `tide --version`
2. Setup Copilot: `tide --setup-copilot`
3. Follow the interactive wizard
4. Restart TIDE and enjoy AI assistance!

## 🔧 Usage

```bash
# Open current directory
tide

# Open specific project
tide /path/to/project

# Setup GitHub Copilot
tide --setup-copilot

# Show help
tide --help

# Show version
tide --version
```

## 📚 Documentation

- **Source Code**: [terminal_ide_with_copilot](https://github.com/Enginuity-Solutions/terminal_ide)
- **Binary Releases**: [tide repository](https://github.com/amitpatole/tide)
- **Issues & Support**: [GitHub Issues](https://github.com/Enginuity-Solutions/terminal_ide/issues)

## 🏗️ Architecture

- **Language**: TypeScript/Node.js
- **UI Framework**: Custom terminal UI with chalk for colors
- **Binary Packaging**: PKG for cross-platform distribution
- **Platforms**: Linux, macOS, Windows (x64)

## 📋 System Requirements

- **Linux**: Any modern distribution with Node.js support
- **macOS**: macOS 10.14+ (Mojave or later)  
- **Windows**: Windows 10/11 (x64)
- **Memory**: 256MB RAM minimum
- **Storage**: 100MB free space

## 🔄 Version History

- **v1.1.1** - Production release with enhanced UI and Copilot integration
- **v1.1.0** - Enhanced VSCode-like interface (Alpha)
- **v1.0.9** - Basic VSCode-like interface (Alpha)
- **v1.0.8** - Interactive file browser (Alpha)
- **v1.0.4** - Basic CLI functionality (Alpha)

*Alpha releases are archived in `/archive/alpha-releases/`*

## 🌊 Welcome to TIDE!

**Where Terminal meets Modern IDE** - Experience the power of VSCode in your terminal with AI assistance from GitHub Copilot.

---

*Built with ❤️ for developers who love the terminal*
