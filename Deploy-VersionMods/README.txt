Deploy-VersionMods/
├── Deploy-VersionMods.ps1     (Main deployment script)
├── VersionMods.zip            (Compressed module)
└── README.txt                (Optional documentation)

VersionMods/
├── VersionMods.psd1
├── VersionMods.psm1
└── Public/
    ├── Get-BiosVersion.ps1
    ├── Get-GraphicsVersion.ps1
    └── Get-OsBuild.ps1



1) Create the deployment package
--------------------------------
# 1. Create the VersionMods folder with all files
# 2. Create the ZIP file:
	>> Add-Type -AssemblyName System.IO.Compression.FileSystem
	>> [System.IO.Compression.ZipFile]::CreateFromDirectory("VersionMods", "VersionMods.zip")

# 3. Copy Deploy-VersionMods.ps1 to the same directory as the ZIP
# 4. 
# 5. OPTIONAL: Test-VersionModsDeployment.ps1



#########################
### DEPLOYMENT NOTES  ###
#########################

Deploy via Scheduled Task (Run as SYSTEM):
(SAVE THIS AS AN XML FILE):
---------------------------------------------

   <!-- Scheduled Task Action -->
   <Exec>
     <Command>powershell.exe</Command>
     <Arguments>-ExecutionPolicy Bypass -NonInteractive -File "C:\Deploy\Deploy-VersionMods.ps1" -Force</Arguments>
   </Exec>

=========================================================

Deploy via Batch File:

@echo off
REM deploy_versionmods.bat
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -NonInteractive -File "%~dp0Deploy-VersionMods.ps1" -Force
if %errorlevel% equ 0 (
    echo Deployment successful
) else (
    echo Deployment failed with error %errorlevel%
    pause
)

=========================================================

Key PS 5.1 Compatibility Changes:
Replaced Get-CimInstance with Get-WmiObject - CIM cmdlets can be unreliable on older systems
Removed -PassThru parameter from Import-Module in some places
**Used .NET Framework 4.5+ ZIP methods** instead ofCompress-Archive/Expand-Archive`
Simplified object creation using New-Object PSObject -Property
Removed advanced features like ternary operators and null-coalescing operators
Used traditional array addition instead of array operators
Removed dependency on PS 7+ features like $PSVersionTable.PSEdition
Added explicit error handling for WMI date conversions

This solution will work on:
  Windows 7 with PowerShell 5.1
  Windows Server 2008 R2 and later
  Any system with .NET Framework 4.5+ and PowerShell 5.1
  Both 32-bit and 64-bit Windows

=========================================================

=NathanF (Jan 24, 2026)