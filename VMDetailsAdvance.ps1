
get-vm | select -ExpandProperty networkadapters | select vmname, macaddress, switchname, ipaddresses

Get-VM | `
  ForEach-Object {
    $Report = "" | Select-Object -property Name,NumCpu,MemoryMB,Host,IPAddress
    $Report.Name = $_.Name
    $Report.NumCpu = $_.NumCpu
    $Report.MemoryMB = $_.MemoryMB
    $Report.Host = $_.Host
    $Report.IPAddress = $_.Guest.IPAddress
  Write-Output $Report
  } | Export-Csv "C:\VM.csv"

  Get-VM | Select-Object VMId | Get-VHD | select vhdtype,path,@{label='Size(GB)';expression={$_.filesize/1gb -as [int]}}