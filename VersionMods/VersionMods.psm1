<#
.SYNOPSIS
    VersionMods PowerShell Module
.DESCRIPTION
    Module for retrieving system version information
.NOTES
    Version: 1.0.0
    Deployment: Automated via Deploy-VersionMods.ps1
#>

# Import all public functions
$PublicPath = Join-Path $PSScriptRoot "Public"
if (Test-Path $PublicPath) {
    $publicFunctions = Get-ChildItem -Path $PublicPath -Filter "*.ps1" -ErrorAction SilentlyContinue
    
    foreach ($function in $publicFunctions) {
        try {
            . $function.FullName
        } catch {
            Write-Warning "Failed to import $($function.Name): $_"
        }
    }
}

# Export module members
if ($MyInvocation.MyCommand.CommandType -eq "Script") {
    Export-ModuleMember -Function * -Alias * -Variable *
} 