# TIDE (Terminal IDE with Copilot) Installer for Windows
# PowerShell script for installing TIDE on Windows systems

param(
    [string]$Version = "1.1.1",
    [switch]$Help
)

# Color functions
function Write-ColorOutput($ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Write-Red($message) { Write-ColorOutput Red $message }
function Write-Green($message) { Write-ColorOutput Green $message }
function Write-Yellow($message) { Write-ColorOutput Yellow $message }
function Write-Blue($message) { Write-ColorOutput Blue $message }
function Write-Cyan($message) { Write-ColorOutput Cyan $message }

# Configuration
$RepoOwner = "amitpatole"
$RepoName = "tide"
$InstallDir = "$env:USERPROFILE\.tide"
$BinDir = "$InstallDir\bin"

# Show help
if ($Help) {
    Write-Output "TIDE Installer for Windows"
    Write-Output ""
    Write-Output "Usage: .\install.ps1 [options]"
    Write-Output ""
    Write-Output "Options:"
    Write-Output "  -Version VERSION    Install specific version (default: 1.1.1)"
    Write-Output "  -Help              Show this help"
    Write-Output ""
    exit 0
}

# ASCII Art Banner
function Show-Banner {
    Write-Cyan @"
████████╗██╗██████╗ ███████╗
╚══██╔══╝██║██╔══██╗██╔════╝
   ██║   ██║██║  ██║█████╗  
   ██║   ██║██║  ██║██╔══╝  
   ██║   ██║██████╔╝███████╗
   ╚═╝   ╚═╝╚═════╝ ╚══════╝

Terminal IDE with Copilot v1.1.1
"@
}

# Detect architecture
function Get-Architecture {
    $arch = $env:PROCESSOR_ARCHITECTURE
    switch ($arch) {
        "AMD64" { return "x64" }
        "ARM64" { return "arm64" }
        default {
            Write-Red "❌ Unsupported architecture: $arch"
            exit 1
        }
    }
}

# Download and install binary
function Install-Binary {
    param($Version, $Arch)
    
    $binaryName = "tide-windows-$Arch-$Version.bin.exe"
    
    # Multiple download URLs to try
    $urls = @(
        "https://github.com/$RepoOwner/$RepoName/releases/download/v$Version/$binaryName",
        "https://github.com/$RepoOwner/$RepoName/releases/download/$Version/$binaryName", 
        "https://raw.githubusercontent.com/$RepoOwner/$RepoName/main/$binaryName",
        "https://raw.githubusercontent.com/$RepoOwner/$RepoName/main/binaries/$binaryName"
    )
    
    $binaryPath = "$BinDir\tide.exe"
    
    Write-Yellow "📥 Downloading TIDE binary..."
    Write-Blue "📍 Binary: $binaryName"
    Write-Blue "📦 Version: $Version"
    
    # Create directories
    if (-not (Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
    }
    
    # Try each URL until one works
    $downloadSuccess = $false
    
    foreach ($url in $urls) {
        Write-Blue "🔄 Trying: $url"
        
        try {
            Invoke-WebRequest -Uri $url -OutFile $binaryPath -UseBasicParsing -ErrorAction Stop
            $downloadSuccess = $true
            Write-Green "✅ Downloaded successfully"
            break
        } catch {
            Write-Yellow "⚠️  Failed, trying next URL..."
            continue
        }
    }
    
    if (-not $downloadSuccess) {
        Write-Red "❌ Failed to download binary from all sources"
        Write-Blue "💡 Tried URLs:"
        foreach ($url in $urls) {
            Write-Output "   - $url"
        }
        Write-Yellow "💡 You can also download manually from: https://github.com/$RepoOwner/$RepoName"
        exit 1
    }
    
    Write-Green "✅ Binary installed to $binaryPath"
}

# Add to PATH
function Add-ToPath {
    Write-Yellow "🔧 Adding TIDE to PATH..."
    
    # Get current user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($currentPath -notlike "*$BinDir*") {
        $newPath = "$BinDir;$currentPath"
        [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
        Write-Green "✅ Added to user PATH"
        
        # Update current session PATH
        $env:PATH = "$BinDir;$env:PATH"
    } else {
        Write-Yellow "⚠️  Already in PATH"
    }
}

# Create Start Menu shortcut
function Create-StartMenuShortcut {
    try {
        $startMenuDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
        $shortcutPath = "$startMenuDir\TIDE.lnk"
        
        $wshShell = New-Object -comObject WScript.Shell
        $shortcut = $wshShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = "$BinDir\tide.exe"
        $shortcut.Description = "Terminal IDE with Copilot integration"
        $shortcut.WorkingDirectory = "$env:USERPROFILE"
        $shortcut.Save()
        
        Write-Green "✅ Created Start Menu shortcut"
    } catch {
        Write-Yellow "⚠️  Could not create Start Menu shortcut"
    }
}

# Verify installation
function Test-Installation {
    Write-Yellow "🔍 Verifying installation..."
    
    $binaryPath = "$BinDir\tide.exe"
    if (Test-Path $binaryPath) {
        try {
            $versionOutput = & $binaryPath --version 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Green "✅ TIDE installed successfully!"
                Write-Blue "📋 Version: $versionOutput"
            } else {
                Write-Yellow "⚠️  Binary installed but may not be working correctly"
            }
        } catch {
            Write-Yellow "⚠️  Binary installed but may not be working correctly"
        }
        
        # Test PATH accessibility
        Write-Yellow "🔍 Testing PATH accessibility..."
        
        # Refresh current session PATH
        $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
        
        try {
            $tidePath = Get-Command tide -ErrorAction SilentlyContinue
            if ($tidePath) {
                Write-Green "✅ 'tide' command is accessible in PATH"
                Write-Blue "📍 tide location: $($tidePath.Source)"
            } else {
                Write-Yellow "⚠️  'tide' command not immediately accessible"
                Write-Blue "💡 You may need to restart PowerShell or your terminal"
            }
        } catch {
            Write-Yellow "⚠️  'tide' command not immediately accessible"
            Write-Blue "💡 You may need to restart PowerShell or your terminal"
        }
    } else {
        Write-Red "❌ Installation verification failed"
        exit 1
    }
}

# Show post-installation instructions
function Show-Instructions {
    Write-Output ""
    Write-Cyan "🎉 Installation Complete!"
    Write-Output ""
    Write-Green "🚀 Getting Started:"
    Write-Output "   1. Restart PowerShell (to refresh PATH)"
    Write-Output "   2. Test installation: tide --version"
    Write-Output "   3. Setup GitHub Copilot: tide --setup-copilot"
    Write-Output "   4. Open a project: tide C:\path\to\project"
    Write-Output ""
    Write-Green "💡 Quick Commands:"
    Write-Output "   tide                      # Open current directory"
    Write-Output "   tide .                    # Open current directory"
    Write-Output "   tide C:\path\to\project   # Open specific project"
    Write-Output "   tide --setup-copilot      # Configure GitHub Copilot"
    Write-Output "   tide --help               # Show all options"
    Write-Output ""
    Write-Green "🆕 What's New in v1.1.1:"
    Write-Output "   • Enhanced color scheme for better visibility"
    Write-Output "   • Visible Copilot input box with clear highlighting"
    Write-Output "   • Interactive GitHub Copilot setup wizard"
    Write-Output "   • VSCode-like 4-panel interface option"
    Write-Output "   • Improved file navigation and UX"
    Write-Output ""
    Write-Green "📚 Documentation:"
    Write-Output "   • GitHub: https://github.com/$RepoOwner/$RepoName"
    Write-Output "   • Issues: https://github.com/Enginuity-Solutions/terminal_ide/issues"
    Write-Output ""
    Write-Cyan "🌊 Welcome to TIDE - Where Terminal meets Modern IDE! 🌊"
}

# Error handling
function Handle-Error {
    param($ErrorMessage)
    Write-Red "❌ Installation failed: $ErrorMessage"
    Write-Yellow "💡 For help, visit: https://github.com/Enginuity-Solutions/terminal_ide/issues"
    exit 1
}

# Cleanup on error
function Invoke-Cleanup {
    if (Test-Path $InstallDir) {
        Write-Yellow "🧹 Cleaning up..."
        Remove-Item -Recurse -Force $InstallDir
    }
}

# Main installation function
function Install-TIDE {
    try {
        Show-Banner
        
        Write-Blue "📥 Installing TIDE (Terminal IDE with Copilot)..."
        Write-Output ""
        
        # Installation steps
        $arch = Get-Architecture
        Write-Blue "🔍 Detected platform: windows-$arch"
        
        Install-Binary -Version $Version -Arch $arch
        Add-ToPath
        Create-StartMenuShortcut
        Test-Installation
        Show-Instructions
        
    } catch {
        Invoke-Cleanup
        Handle-Error "Unexpected error occurred: $($_.Exception.Message)"
    }
}

# Run installation
Install-TIDE
