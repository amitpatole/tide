#!/bin/bash
# TIDE (Terminal IDE with Copilot) Installer for Linux/macOS
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="amitpatole"
REPO_NAME="tide"
INSTALL_DIR="$HOME/.tide"
BIN_DIR="$INSTALL_DIR/bin"
VERSION="1.1.1"

# ASCII Art Banner
print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
████████╗██╗██████╗ ███████╗
╚══██╔══╝██║██╔══██╗██╔════╝
   ██║   ██║██║  ██║█████╗  
   ██║   ██║██║  ██║██╔══╝  
   ██║   ██║██████╔╝███████╗
   ╚═╝   ╚═╝╚═════╝ ╚══════╝

Terminal IDE with Copilot
EOF
    echo -e "${NC}"
}

# Detect OS and architecture
detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    
    case $OS in
        linux*) OS="linux" ;;
        darwin*) OS="macos" ;;
        *) 
            echo -e "${RED}❌ Unsupported operating system: $OS${NC}"
            exit 1
            ;;
    esac
    
    case $ARCH in
        x86_64) ARCH="x64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *)
            echo -e "${RED}❌ Unsupported architecture: $ARCH${NC}"
            exit 1
            ;;
    esac
    
    echo -e "${BLUE}🔍 Detected platform: $OS-$ARCH${NC}"
}

