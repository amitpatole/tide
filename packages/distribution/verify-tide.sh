#!/bin/bash
# TIDE Verification Script
# Quick verification that TIDE is properly installed and accessible

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 TIDE Installation Verification${NC}"
echo ""

# Check if tide command exists
if command -v tide >/dev/null 2>&1; then
    echo -e "${GREEN}✅ TIDE is installed and accessible${NC}"
    
    # Get version
    VERSION=$(tide --version 2>/dev/null || echo "Version check failed")
    echo -e "${BLUE}📋 Version: $VERSION${NC}"
    
    # Get location
    LOCATION=$(which tide)
    echo -e "${BLUE}📍 Location: $LOCATION${NC}"
    
    echo ""
    echo -e "${GREEN}🚀 Ready to use! Try these commands:${NC}"
    echo -e "   ${YELLOW}tide --help${NC}               # Show help"
    echo -e "   ${YELLOW}tide .${NC}                    # Open current directory"
    echo -e "   ${YELLOW}tide --setup${NC}              # Run first-time setup"
    echo -e "   ${YELLOW}tide --install-copilot${NC}    # Install Copilot"
    
else
    echo -e "${RED}❌ TIDE is not accessible via PATH${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Troubleshooting:${NC}"
    
    # Check if binary exists in expected location
    if [ -f "$HOME/.tide/bin/tide" ]; then
        echo -e "   ${BLUE}•${NC} Binary found at: $HOME/.tide/bin/tide"
        echo -e "   ${BLUE}•${NC} Try restarting your terminal"
        echo -e "   ${BLUE}•${NC} Or run: ${YELLOW}source ~/.bashrc${NC}"
        echo -e "   ${BLUE}•${NC} Or add to PATH: ${YELLOW}export PATH=\"$HOME/.tide/bin:\$PATH\"${NC}"
    else
        echo -e "   ${BLUE}•${NC} TIDE may not be installed"
        echo -e "   ${BLUE}•${NC} Install with: ${YELLOW}curl -fsSL https://raw.githubusercontent.com/amitpatole/tide/main/packages/distribution/install.sh | bash${NC}"
    fi
fi
