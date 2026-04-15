@{
    ModuleVersion = '1.0.0.0'
    GUID = '4a3b2c1d-5e6f-7a8b-9c0d-1e2f3a4b5c6d'
    Author = 'System Administration'
    CompanyName = 'Your Organization'
    Copyright = '(c) Your Organization. All rights reserved.'
    Description = 'Module for retrieving BIOS, Graphics, and OS version information'
    PowerShellVersion = '5.1'
    DotNetFrameworkVersion = '4.0'
    CLRVersion = '4.0'
    FunctionsToExport = @('Get-BiosVersion', 'Get-GraphicsVersion', 'Get-OsBuild', 'Get-NpuVersion')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @()
    RootModule = 'VersionMods.psm1'
}