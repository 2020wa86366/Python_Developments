$Name = Read-Host -Prompt 'Input VM name'

Get-VM -VMName $Name | Get-VMHardDiskDrive | Out-GridView