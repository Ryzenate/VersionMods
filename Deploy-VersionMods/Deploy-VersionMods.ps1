<#
.SYNOPSIS
    Deploys VersionMods PowerShell module system-wide
.DESCRIPTION
    This script extracts and installs the VersionMods module to the system's
    PowerShell module directory, making it available to all users.
.PARAMETER ModuleZipPath
    Path to the VersionMods.zip file. Defaults to script directory.
.PARAMETER Force
    Force reinstallation even if module exists
.EXAMPLE
    .\Deploy-VersionMods.ps1
    Deploys module using VersionMods.zip in the same directory
.EXAMPLE
    .\Deploy-VersionMods.ps1 -ModuleZipPath "\\server\share\VersionMods.zip" -Force
    Deploys module from network location, overwriting existing
.NOTES
    Version: 1.0.0
    Requires: PowerShell 5.1 (compatible)
    Run as: Administrator (for system-wide deployment)
#>

param(
    [Parameter()]
    [string]$ModuleZipPath,
    
    [Parameter()]
    [switch]$Force
)

#region Initialization
# Set error handling
$ErrorActionPreference = 'Stop'

# Set default ModuleZipPath if not provided
if (-not $ModuleZipPath) {
    $ModuleZipPath = Join-Path $PSScriptRoot "VersionMods.zip"
}

# Logging function compatible with PS 5.1
function Write-Log {
    param(
        [string]$Message,
        [string]$Level = 'INFO'
    )
    
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        'ERROR' { Write-Host $logMessage -ForegroundColor Red }
        'WARNING' { Write-Host $logMessage -ForegroundColor Yellow }
        default { Write-Host $logMessage -ForegroundColor Green }
    }
}

# Display banner
Write-Log "================================================"
Write-Log "VersionMods Deployment Script (PS 5.1 Compatible)"
Write-Log "Start Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
Write-Log "================================================"
#endregion

#region Pre-flight checks
try {
    # Check for elevated privileges (PS 5.1 compatible)
    $identity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($identity)
    $isAdmin = $principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Log "This script requires Administrator privileges." -Level ERROR
        Write-Log "Please run PowerShell as Administrator and try again." -Level ERROR
        exit 1
    }
    
    Write-Log "Running with Administrator privileges"

    # Check if zip file exists
    if (-not (Test-Path $ModuleZipPath)) {
        Write-Log "Module ZIP file not found: $ModuleZipPath" -Level ERROR
        Write-Log "Please ensure VersionMods.zip is in the same directory as this script." -Level ERROR
        exit 1
    }
    
    Write-Log "Found module ZIP file: $ModuleZipPath"
    
    # Check file size to ensure it's not empty
    $zipInfo = Get-Item $ModuleZipPath
    if ($zipInfo.Length -lt 1024) {
        Write-Log "Warning: ZIP file appears to be very small ($($zipInfo.Length) bytes)" -Level WARNING
    }
}
catch {
    Write-Log "Pre-flight check failed: $_" -Level ERROR
    exit 1
}
#endregion

#region Module Deployment
try {
    # Determine module paths (PS 5.1 compatible)
    $systemModulePath = "$env:ProgramFiles\WindowsPowerShell\Modules"
    
    # Check if path exists, create if not
    if (-not (Test-Path $systemModulePath)) {
        Write-Log "Creating module directory: $systemModulePath"
        New-Item -Path $systemModulePath -ItemType Directory -Force | Out-Null
    }
    
    $versionModsPath = Join-Path $systemModulePath "VersionMods"
    
    # Check if module already exists
    $moduleExists = Test-Path $versionModsPath
$moduleExists
    if ($moduleExists) {
        if ($Force) {
            Write-Log "Removing existing module at: $versionModsPath"
            Remove-Item -Path $versionModsPath -Recurse -Force
        }
        else {
            Write-Log "Module already exists at: $versionModsPath" -Level WARNING
            Write-Log "Use -Force parameter to overwrite existing module." -Level WARNING
            
            # Check if we can load the existing module
            try {
                $existingModule = Get-Module -Name VersionMods -ListAvailable -ErrorAction SilentlyContinue
                if ($existingModule) {
                    Write-Log "Current installed version: $($existingModule.Version)"
                }
                return  # Exit without error if module exists and -Force not used
            }
            catch {
                # Module exists but appears corrupted
                Write-Log "Existing module appears corrupted, overwriting..."
                Remove-Item -Path $versionModsPath -Recurse -Force
                $moduleExists = $false
            }
        }
    }
    
    # Load System.IO.Compression for ZIP extraction (PS 5.1 compatible)
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction Stop
    }
    catch {
        Write-Log "Failed to load compression assembly: $_" -Level ERROR
        Write-Log "This script requires .NET Framework 4.5 or higher." -Level ERROR
        exit 1
    }
    
    # Create extraction directory
    $extractPath = Join-Path $env:TEMP "VersionMods_$(Get-Date -Format 'yyyyMMddHHmmss')"
    Write-Log "Creating extraction directory: $extractPath"
    New-Item -Path $extractPath -ItemType Directory -Force | Out-Null
    
    # Extract ZIP file using .NET methods
    Write-Log "Extracting module from: $ModuleZipPath"
    try {
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ModuleZipPath, $extractPath)
    }
    catch {
        Write-Log "Failed to extract ZIP file: $_" -Level ERROR
        Write-Log "The ZIP file may be corrupted or in an invalid format." -Level ERROR
        Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue
        exit 1
    }
    
    # Verify extracted structure
    $requiredFiles = @('VersionMods.psd1', 'VersionMods.psm1', 'Public')
    foreach ($file in $requiredFiles) {
        $filePath = Join-Path $extractPath $file
        if (-not (Test-Path $filePath)) {
            Write-Log "Missing required component in ZIP: $file" -Level ERROR
            Remove-Item -Path $extractPath -Recurse -Force
            exit 1
        }
    }
    
    Write-Log "Verified extracted module structure"
    
    # Check Public folder has the required scripts
    $publicFolder = Join-Path $extractPath "Public"
    $scriptFiles = Get-ChildItem -Path $publicFolder -Filter "*.ps1" -ErrorAction SilentlyContinue
    if (-not $scriptFiles -or $scriptFiles.Count -lt 3) {
        Write-Log "Warning: Public folder may not contain all expected scripts" -Level WARNING
    }
    
    # Create target directory
    if (Test-Path $versionModsPath) {
        Write-Log "Removing existing target directory"
        Remove-Item -Path $versionModsPath -Recurse -Force
    }
    
    Write-Log "Creating target directory: $versionModsPath"
    New-Item -Path $versionModsPath -ItemType Directory -Force | Out-Null
    
    # Copy all extracted files to target
    Write-Log "Copying module files to target directory"
    Copy-Item -Path "$extractPath\*" -Destination $versionModsPath -Recurse -Force
    
    # Clean up extraction directory
    Write-Log "Cleaning up temporary files"
    Remove-Item -Path $extractPath -Recurse -Force
    
    # Verify deployment
    if (Test-Path $versionModsPath) {
        $deployedFiles = Get-ChildItem -Path $versionModsPath -Recurse | Measure-Object
        Write-Log "Module deployed successfully to: $versionModsPath"
        Write-Log "Deployed $($deployedFiles.Count) files"
    }
    else {
        throw "Module deployment failed - target path not found after copy"
    }
}
catch {
    Write-Log "Module deployment failed: $_" -Level ERROR
    exit 1
}
#endregion

