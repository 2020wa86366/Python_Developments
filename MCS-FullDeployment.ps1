Get-Host
Get-Date
Add-PSSnapin Citrix*
$UUID = New-Guid
$catalogName = "CAT10"
$machineName = "KANUFLEMWIPRO\VM5"
$userAssignement = "KANUFLEMWIPRO\fleminpaulson" 
$borkerName = "kf-cs-v7.kanuflemwiprolab.com:80" 
$zone = "be94fd34-81fb-4a48-9c51-86058d7d121d"
$domain = "kanuflemwiprolab.com"
$namingScheme = "CA##"
$namingSchemeType = "Numeric" 

Start-LogHighLevelOperation  -AdminAddress $borkerName -Source "Studio" -Text "Create Machine Catalog `'CAT10`'"

$result = New-BrokerCatalog  -AdminAddress $borkerName -AllocationType "Permanent"  -IsRemotePC $False -LoggingId $UUID -MinimumFunctionalLevel "L7_9" -Name $catalogName -PersistUserChanges "OnLocal" -ProvisioningType "MCS" -Scope @() -SessionSupport "SingleSession" -ZoneUid $zone

$identPool = New-AcctIdentityPool  -AdminAddress $borkerName -AllowUnicode  -Domain $domain  -IdentityPoolName $catalogName -LoggingId $UUID -NamingScheme $namingScheme -NamingSchemeType $namingSchemeType -Scope @() -ZoneUid $zone

Set-BrokerCatalogMetadata  -AdminAddress $borkerName  -CatalogId $result.Uid -LoggingId $UUID -Name "Citrix_DesktopStudio_IdentityPoolUid" -Value "21b8b5be-c7c4-4ebc-8850-aacf3c368bde"

New-HypVMSnapshot  -AdminAddress $borkerName  -LiteralPath "XDHyp:\HostingUnits\KF-Res\KP-VM.vm" -LoggingId $UUID -SnapshotName "Citrix_XD_kpfp-WIN10"

Test-ProvSchemeNameAvailable  -AdminAddress $borkerName  -ProvisioningSchemeName @("CAT10")

New-ProvScheme  -AdminAddress $borkerName  -CustomProperties "<CustomProperties xmlns=`"http://schemas.citrix.com/2014/xd/machinecreation`" xmlns:xsi=`"http://www.w3.org/2001/XMLSchema-instance`"><Property xsi:type=`"StringProperty`" Name=`"UseManagedDisks`" Value=`"true`" /></CustomProperties>" -HostingUnitName "KF-Res" -IdentityPoolName $catalogName -InitialBatchSizeHint 1 -LoggingId $UUID -MasterImageVM "XDHyp:\HostingUnits\KF-Res\KP-VM.vm\Citrix_XD_KP-CATALOG.snapshot\Citrix_XD_KP-CATALOG.snapshot\Citrix_XD_New-catalog.snapshot\Citrix_XD_kpfp-WIN10.snapshot" -NetworkMapping @{"62EEEDA9-7239-4B13-89C4-FEADA34BA0CC"="XDHyp:\HostingUnits\KF-Res\\kanuflemwiprolab.network"} -ProvisioningSchemeName $catalogName -RunAsynchronously -Scope @() -VMCpuCount 4 -VMMemoryMB 2048

Get-ProvTask  -AdminAddress $borkerName  -MaxRecordCount 2147483647 -TaskId "aac95554-ae1c-4f80-b9f2-8dc555ba2ea0"

Remove-ProvTask  -AdminAddress $borkerName  -LoggingId $UUID -TaskId "aac95554-ae1c-4f80-b9f2-8dc555ba2ea0"

Set-BrokerCatalog  -AdminAddress $borkerName  -LoggingId $UUID -Name $catalogName -ProvisioningSchemeId "04405bdb-a1a3-4e55-a819-f2f8c1384c01"

Add-ProvSchemeControllerAddress  -AdminAddress $borkerName  -ControllerAddress @("KF-CS-V7.kanuflemwiprolab.com") -LoggingId $UUID -ProvisioningSchemeName $catalogName

Get-AcctADAccount  -AdminAddress $borkerName  -IdentityPoolUid "21b8b5be-c7c4-4ebc-8850-aacf3c368bde" -Lock $False -MaxRecordCount 2147483647 -State "Available"

New-AcctADAccount  -AdminAddress $borkerName  -Count 1 -IdentityPoolUid "21b8b5be-c7c4-4ebc-8850-aacf3c368bde" -LoggingId $UUID

