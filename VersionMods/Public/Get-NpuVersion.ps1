function Get-NpuVersion {
    try {
        $device = Get-PnpDevice | Where-Object { $_.FriendlyName -like '*Neural*' -or $_.Class -eq 'ComputeAccelerator' } | Select-Object -First 1
        if (-not $device) {
            $result = New-Object PSObject -Property @{
                Version = "NA"
                FinalMessage = "No NPU device detected on this system."
            }
            return $result
        }
        $driver = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceID -eq $device.DeviceID }
        if ($driver) {
            $npuVersion = $driver.DriverVersion
            $result = New-Object PSObject -Property @{
                Version = $npuVersion
                FinalMessage = "NPU driver version retrieved successfully."
            }
            return $result #$driver.DriverVersion
        } else {
            $result = New-Object PSObject -Property @{
                Version = "NA"
                FinalMessage = "NPU device detected but no driver information available."
            }
            return $result
        }
    }
    catch {
        $result = New-Object PSObject -Property @{
            Version = "NA"
            FinalMessage = "An error occurred while retrieving the NPU driver version: $_"
        }
        return $result
    }
}