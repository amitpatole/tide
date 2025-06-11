#!/bin/bash
# Local TIDE Installation Script
# This script installs TIDE from the local binaries directory

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Configuration
INSTALL_DIR="$HOME/.tide"
BIN_DIR="$INSTALL_DIR/bin"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BINARIES_DIR="$SOURCE_DIR/binaries"

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

Terminal IDE with Copilot - Local Installation
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

# Install binary from local directory
install_local_binary() {
    local binary_name="tide-$OS-$ARCH-1.0.2.bin"
    local source_binary="$BINARIES_DIR/$binary_name"
    local binary_path="$BIN_DIR/tide"
    
    echo -e "${YELLOW}📥 Installing TIDE binary locally...${NC}"
    
    # Check if source binary exists
    if [ ! -f "$source_binary" ]; then
        echo -e "${RED}❌ Binary not found: $source_binary${NC}"
        echo -e "${BLUE}💡 Available binaries:${NC}"
        ls -la "$BINARIES_DIR"
        exit 1
    fi
    
    # Create directories
    mkdir -p "$BIN_DIR"
    
    # Copy binary
    cp "$source_binary" "$binary_path"
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

# Show instructions
show_instructions() {
    echo ""
    echo -e "${CYAN}🎉 Local Installation Complete!${NC}"
    echo ""
    echo -e "${GREEN}🚀 Getting Started:${NC}"
    echo -e "   ${BLUE}1.${NC} Restart your terminal or run: ${YELLOW}source ~/.bashrc${NC} (to refresh PATH)"
    echo -e "   ${BLUE}2.${NC} Test installation: ${YELLOW}tide --version${NC}"
    echo -e "   ${BLUE}3.${NC} Start TIDE: ${YELLOW}tide${NC} or ${YELLOW}tide .${NC}"
    echo -e "   ${BLUE}4.${NC} Get help: ${YELLOW}tide --help${NC}"
    echo ""
    echo -e "${GREEN}💡 Quick Commands:${NC}"
    echo -e "   ${YELLOW}tide${NC}                      # Open current directory"
    echo -e "   ${YELLOW}tide /path/to/project${NC}     # Open specific project"
    echo -e "   ${YELLOW}tide -r user@server${NC}       # Connect via SSH"
    echo ""
    echo -e "${CYAN}🌊 Welcome to TIDE - Local Development Version! 🌊${NC}"
}

# Main installation function
main() {
    print_banner
    
    echo -e "${BLUE}📥 Installing TIDE locally from binaries...${NC}"
    echo ""
    
    # Check if we're in the right directory
    if [ ! -d "$BINARIES_DIR" ]; then
        echo -e "${RED}❌ Error: binaries directory not found${NC}"
        echo -e "${BLUE}💡 Please run this script from the TIDE project root directory${NC}"
        exit 1
    fi
    
    # Installation steps
    detect_platform
    install_local_binary
    add_to_path
    verify_installation
    show_instructions
}

# Run installation
main "$@"
