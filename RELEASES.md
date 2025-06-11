# Release Information

## Current Version: v1.0.2

### Release Date: June 10, 2025

### Binary Checksums

```
# Linux x64
sha256sum tide-linux-x64-1.0.2.bin
# macOS x64  
shasum -a 256 tide-macos-x64-1.0.2.bin
# Windows x64
certutil -hashfile tide-windows-x64-1.0.2.bin.exe SHA256
```

### Installation Verification

After installation, verify the version:
```bash
tide --version
```

### What's New in v1.0.2

- Complete TypeScript-based IDE architecture
- GitHub Copilot integration framework
- SSH remote development support
- Cross-platform binary building system
- Comprehensive CLI with Commander.js
- Terminal UI with Blessed.js foundation
- Modular service architecture
- Configuration management system
- Automatic versioning system
- Installation scripts for all platforms

### Supported Platforms

| Platform | Architecture | Binary Size | Notes |
|----------|-------------|-------------|--------|
| Linux | x64 | ~50MB | Ubuntu 18.04+, CentOS 7+ |
| macOS | x64 | ~50MB | macOS 10.14+ (Mojave) |
| Windows | x64 | ~50MB | Windows 10 (1903)+ |

### Download Links

- [Linux x64](./packages/distribution/tide-linux-x64-1.0.2.bin)
- [macOS x64](./packages/distribution/tide-macos-x64-1.0.2.bin)  
- [Windows x64](./packages/distribution/tide-windows-x64-1.0.2.bin.exe)

### Source Code

The source code for this release is available at:
[Enginuity-Solutions/terminal_ide](https://github.com/Enginuity-Solutions/terminal_ide)

### Previous Releases

- v1.0.1 - Initial version incrementing system
- v1.0.0 - Initial release of TIDE

For full changelog, see: [CHANGELOG.md](https://github.com/Enginuity-Solutions/terminal_ide/blob/main/CHANGELOG.md)
