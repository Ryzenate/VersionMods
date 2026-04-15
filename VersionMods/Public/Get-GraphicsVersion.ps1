function Get-GraphicsVersion {
    <#
    .SYNOPSIS
        Gets graphics card version information
    .DESCRIPTION
        Retrieves graphics adapter driver version and information
    .EXAMPLE
        Get-GraphicsVersion
    #>
    [CmdletBinding()]
    param()
    
    try {
        $graphics = Get-WmiObject -Class Win32_VideoController -ErrorAction Stop | 
                    Where-Object { $null -ne $_.AdapterCompatibility }
        
        $results = @()
        foreach ($adapter in $graphics) {
            $result = New-Object PSObject -Property @{
                Name = $adapter.Name
                Manufacturer = $adapter.AdapterCompatibility
                DriverVersion = $adapter.DriverVersion
                VideoProcessor = $adapter.VideoProcessor
            }
            
            # Handle DriverDate safely
            if ($adapter.DriverDate) {
                try {
                    $driverDate = [Management.ManagementDateTimeConverter]::ToDateTime($adapter.DriverDate)
                    $result | Add-Member -NotePropertyName DriverDate -NotePropertyValue ($driverDate.ToString('yyyy-MM-dd'))
                } catch {
                    $result | Add-Member -NotePropertyName DriverDate -NotePropertyValue 'Unknown'
                }
            } else {
                $result | Add-Member -NotePropertyName DriverDate -NotePropertyValue 'Unknown'
            }
            
            $results += $result
        }
        
        $results
    } catch {
        Write-Error "Failed to retrieve graphics information: $_"
        return $null
    }
}


### FROM MY ORIGINAL FRAMEWORK ###
#function Get-GfxDriverVersion_Fast {
#    $installedDrv = (Get-CimInstance Win32_PnPSignedDriver -Filter "DeviceClass = 'DISPLAY' AND DeviceName LIKE '%AMD%'").DriverVersion
#    return $installedDrv
#}