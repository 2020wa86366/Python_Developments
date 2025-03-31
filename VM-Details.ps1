foreach($vm in Get-VM) { $vmDetail=Get-VMProcessor $vm.Name; $memInMB=$vm.MemoryAssigned/1024/1024; Write-Host -NoNewline $vm.Name, $memInMB, $vmDetail.Count; Write-Host }
Get-VM | Select-Object *