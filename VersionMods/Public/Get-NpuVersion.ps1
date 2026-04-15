function Get-NpuVersion {
    try {
        $device = Get-PnpDevice | Where-Object { $_.FriendlyName -like '*Neural*' -or $_.Class -eq 'ComputeAccelerator' } | Select-Object -First 1
        if (-not $device) {
            Write-Log "No NPU device found."
            return 'NA'
        }
        $driver = Get-WmiObject Win32_PnPSignedDriver | Where-Object { $_.DeviceID -eq $device.DeviceID }
        if ($driver) {
            return $driver.DriverVersion
        } else {
            Write-Log "No driver found for the NPU device."
            return 'NA'
        }
    }
    catch { 
        Write-Log "An error occurred while getting the NPU driver version: $_"
        return 'NA' 
    }
}