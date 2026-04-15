function Get-BiosVersion {
    <#
    .SYNOPSIS
        Gets the BIOS version information
    .DESCRIPTION
        Retrieves BIOS version, manufacturer, and release date from WMI
    .EXAMPLE
        Get-BiosVersion
    .OUTPUTS
        PSObject with BIOS information
    #>
    [CmdletBinding()]
    param()
    
    try {
        $bios = Get-WmiObject -Class Win32_BIOS -ErrorAction Stop
        $result = New-Object PSObject -Property @{
            Manufacturer = $bios.Manufacturer
            Version = $bios.Version
            SerialNumber = $bios.SerialNumber
            SMBIOSBIOSVersion = $bios.SMBIOSBIOSVersion
        }
        
        # Handle ReleaseDate safely
        if ($bios.ReleaseDate) {
            try {
                $releaseDate = [Management.ManagementDateTimeConverter]::ToDateTime($bios.ReleaseDate)
                $result | Add-Member -NotePropertyName ReleaseDate -NotePropertyValue ($releaseDate.ToString('yyyy-MM-dd'))
            } catch {
                $result | Add-Member -NotePropertyName ReleaseDate -NotePropertyValue 'Unknown'
            }
        } else {
            $result | Add-Member -NotePropertyName ReleaseDate -NotePropertyValue 'Unknown'
        }
        
        $result
    } catch {
        Write-Error "Failed to retrieve BIOS information: $_"
        return $null
    }
}