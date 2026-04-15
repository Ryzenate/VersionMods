function Get-OsBuild {
    <#
    .SYNOPSIS
        Gets OS build information
    .DESCRIPTION
        Retrieves Windows OS version, build number, and architecture
    .EXAMPLE
        Get-OsBuild
    #>
    [CmdletBinding()]
    param()
    try {
        $os = Get-WmiObject -Class Win32_OperatingSystem -ErrorAction Stop
        $result = New-Object PSObject -Property @{
            Caption = $os.Caption
            Version = $os.Version
            BuildNumber = $os.BuildNumber
            Architecture = if ([System.IntPtr]::Size -eq 8) { '64-bit' } else { '32-bit' }
        }
        # Handle InstallDate safely
        if ($os.InstallDate) {
            try {
                $installDate = [Management.ManagementDateTimeConverter]::ToDateTime($os.InstallDate)
                $result | Add-Member -NotePropertyName InstallDate -NotePropertyValue ($installDate.ToString('yyyy-MM-dd'))
            } catch {
                $result | Add-Member -NotePropertyName InstallDate -NotePropertyValue 'Unknown'
            }
        } else {
            $result | Add-Member -NotePropertyName InstallDate -NotePropertyValue 'Unknown'
        }
        # Handle LastBootUpTime safely
        if ($os.LastBootUpTime) {
            try {
                $bootTime = [Management.ManagementDateTimeConverter]::ToDateTime($os.LastBootUpTime)
                $result | Add-Member -NotePropertyName LastBootUpTime -NotePropertyValue ($bootTime.ToString('yyyy-MM-dd HH:mm:ss'))
            } catch {
                $result | Add-Member -NotePropertyName LastBootUpTime -NotePropertyValue 'Unknown'
            }
        } else {
            $result | Add-Member -NotePropertyName LastBootUpTime -NotePropertyValue 'Unknown'
        }
        
        $result
    } catch {
        Write-Error "Failed to retrieve OS information: $_"
        return $null
    }
}