#region Post-deployment Verification
try {
    Write-Log "Verifying module installation..."
    
    # Refresh module cache
    Write-Log "Refreshing module cache..."
    $null = Get-Module -ListAvailable -Refresh
    
    # Test module import
    $module = Get-Module -Name VersionMods -ListAvailable -ErrorAction SilentlyContinue
    if ($module) {
        Write-Log "Module registered in PowerShell: $($module.Version)"
        
        # Try to import and test
        try {
            Import-Module VersionMods -Force -ErrorAction Stop
            Write-Log "Module imported successfully"
            
            # Test each function
            $functions = @('Get-BiosVersion', 'Get-GraphicsVersion', 'Get-OsBuild')
            foreach ($func in $functions) {
                $command = Get-Command -Name $func -ErrorAction SilentlyContinue
                if ($command) {
                    Write-Log "Function available: $func"
                }
                else {
                    Write-Log "Function missing: $func" -Level WARNING
                }
            }
            
            # Test one function execution
            try {
                $testResult = Get-BiosVersion -ErrorAction Stop
                if ($testResult) {
                    Write-Log "Get-BiosVersion executed successfully"
                }
            }
            catch {
                Write-Log "  Warning: Get-BiosVersion execution test failed: $_" -Level WARNING
            }
            
            # Clean up
            Remove-Module VersionMods -ErrorAction SilentlyContinue
        }
        catch {
            Write-Log "Module import test failed: $_" -Level WARNING
        }
    }
    else {
        Write-Log "Warning: Module not found in Get-Module list" -Level WARNING
    }
    
    # Check if module is accessible
    $modulePath = Join-Path $versionModsPath "VersionMods.psd1"
    if (Test-Path $modulePath) {
        Write-Log "Module manifest verified at: $modulePath"
        
        # Read and display module info
        $manifest = Test-ModuleManifest -Path $modulePath -ErrorAction SilentlyContinue
        if ($manifest) {
            Write-Log "Module Name: $($manifest.Name)"
            Write-Log "Version: $($manifest.Version)"
            Write-Log "Description: $($manifest.Description)"
        }
    }
    
    Write-Log "================================================"
    Write-Log "DEPLOYMENT COMPLETED SUCCESSFULLY"
    Write-Log "================================================"
    Write-Log "Module Location: $versionModsPath"
    Write-Log ""
    Write-Log "Usage Instructions:"
    Write-Log "1. For immediate use: Import-Module VersionMods"
    Write-Log "2. Available functions:"
    Write-Log "   - Get-BiosVersion"
    Write-Log "   - Get-GraphicsVersion"
    Write-Log "   - Get-OsBuild"
    Write-Log "3. Functions will auto-load when called (PowerShell 3.0+)"
    Write-Log "================================================"
    
    # Create deployment marker file
    $markerFile = Join-Path $versionModsPath ".deployed"
    try {
        $deployTime = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
        Set-Content -Path $markerFile -Value "Deployed: $deployTime`r`nScript: $($MyInvocation.MyCommand.Name)`r`nUser: $env:USERNAME`r`nComputer: $env:COMPUTERNAME"
        Write-Log "Deployment marker created: $markerFile"
    }
    catch {
        Write-Log "Note: Could not create deployment marker" -Level WARNING
    }
}
catch {
    Write-Log "Post-deployment verification had non-critical errors: $_" -Level WARNING
}
#endregion

# # Run from the script directory
#.\Deploy-VersionMods.ps1 -Force
#
# Or with explicit zip path
#.\Deploy-VersionMods.ps1 -ModuleZipPath "VersionMods.zip" -Force

pause