# Get latest version from GitHub API
get_latest_version() {
    if command -v curl >/dev/null 2>&1; then
        VERSION=$(curl -s "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
    elif command -v wget >/dev/null 2>&1; then
        VERSION=$(wget -qO- "https://api.github.com/repos/$REPO_OWNER/$REPO_NAME/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
    else
        echo -e "${YELLOW}⚠️  Cannot fetch latest version. Using default version.${NC}"
        VERSION="1.1.0"
    fi
    
    if [ -z "$VERSION" ]; then
        VERSION="1.1.0"
    fi
    
    echo -e "${BLUE}📦 Installing TIDE version: $VERSION${NC}"
}

# Download and install binary
install_binary() {
    local binary_name="tide-$OS-$ARCH-$VERSION.bin"
    if [ "$OS" = "windows" ]; then
        binary_name="tide-$OS-$ARCH-$VERSION.bin.exe"
    fi
    
    # Try to download from GitHub releases first, then fall back to raw binary repo
    local download_url="https://github.com/$REPO_OWNER/$REPO_NAME/releases/download/$VERSION/$binary_name"
    local fallback_url="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/$binary_name"
    local binary_path="$BIN_DIR/tide"
    
    echo -e "${YELLOW}📥 Downloading TIDE binary...${NC}"
    echo -e "${BLUE}📍 Binary: $binary_name${NC}"
    
    # Create directories
    mkdir -p "$BIN_DIR"
    
    # Try primary download URL first
    local download_success=false
    
    if command -v curl >/dev/null 2>&1; then
        echo -e "${BLUE}🔄 Trying GitHub release...${NC}"
        if curl -L -f -o "$binary_path" "$download_url" 2>/dev/null; then
            download_success=true
        else
            echo -e "${YELLOW}⚠️  Release not found, trying binary repository...${NC}"
            if curl -L -f -o "$binary_path" "$fallback_url" 2>/dev/null; then
                download_success=true
            fi
        fi
    elif command -v wget >/dev/null 2>&1; then
        echo -e "${BLUE}🔄 Trying GitHub release...${NC}"
        if wget -q -O "$binary_path" "$download_url" 2>/dev/null; then
            download_success=true
        else
            echo -e "${YELLOW}⚠️  Release not found, trying binary repository...${NC}"
            if wget -q -O "$binary_path" "$fallback_url" 2>/dev/null; then
                download_success=true
            fi
        fi
    else
        echo -e "${RED}❌ Error: curl or wget required for download${NC}"
        exit 1
    fi
    
    if [ "$download_success" = false ]; then
        echo -e "${RED}❌ Failed to download binary from all sources${NC}"
        echo -e "${BLUE}💡 Tried URLs:${NC}"
        echo -e "   - $download_url"
        echo -e "   - $fallback_url"
        exit 1
    fi
    
    # Make executable
    chmod +x "$binary_path"
    
    echo -e "${GREEN}✅ Binary installed to $binary_path${NC}"
}

# Add to PATH
add_to_path() {
    local export_line="export PATH=\"$BIN_DIR:\$PATH\""
    local comment="# TIDE Terminal IDE"
    
    echo -e "${YELLOW}🔧 Adding TIDE to PATH...${NC}"
    
    # Shell configuration files to update
    local rc_files=()
    
    # Detect shell and add appropriate rc files
    if [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ]; then
        rc_files+=("$HOME/.bashrc" "$HOME/.bash_profile")
    fi
    
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        rc_files+=("$HOME/.zshrc")
    fi
    
    # Always add to .profile as fallback
    rc_files+=("$HOME/.profile")
    
    for rc_file in "${rc_files[@]}"; do
        if [ -f "$rc_file" ]; then
            if ! grep -q "$export_line" "$rc_file"; then
                echo "" >> "$rc_file"
                echo "$comment" >> "$rc_file"
                echo "$export_line" >> "$rc_file"
                echo -e "${GREEN}✅ Added to $rc_file${NC}"
            else
                echo -e "${YELLOW}⚠️  Already in $rc_file${NC}"
            fi
        else
            # Create the file if it doesn't exist
            echo "$comment" > "$rc_file"
            echo "$export_line" >> "$rc_file"
            echo -e "${GREEN}✅ Created $rc_file${NC}"
        fi
    done
}

# Create desktop entry (Linux only)
create_desktop_entry() {
    if [ "$OS" = "linux" ]; then
        local desktop_dir="$HOME/.local/share/applications"
        local desktop_file="$desktop_dir/tide.desktop"
        
        mkdir -p "$desktop_dir"
        
        cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=TIDE
Comment=Terminal IDE with Copilot integration
Exec=$BIN_DIR/tide %F
Icon=terminal
Terminal=true
Categories=Development;IDE;TextEditor;
MimeType=text/plain;text/x-c;text/x-c++;text/x-python;text/x-javascript;text/x-typescript;
Keywords=ide;editor;development;terminal;copilot;
EOF
        
        echo -e "${GREEN}✅ Created desktop entry${NC}"
    fi
}

# Verify installation
verify_installation() {
    echo -e "${YELLOW}🔍 Verifying installation...${NC}"
    
    if [ -x "$BIN_DIR/tide" ]; then
        # Test if binary works
        if "$BIN_DIR/tide" --version >/dev/null 2>&1; then
            echo -e "${GREEN}✅ TIDE installed successfully!${NC}"
            
            # Show version
            local version_output=$("$BIN_DIR/tide" --version 2>/dev/null || echo "Unknown version")
            echo -e "${BLUE}📋 Version: $version_output${NC}"
        else
            echo -e "${YELLOW}⚠️  Binary installed but may not be working correctly${NC}"
        fi
        
        # Test PATH accessibility
        echo -e "${YELLOW}🔍 Testing PATH accessibility...${NC}"
        
        # Add to current session PATH for immediate testing
        export PATH="$BIN_DIR:$PATH"
        
        if command -v tide >/dev/null 2>&1; then
            echo -e "${GREEN}✅ 'tide' command is accessible in PATH${NC}"
            local tide_path=$(which tide)
            echo -e "${BLUE}📍 tide location: $tide_path${NC}"
        else
            echo -e "${YELLOW}⚠️  'tide' command not immediately accessible${NC}"
            echo -e "${BLUE}💡 You may need to restart your terminal or run: source ~/.bashrc${NC}"
        fi
    else
        echo -e "${RED}❌ Installation verification failed${NC}"
        exit 1
    fi
}

# Post-installation instructions
show_instructions() {
    echo ""
    echo -e "${CYAN}🎉 Installation Complete!${NC}"
    echo ""
    echo -e "${GREEN}🚀 Getting Started:${NC}"
    echo -e "   ${BLUE}1.${NC} Restart your terminal or run: ${YELLOW}source ~/.bashrc${NC} (to refresh PATH)"
    echo -e "   ${BLUE}2.${NC} Test installation: ${YELLOW}tide --version${NC}"
    echo -e "   ${BLUE}3.${NC} Setup GitHub Copilot: ${YELLOW}tide --setup-copilot${NC}"
    echo -e "   ${BLUE}4.${NC} Open a project: ${YELLOW}tide /path/to/project${NC}"
    echo ""
    echo -e "${GREEN}💡 Quick Commands:${NC}"
    echo -e "   ${YELLOW}tide${NC}                      # Open current directory"
    echo -e "   ${YELLOW}tide .${NC}                    # Open current directory"
    echo -e "   ${YELLOW}tide /path/to/project${NC}     # Open specific project"
    echo -e "   ${YELLOW}tide --setup-copilot${NC}      # Configure GitHub Copilot"
    echo -e "   ${YELLOW}tide --help${NC}               # Show all options"
    echo ""
    echo -e "${GREEN}📚 Documentation:${NC}"
    echo -e "   • GitHub: ${BLUE}https://github.com/$REPO_OWNER/$REPO_NAME${NC}"
    echo -e "   • Issues: ${BLUE}https://github.com/Enginuity-Solutions/terminal_ide/issues${NC}"
    echo ""
    echo -e "${CYAN}🌊 Welcome to TIDE - Where Terminal meets Modern IDE! 🌊${NC}"
}

# Error handling
handle_error() {
    echo -e "${RED}❌ Installation failed: $1${NC}"
    echo -e "${YELLOW}💡 For help, visit: https://github.com/Enginuity-Solutions/terminal_ide/issues${NC}"
    exit 1
}

# Cleanup on error
cleanup() {
    if [ -d "$INSTALL_DIR" ]; then
        echo -e "${YELLOW}🧹 Cleaning up...${NC}"
        rm -rf "$INSTALL_DIR"
    fi
}

# Main installation function
main() {
    print_banner
    
    echo -e "${BLUE}📥 Installing TIDE (Terminal IDE with Copilot)...${NC}"
    echo ""
    
    # Set error trap
    trap 'cleanup; handle_error "Unexpected error occurred"' ERR
    
    # Check prerequisites
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        handle_error "curl or wget is required for installation"
    fi
    
    # Installation steps
    detect_platform
    get_latest_version
    install_binary
    add_to_path
    create_desktop_entry
    verify_installation
    show_instructions
}

# Handle command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --help)
            echo "TIDE Installer"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --version VERSION    Install specific version"
            echo "  --help              Show this help"
            echo ""
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Run installation
main