Get-ProvScheme  -AdminAddress $borkerName  -MaxRecordCount 2147483647 -ProvisioningSchemeName $catalogName

New-ProvVM  -ADAccountName @("KANUFLEMWIPRO\kpfp01$") -AdminAddress $borkerName  -LoggingId $UUID -ProvisioningSchemeName $catalogName -RunAsynchronously

Lock-ProvVM  -AdminAddress $borkerName  -LoggingId $UUID -ProvisioningSchemeName $catalogName -Tag "Brokered" -VMID @("18785319-1fac-4267-940a-9a1d5f77ae36")

New-BrokerMachine  -AdminAddress $borkerName  -CatalogUid 113 -MachineName "S-1-5-21-16900640-1922496190-2964999124-1630"

Remove-ProvTask  -AdminAddress $borkerName  -LoggingId $UUID -TaskId "51cb5821-527e-4992-8d99-c51ace7513e8"

Stop-LogHighLevelOperation  -AdminAddress $borkerName  -EndTime "12/15/2020 2:38:34 PM" -HighLevelOperationId $UUID -IsSuccessful $True
# Script completed successfully




# Create Delivery Group 'kpfp-dg'
# 
# 12/15/2020 6:43 AM
# 
Get-LogSite  -AdminAddress $borkerName 

Start-LogHighLevelOperation  -AdminAddress $borkerName  -Source "Studio" -Text "Create Delivery Group `'kpfp-dg`'"

Get-BrokerMachine  -AdminAddress $borkerName  -Filter {(Uid -eq 2021)} -MaxRecordCount *

New-BrokerDesktopGroup  -AdminAddress $borkerName  -ColorDepth "TwentyFourBit" -DeliveryType "DesktopsOnly" -DesktopKind "Private" -InMaintenanceMode $False -IsRemotePC $False -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -MinimumFunctionalLevel "L7_9" -Name "kpfp-dg" -OffPeakBufferSizePercent 10 -OffPeakDisconnectAction "Nothing" -OffPeakDisconnectTimeout 0 -OffPeakExtendedDisconnectAction "Nothing" -OffPeakExtendedDisconnectTimeout 0 -OffPeakLogOffAction "Nothing" -OffPeakLogOffTimeout 0 -PeakBufferSizePercent 10 -PeakDisconnectAction "Nothing" -PeakDisconnectTimeout 0 -PeakExtendedDisconnectAction "Nothing" -PeakExtendedDisconnectTimeout 0 -PeakLogOffAction "Nothing" -PeakLogOffTimeout 0 -PublishedName "kpfp-dg" -Scope @() -SecureIcaRequired $False -SessionSupport "SingleSession" -ShutdownDesktopsAfterUse $False -TimeZone "Pacific Standard Time"

Add-BrokerMachine  -AdminAddress $borkerName  -DesktopGroup "kpfp-dg" -InputObject @(2021) -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd"

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName  -Name @("kpfp-dg_Direct")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "NotViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True  -DesktopGroupUid 67 -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -Name "kpfp-dg_Direct"

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName  -Name @("kpfp-dg_AG")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "ViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True  -DesktopGroupUid 67 -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedSmartAccessTags @() -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -Name "kpfp-dg_AG"

Test-BrokerPowerTimeSchemeNameAvailable  -AdminAddress $borkerName  -Name @("kpfp-dg_Weekdays")

New-BrokerPowerTimeScheme  -AdminAddress $borkerName  -DaysOfWeek "Weekdays" -DesktopGroupUid 67 -DisplayName "Weekdays" -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -Name "kpfp-dg_Weekdays" -PeakHours @($False,$False,$False,$False,$False,$False,$False,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$False,$False,$False,$False,$False) -PoolSize @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

Test-BrokerPowerTimeSchemeNameAvailable  -AdminAddress $borkerName  -Name @("kpfp-dg_Weekend")

New-BrokerPowerTimeScheme  -AdminAddress $borkerName  -DaysOfWeek "Weekend" -DesktopGroupUid 67 -DisplayName "Weekend" -LoggingId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -Name "kpfp-dg_Weekend" -PeakHours @($False,$False,$False,$False,$False,$False,$False,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$True,$False,$False,$False,$False,$False) -PoolSize @(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)

Stop-LogHighLevelOperation  -AdminAddress $borkerName  -HighLevelOperationId "c43d3d1b-ae7f-4ad1-9637-202bc3d1c2cd" -IsSuccessful $True
# Script completed successfully


