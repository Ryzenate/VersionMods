<#
.SYNOPSIS
    Tests if VersionMods module is properly deployed
#>

Write-Host "Testing VersionMods Deployment" -ForegroundColor Cyan
Write-Host "==============================="

# Check module path
$modulePaths = @(
    "$env:ProgramFiles\WindowsPowerShell\Modules\VersionMods",
    "$env:ProgramFiles\PowerShell\Modules\VersionMods"
)

$found = $false
foreach ($path in $modulePaths) {
    if (Test-Path $path) {
        Write-Host "✓ Module found at: $path" -ForegroundColor Green
        $found = $true
        $modulePath = $path
        break
    }
}

if (-not $found) {
    Write-Host "✗ Module not found in standard locations" -ForegroundColor Red
    exit 1
}

# Check required files
$requiredFiles = @('VersionMods.psd1', 'VersionMods.psm1', 'Public\Get-BiosVersion.ps1', 'Public\Get-GraphicsVersion.ps1', 'Public\Get-OsBuild.ps1')
foreach ($file in $requiredFiles) {
    $filePath = Join-Path $modulePath $file
    if (Test-Path $filePath) {
        Write-Host "✓ File exists: $file" -ForegroundColor Green
    } else {
        Write-Host "✗ File missing: $file" -ForegroundColor Red
    }
}

# Test module import
try {
    Import-Module VersionMods -Force -ErrorAction Stop
    Write-Host "✓ Module imports successfully" -ForegroundColor Green
    
    # Test functions
    $functions = @('Get-BiosVersion', 'Get-GraphicsVersion', 'Get-OsBuild')
    foreach ($func in $functions) {
        $cmd = Get-Command $func -ErrorAction SilentlyContinue
        if ($cmd) {
            Write-Host "✓ Function available: $func" -ForegroundColor Green
            
            # Try to execute
            try {
                & $func | Out-Null
                Write-Host "  ✓ Executes without error" -ForegroundColor Green
            } catch {
                Write-Host "  ⚠ Executes with error: $_" -ForegroundColor Yellow
            }
        } else {
            Write-Host "✗ Function missing: $func" -ForegroundColor Red
        }
    }
    
    Remove-Module VersionMods -ErrorAction SilentlyContinue
}
catch {
    Write-Host "✗ Module import failed: $_" -ForegroundColor Red
}

Write-Host "`nTest completed" -ForegroundColor Cyan
pause