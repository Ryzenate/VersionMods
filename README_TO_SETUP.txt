README.txt

## INSTRUCTIONS FOR PSM1 VERSIONING LIB SETUP AND INSTALL-##
##--------------------------------------------------------##
1. If any of the PS1 files changed, rebuild zip.
   (EX: Make changes to any PS1 file in B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\VersionMods\Public)
2. Run Zip-myMods.ps1
   (EX: "B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Zip-MyMods.ps1")
3. new zip created in deployment directory.
   (EX: DIR: B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\)
   (EX: ZIP: "B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\VersionMods.zip")
4. CD into deployment directory, run Deployment PS1
   (EX: Open Powershell as Admin; CD B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\;
   (EX: .\Deploy-VersionMods.ps1 -Force
5. Verify cmdlets are available to use. List the last imported modules...
   >> $LastMods = (Get-Module | Select-Object -Last 1).ExportedCommands.Key


EXAMPLE OUTPUT (use to verify):

PS B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods> .\Deploy-VersionMods.ps1 -Force
[2026-01-24 21:57:53] [INFO] ================================================
[2026-01-24 21:57:53] [INFO] VersionMods Deployment Script (PS 5.1 Compatible)
[2026-01-24 21:57:53] [INFO] Start Time: 2026-01-24 21:57:53
[2026-01-24 21:57:53] [INFO] ================================================
[2026-01-24 21:57:53] [INFO] Running with Administrator privileges
[2026-01-24 21:57:53] [INFO] Found module ZIP file: B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\VersionMods.zip
True
Press Enter to continue...:
[2026-01-24 21:57:57] [INFO] Removing existing module at: C:\Program Files\WindowsPowerShell\Modules\VersionMods
Press Enter to continue...:
[2026-01-24 21:57:59] [INFO] Creating extraction directory: C:\Users\IONATE~1\AppData\Local\Temp\VersionMods_20260124215759
[2026-01-24 21:57:59] [INFO] Extracting module from: B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\VersionMods.zip
[2026-01-24 21:57:59] [INFO] Verified extracted module structure
[2026-01-24 21:57:59] [INFO] Creating target directory: C:\Program Files\WindowsPowerShell\Modules\VersionMods
[2026-01-24 21:57:59] [INFO] Copying module files to target directory
[2026-01-24 21:57:59] [INFO] Cleaning up temporary files
[2026-01-24 21:57:59] [INFO] Module deployed successfully to: C:\Program Files\WindowsPowerShell\Modules\VersionMods
[2026-01-24 21:57:59] [INFO] Deployed 6 files
[2026-01-24 21:57:59] [INFO] Verifying module installation...
[2026-01-24 21:57:59] [INFO] Refreshing module cache...
[2026-01-24 21:58:01] [INFO] Module registered in PowerShell: 1.0.0.0
[2026-01-24 21:58:01] [INFO] Module imported successfully
[2026-01-24 21:58:01] [INFO] Function available: Get-BiosVersion
[2026-01-24 21:58:01] [INFO] Function available: Get-GraphicsVersion
[2026-01-24 21:58:01] [INFO] Function available: Get-OsBuild
[2026-01-24 21:58:01] [INFO] Get-BiosVersion executed successfully
[2026-01-24 21:58:01] [INFO] Module manifest verified at: C:\Program Files\WindowsPowerShell\Modules\VersionMods\VersionMods.psd1
[2026-01-24 21:58:01] [INFO] Module Name: VersionMods
[2026-01-24 21:58:01] [INFO] Version: 1.0.0.0
[2026-01-24 21:58:01] [INFO] Description: Module for retrieving BIOS, Graphics, and OS version information
[2026-01-24 21:58:01] [INFO] ================================================
[2026-01-24 21:58:01] [INFO] DEPLOYMENT COMPLETED SUCCESSFULLY
[2026-01-24 21:58:01] [INFO] ================================================
[2026-01-24 21:58:01] [INFO] Module Location: C:\Program Files\WindowsPowerShell\Modules\VersionMods
[2026-01-24 21:58:01] [INFO]
[2026-01-24 21:58:01] [INFO] Usage Instructions:
[2026-01-24 21:58:01] [INFO] 1. For immediate use: Import-Module VersionMods
[2026-01-24 21:58:01] [INFO] 2. Available functions:
[2026-01-24 21:58:01] [INFO]    - Get-BiosVersion
[2026-01-24 21:58:01] [INFO]    - Get-GraphicsVersion
[2026-01-24 21:58:01] [INFO]    - Get-OsBuild
[2026-01-24 21:58:01] [INFO] 3. Functions will auto-load when called (PowerShell 3.0+)
[2026-01-24 21:58:01] [INFO] ================================================
[2026-01-24 21:58:01] [INFO] Deployment marker created: C:\Program Files\WindowsPowerShell\Modules\VersionMods\.deployed

PS B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods> Get-BiosVersion


SerialNumber      : B69004CG10405
SMBIOSBIOSVersion : FP7T107
Manufacturer      : American Megatrends International, LLC.
Version           : ALASKA - 1072009
ReleaseDate       : 2024-08-08



PS B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods> Get-GraphicsVersion


Manufacturer   : Advanced Micro Devices, Inc.
Name           : AMD Radeon(TM) Graphics
DriverVersion  : 32.0.21041.1000
VideoProcessor : AMD Radeon Graphics Processor (0x1681)
DriverDate     : 2026-01-07



PS B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods> Get-OsBuild


Caption        : Microsoft Windows 11 Pro
BuildNumber    : 26200
Architecture   : 64-bit
Version        : 10.0.26200
InstallDate    : 2025-07-20
LastBootUpTime : 2026-01-16 23:31:03