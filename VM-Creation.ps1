#VM Name
$VMName          = "VM5"
 
# Automatic Start Action (Nothing = 0, Start =1, StartifRunning = 2)
$AutoStartAction = 1
# In second
$AutoStartDelay  = 10
# Automatic Start Action (TurnOff = 0, Save =1, Shutdown = 2)
$AutoStopAction  = 2
 
 
###### Hardware Configuration ######
# VM Path
$VMPath         = "C:\VM"
 
# VM Generation (1 or 2)
$Gen            = 2
 
# Processor Number
$ProcessorCount = 4
 
## Memory (Static = 0 or Dynamic = 1)
$Memory         = 1
# StaticMemory
$StaticMemory   = 8GB
 
# DynamicMemory
$StartupMemory  = 2GB
$MinMemory      = 1GB
$MaxMemory      = 4GB
 
# Sysprep VHD path (The VHD will be copied to the VM folder)
$SysVHDPath     = "C:\VM\WIN10-02\Virtual Hard Disks\Syspre-Win10.vhdx"
# Rename the VHD copied in VM folder to:
$OsDiskName     = $VMName

#Switch Details
$VMSwitchName = "Dev Network"
$VlanId       = 0
$VMQ          = $False
$IPSecOffload = $False
$SRIOV        = $False
$MacSpoofing  = $False
$DHCPGuard    = $False
$RouterGuard  = $False
$NicTeaming   = $False

 
## Creation of the VM
# Creation without VHD and with a default memory value (will be changed after)
New-VM -Name $VMName `
       -Path $VMPath `
       -NoVHD `
       -Generation $Gen `
       -MemoryStartupBytes 2GB `
       -SwitchName $VMSwitchName
 
 
if ($AutoStartAction -eq 0){$StartAction = "Nothing"}
Elseif ($AutoStartAction -eq 1){$StartAction = "Start"}
Else{$StartAction = "StartIfRunning"}
 
if ($AutoStopAction -eq 0){$StopAction = "TurnOff"}
Elseif ($AutoStopAction -eq 1){$StopAction = "Save"}
Else{$StopAction = "Shutdown"}
 
 # If Static Memory
if (!$Memory){
    
    Set-VM -Name $VMName `
           -ProcessorCount $ProcessorCount `
           -StaticMemory `
           -MemoryStartupBytes $StaticMemory `
           -AutomaticStartAction $StartAction `
           -AutomaticStartDelay $AutoStartDelay `
           -AutomaticStopAction $StopAction
 
 
}
# If Dynamic Memory
Else{
    Set-VM -Name $VMName `
           -ProcessorCount $ProcessorCount `
           -DynamicMemory `
           -MemoryMinimumBytes $MinMemory `
           -MemoryStartupBytes $StartupMemory `
           -MemoryMaximumBytes $MaxMemory `
           -AutomaticStartAction $StartAction `
           -AutomaticStartDelay $AutoStartDelay `
           -AutomaticStopAction $StopAction
 
}

#VHDX Creation
$OsDiskInfo = Get-Item $SysVHDPath
Copy-Item -Path $SysVHDPath -Destination $($VMPath + "\" + $VMName)
Rename-Item -Path $($VMPath + "\" + $VMName + "\" + $OsDiskInfo.Name) -NewName $($OsDiskName + $OsDiskInfo.Extension)
 
# Attach the VHD(x) to the VM
Add-VMHardDiskDrive -VMName $VMName -Path $($VMPath + "\" + $VMName + "\" + $OsDiskName + $OsDiskInfo.Extension)
 
$OsVirtualDrive = Get-VMHardDiskDrive -VMName $VMName -ControllerNumber 0
     
# Change the boot order to the VHDX first
Set-VMFirmware -VMName $VMName -FirstBootDevice $OsVirtualDrive

