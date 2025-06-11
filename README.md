# 🚀 TIDE - Binary Distribution

> Pre-compiled binaries for TIDE (Terminal IDE with Copilot) - A production-grade terminal-based IDE with GitHub Copilot integration.

[![Version](https://img.shields.io/badge/version-1.0.2-blue.svg)](https://github.com/amitpatole/tide/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)](#available-binaries)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/Enginuity-Solutions/terminal_ide/blob/main/LICENSE)

## 🎯 Quick Installation

### One-Line Installation

**Linux/macOS:**
```bash
curl -fsSL https://raw.githubusercontent.com/amitpatole/tide/main/packages/distribution/install.sh | bash
```

**Windows (PowerShell):**
```powershell
iwr -useb https://raw.githubusercontent.com/amitpatole/tide/main/packages/distribution/install.ps1 | iex
```

### Manual Installation

1. **Download the binary for your platform** from the [packages/distribution](./packages/distribution/) directory
2. **Make it executable** (Linux/macOS): `chmod +x tide-*`
3. **Move to PATH**: `sudo mv tide-* /usr/local/bin/tide`
4. **Run**: `tide`

## 📦 Available Binaries

### Current Version: v1.0.2

| Platform | Architecture | Binary | Size |
|----------|-------------|--------|------|
| Linux | x64 | [`tide-linux-x64-1.0.2.bin`](./packages/distribution/tide-linux-x64-1.0.2.bin) | ~50MB |
| macOS | x64 | [`tide-macos-x64-1.0.2.bin`](./packages/distribution/tide-macos-x64-1.0.2.bin) | ~50MB |
| Windows | x64 | [`tide-windows-x64-1.0.2.bin.exe`](./packages/distribution/tide-windows-x64-1.0.2.bin.exe) | ~50MB |

### Legacy Binaries (Latest)

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x64 | [`tide-linux-x64.bin`](./packages/distribution/tide-linux-x64.bin) |
| macOS | x64 | [`tide-macos-x64.bin`](./packages/distribution/tide-macos-x64.bin) |
| Windows | x64 | [`tide-windows-x64.bin.exe`](./packages/distribution/tide-windows-x64.bin.exe) |

## 🚀 Getting Started

After installation, you can start TIDE with:

```bash
# Start in current directory
tide

# Start in specific directory
tide /path/to/project

# Connect to remote server
tide -r user@hostname

# Show help
tide --help

# Install GitHub Copilot
tide --install-copilot
```

### ✅ Verify Installation

After installation, verify that TIDE is working correctly:

```bash
# Quick verification script
curl -fsSL https://raw.githubusercontent.com/amitpatole/tide/main/packages/distribution/verify-tide.sh | bash

# Manual verification
tide --version
```

If `tide` command is not found, restart your terminal or run:
```bash
source ~/.bashrc  # Linux/macOS
# OR restart PowerShell on Windows
```

## ✨ Features

- **Rich Terminal UI** - Full-featured IDE interface in your terminal
- **GitHub Copilot Integration** - AI-powered code completion and assistance
- **Remote Development** - SSH support for remote coding
- **Multi-Platform** - Native binaries for Linux, macOS, and Windows
- **Language Support** - IntelliSense for 20+ programming languages
- **Git Integration** - Built-in version control operations
- **Extension System** - Plugin architecture for custom functionality
- **Command Palette** - Quick access to all IDE functions
- **Split Views** - Multiple editor panes and layouts
- **Theme Support** - Customizable themes and appearance

## 🔧 Configuration

TIDE can be configured using a YAML configuration file:

```bash
# Set configuration values
tide config --set theme dark
tide config --set editor.fontSize 14

# Get configuration values
tide config --get theme

# List all configuration
tide config --list
```

## 🌐 Remote Development

Connect to remote servers seamlessly:

```bash
# SSH with password authentication
tide -r user@hostname

# SSH with key authentication
tide -r user@hostname --ssh-key ~/.ssh/id_rsa

# SSH with custom port
tide -r user@hostname:2222
```

## 📚 Documentation

- **Source Code**: [Enginuity-Solutions/terminal_ide](https://github.com/Enginuity-Solutions/terminal_ide)
- **Documentation**: [GitHub Wiki](https://github.com/Enginuity-Solutions/terminal_ide/wiki)
- **Issues**: [Issue Tracker](https://github.com/Enginuity-Solutions/terminal_ide/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Enginuity-Solutions/terminal_ide/discussions)

## 🏗️ Build Information

These binaries are automatically built from the source code using:
- **Node.js** v18+ with TypeScript
- **PKG** for binary compilation
- **Cross-platform** build system
- **Automated versioning** with semantic versioning

## 📋 System Requirements

### Minimum Requirements
- **RAM**: 512MB available
- **Storage**: 100MB free space
- **Terminal**: VT100 compatible terminal emulator

### Recommended Requirements
- **RAM**: 2GB available
- **Storage**: 1GB free space
- **Terminal**: Modern terminal with Unicode support
- **SSH Client**: For remote development features

### Supported Platforms
- **Linux**: Ubuntu 18.04+, CentOS 7+, Debian 9+, Fedora 30+
- **macOS**: 10.14 (Mojave) or later
- **Windows**: Windows 10 (1903) or later, Windows Server 2019+

## 🔐 Security

- All binaries are signed and verified
- SSH connections use secure authentication
- No telemetry or data collection
- Open source and auditable

## 🆘 Troubleshooting

### Common Issues

**Binary won't execute:**
```bash
# Make sure it's executable (Linux/macOS)
chmod +x tide-*

# Check if it's in PATH
which tide
```

**Permission denied:**
```bash
# Install to user directory instead
mkdir -p ~/.local/bin
mv tide-* ~/.local/bin/tide
export PATH="$HOME/.local/bin:$PATH"
```

**SSH connection fails:**
```bash
# Test SSH connection first
ssh user@hostname

# Use specific key
tide -r user@hostname --ssh-key ~/.ssh/id_rsa
```

### Getting Help

- **GitHub Issues**: [Report bugs](https://github.com/Enginuity-Solutions/terminal_ide/issues)
- **Discussions**: [Ask questions](https://github.com/Enginuity-Solutions/terminal_ide/discussions)
- **Email**: amit.patole@gmail.com

## 📝 License

MIT License - see [LICENSE](https://github.com/Enginuity-Solutions/terminal_ide/blob/main/LICENSE) for details.

## 🤝 Contributing

While this repository contains only binaries, contributions to the source code are welcome at:
[Enginuity-Solutions/terminal_ide](https://github.com/Enginuity-Solutions/terminal_ide)

---

**Built with ❤️ by [Amit Patole](https://github.com/amitpatole)**
