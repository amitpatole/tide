#!/bin/bash
# Auto-update README.md with current version information
# This script should be run before every release to keep README.md current

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from package.json
if [ -f "../terminal_ide_with_copilot/package.json" ]; then
    VERSION=$(grep '"version":' ../terminal_ide_with_copilot/package.json | cut -d'"' -f4)
elif [ -f "package.json" ]; then
    VERSION=$(grep '"version":' package.json | cut -d'"' -f4)
else
    echo -e "${RED}❌ Could not find package.json to get version${NC}"
    exit 1
fi

echo -e "${BLUE}🔄 Updating README.md for version ${VERSION}${NC}"

# Get current binary sizes
get_file_size() {
    local file="$1"
    if [ -f "$file" ]; then
        local size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
        local size_mb=$((size / 1024 / 1024))
        echo "~${size_mb}MB"
    else
        echo "~--MB"
    fi
}

# Calculate binary sizes
LINUX_SIZE=$(get_file_size "tide-linux-x64-${VERSION}.bin")
MACOS_SIZE=$(get_file_size "tide-macos-x64-${VERSION}.bin")
WINDOWS_SIZE=$(get_file_size "tide-windows-x64-${VERSION}.bin.exe")

VSCODE_LINUX_SIZE=$(get_file_size "tide-vscode-linux-x64-${VERSION}.bin")
VSCODE_MACOS_SIZE=$(get_file_size "tide-vscode-macos-x64-${VERSION}.bin")
VSCODE_WINDOWS_SIZE=$(get_file_size "tide-vscode-windows-x64-${VERSION}.bin.exe")

echo -e "${YELLOW}📊 Binary sizes:${NC}"
echo -e "  Linux: ${LINUX_SIZE}"
echo -e "  macOS: ${MACOS_SIZE}"
echo -e "  Windows: ${WINDOWS_SIZE}"
echo -e "  VSCode Linux: ${VSCODE_LINUX_SIZE}"
echo -e "  VSCode macOS: ${VSCODE_MACOS_SIZE}"
echo -e "  VSCode Windows: ${VSCODE_WINDOWS_SIZE}"

# Update version badge
sed -i.bak "s/version-[0-9]\+\.[0-9]\+\.[0-9]\+-blue/version-${VERSION}-blue/g" README.md

# Update Available Binaries section
README_TEMP=$(mktemp)

# Read the README.md and replace the Available Binaries section
awk -v version="$VERSION" \
    -v linux_size="$LINUX_SIZE" \
    -v macos_size="$MACOS_SIZE" \
    -v windows_size="$WINDOWS_SIZE" \
    -v vscode_linux_size="$VSCODE_LINUX_SIZE" \
    -v vscode_macos_size="$VSCODE_MACOS_SIZE" \
    -v vscode_windows_size="$VSCODE_WINDOWS_SIZE" '
BEGIN { in_binaries = 0; in_vscode = 0; in_legacy = 0 }

/^### Current Version:/ {
    print "### Current Version: v" version
    print ""
    print "| Platform | Architecture | Binary | Size | Interface |"
    print "|----------|-------------|--------|------|-----------|"
    print "| Linux | x64 | [`tide-linux-x64-" version ".bin`](./tide-linux-x64-" version ".bin) | " linux_size " | Interactive File Browser |"
    print "| macOS | x64 | [`tide-macos-x64-" version ".bin`](./tide-macos-x64-" version ".bin) | " macos_size " | Interactive File Browser |"
    print "| Windows | x64 | [`tide-windows-x64-" version ".bin.exe`](./tide-windows-x64-" version ".bin.exe) | " windows_size " | Interactive File Browser |"
    in_binaries = 1
    next
}

/^### VSCode-like Interface/ {
    print "### VSCode-like Interface (Advanced)"
    print ""
    print "| Platform | Architecture | Binary | Size | Interface |"
    print "|----------|-------------|--------|------|-----------|"
    print "| Linux | x64 | [`tide-vscode-linux-x64-" version ".bin`](./tide-vscode-linux-x64-" version ".bin) | " vscode_linux_size " | VSCode-like 4-Panel Layout |"
    print "| macOS | x64 | [`tide-vscode-macos-x64-" version ".bin`](./tide-vscode-macos-x64-" version ".bin) | " vscode_macos_size " | VSCode-like 4-Panel Layout |"
    print "| Windows | x64 | [`tide-vscode-windows-x64-" version ".bin.exe`](./tide-vscode-windows-x64-" version ".bin.exe) | " vscode_windows_size " | VSCode-like 4-Panel Layout |"
    in_vscode = 1
    next
}

/^### Legacy Binaries/ {
    in_binaries = 0
    in_vscode = 0
    in_legacy = 1
    print $0
    next
}

/^##/ && (in_binaries || in_vscode) {
    in_binaries = 0
    in_vscode = 0
    in_legacy = 0
    print $0
    next
}

in_binaries && /^\|/ { next }
in_vscode && /^\|/ { next }

{ print $0 }
' README.md > "$README_TEMP"

# Replace the original README.md
mv "$README_TEMP" README.md

# Clean up backup
rm -f README.md.bak

echo -e "${GREEN}✅ README.md updated successfully for version ${VERSION}${NC}"
echo -e "${BLUE}💡 Changes made:${NC}"
echo -e "  • Updated version badge to v${VERSION}"
echo -e "  • Updated binary table with current files and sizes"
echo -e "  • Maintained VSCode-like interface section"
echo -e "  • Preserved legacy binaries section"
