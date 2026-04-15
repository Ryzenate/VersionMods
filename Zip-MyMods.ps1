# PowerShell 5.1 compatible ZIP creation
$sourceFolder = "B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\VersionMods" #"VersionMods"
$zipFile = "B:\src_b\Work_AMD\PSM1_TEST\Solution2_DeepSeek\Deploy-VersionMods\VersionMods.zip"

# Remove existing zip if it exists
if (Test-Path $zipFile) {
    Remove-Item $zipFile -Force
}

# Use .NET Framework 4.5+ for compression (available in PS 5.1)
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Create ZIP file
[System.IO.Compression.ZipFile]::CreateFromDirectory($sourceFolder, $zipFile)

Write-Host "Created $zipFile successfully"
pAUSE