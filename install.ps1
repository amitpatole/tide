# TIDE (Terminal IDE with Copilot) Installer for Windows
# PowerShell script for installing TIDE on Windows systems

param(
    [string]$Version = "latest",
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
    Write-Output "  -Version VERSION    Install specific version (default: latest)"
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

Terminal IDE with Copilot
"@
}

# Detect platform
function Get-Platform {
    $OS = "windows"
    $Arch = "x64"  # Default to x64
    
    if ([System.Environment]::Is64BitOperatingSystem) {
        $Arch = "x64"
    } else {
        $Arch = "x86"
    }
    
    Write-Blue "🔍 Detected platform: $OS-$Arch"
    return @{OS = $OS; Arch = $Arch}
}

# Get latest version
function Get-LatestVersion {
    if ($Version -eq "latest") {
        try {
            $response = Invoke-RestMethod -Uri "https://api.github.com/repos/$RepoOwner/$RepoName/releases/latest"
            $Version = $response.tag_name
        }
        catch {
            Write-Yellow "⚠️  Cannot fetch latest version. Using default version."
            $Version = "1.0.8"
        }
    }
    
    if (-not $Version) {
        $Version = "1.0.8"
    }
    
    Write-Blue "📦 Installing TIDE version: $Version"
    return $Version
}

# Download and install binary
function Install-Binary {
    param($Platform, $Version)
    
    $BinaryName = "tide-$($Platform.OS)-$($Platform.Arch)-$Version.bin.exe"
    $DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/download/$Version/$BinaryName"
    $FallbackUrl = "https://raw.githubusercontent.com/$RepoOwner/$RepoName/main/$BinaryName"
    $BinaryPath = "$BinDir\tide.exe"
    
    Write-Yellow "📥 Downloading TIDE binary..."
    Write-Blue "📍 Binary: $BinaryName"
    
    # Create directories
    New-Item -ItemType Directory -Force -Path $BinDir | Out-Null
    
    $downloadSuccess = $false
    
    try {
        Write-Blue "🔄 Trying GitHub release..."
        # Try primary download URL
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $BinaryPath -ErrorAction Stop
        $downloadSuccess = $true
        Write-Green "✅ Downloaded from GitHub release"
    }
    catch {
        try {
            Write-Yellow "⚠️  Release not found, trying binary repository..."
            # Try fallback URL
            Invoke-WebRequest -Uri $FallbackUrl -OutFile $BinaryPath -ErrorAction Stop
            $downloadSuccess = $true
            Write-Green "✅ Downloaded from binary repository"
        }
        catch {
            Write-Red "❌ Failed to download binary from all sources"
            Write-Blue "💡 Tried URLs:"
            Write-Output "   - $DownloadUrl"
            Write-Output "   - $FallbackUrl"
            exit 1
        }
    }
    
    if ($downloadSuccess) {
        Write-Green "✅ Binary downloaded to $BinaryPath"
    }
    catch {
        Write-Red "❌ Failed to download binary from $DownloadUrl"
        Write-Red "Error: $($_.Exception.Message)"
        exit 1
    }
}

# Add to PATH
function Add-ToPath {
    Write-Yellow "🔧 Adding TIDE to PATH..."
    
    # Get current user PATH
    $CurrentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
    
    if ($CurrentPath -notlike "*$BinDir*") {
        # Add to user PATH
        $NewPath = "$CurrentPath;$BinDir"
        [Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
        Write-Green "✅ Added to user PATH"
        
        # Update current session PATH
        $env:PATH = "$env:PATH;$BinDir"
    }
    else {
        Write-Yellow "⚠️  Already in PATH"
    }
}

# Create Start Menu shortcut
function Create-StartMenuShortcut {
    Write-Yellow "🔧 Creating Start Menu shortcut..."
    
    try {
        $StartMenuDir = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"
        $ShortcutPath = "$StartMenuDir\TIDE.lnk"
        
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
        $Shortcut.TargetPath = "$BinDir\tide.exe"
        $Shortcut.Description = "Terminal IDE with Copilot integration"
        $Shortcut.WorkingDirectory = "$env:USERPROFILE"
        $Shortcut.Save()
        
        Write-Green "✅ Created Start Menu shortcut"
    }
    catch {
        Write-Yellow "⚠️  Could not create Start Menu shortcut: $($_.Exception.Message)"
    }
}

# Verify installation
function Test-Installation {
    Write-Yellow "🔍 Verifying installation..."
    
    $BinaryPath = "$BinDir\tide.exe"
    
    if (Test-Path $BinaryPath) {
        try {
            # Test if binary works
            $result = & $BinaryPath --version 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Green "✅ TIDE installed successfully!"
                Write-Blue "📋 Version: $result"
            }
            else {
                Write-Yellow "⚠️  Binary installed but may not be working correctly"
            }
        }
        catch {
            Write-Yellow "⚠️  Could not verify binary functionality"
        }
        
        # Test PATH accessibility
        Write-Yellow "🔍 Testing PATH accessibility..."
        
        # Refresh current session PATH
        $env:PATH = [Environment]::GetEnvironmentVariable("PATH", "User") + ";" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
        
        try {
            # Test if tide command is accessible
            $tidePath = Get-Command tide -ErrorAction SilentlyContinue
            if ($tidePath) {
                Write-Green "✅ 'tide' command is accessible in PATH"
                Write-Blue "📍 tide location: $($tidePath.Source)"
            }
            else {
                Write-Yellow "⚠️  'tide' command not immediately accessible"
                Write-Blue "💡 You may need to restart your PowerShell or Command Prompt"
            }
        }
        catch {
            Write-Yellow "⚠️  Could not test PATH accessibility"
        }
    }
    else {
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
    Write-Output "   1. Restart your PowerShell/Command Prompt (to refresh PATH)"
    Write-Output "   2. Test installation: tide --version"
    Write-Output "   3. Run first-time setup: tide --setup"
    Write-Output "   4. Install Copilot (optional): tide --install-copilot"
    Write-Output ""
    Write-Green "💡 Quick Commands:"
    Write-Output "   tide                      # Open current directory"
    Write-Output "   tide .                    # Open current directory"
    Write-Output "   tide C:\path\to\project   # Open specific project"
    Write-Output "   tide -r user@server       # Connect via SSH"
    Write-Output "   tide --help               # Show all options"
    Write-Output "   tide C:\path\to\project   # Open specific project"
    Write-Output "   tide -r user@server       # Connect via SSH"
    Write-Output "   tide --help               # Show all options"
    Write-Output ""
    Write-Green "📚 Documentation:"
    Write-Output "   • GitHub: https://github.com/$RepoOwner/$RepoName"
    Write-Output "   • Issues: https://github.com/Enginuity-Solutions/terminal_ide/issues"
    Write-Output ""
    Write-Cyan "🌊 Welcome to TIDE - Where Terminal meets Modern IDE! 🌊"
}

# Error handling
function Handle-Error {
    param($Message)
    Write-Red "❌ Installation failed: $Message"
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
        
        # Check if running as Administrator (optional warning)
        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
        $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
        
        if (-not $isAdmin) {
            Write-Yellow "💡 Note: Running without administrator privileges. Installation will be user-specific."
        }
        
        # Installation steps
        $Platform = Get-Platform
        $Version = Get-LatestVersion
        Install-Binary -Platform $Platform -Version $Version
        Add-ToPath
        Create-StartMenuShortcut
        Test-Installation
        Show-Instructions
    }
    catch {
        Invoke-Cleanup
        Handle-Error "Unexpected error occurred: $($_.Exception.Message)"
    }
}

# Run installation
Install-TIDE
