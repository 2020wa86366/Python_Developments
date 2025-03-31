Get-Host
Get-Date
Add-PSSnapin Citrix*

$UUID = New-Guid
$catalogName = "WIN1"
$machineName = "KANUFLEMWIPRO\WIN10-T3"
$userAssignement = "KANUFLEMWIPRO\fleminpaulson" 
$borkerName = "kf-cs-v7.kanuflemwiprolab.com:80"

Start-LogHighLevelOperation -AdminAddress $borkerName -Source 'Studio' -Text 'Create Machine Catalog'  
$result = New-BrokerCatalog -AdminAddress $borkerName  -AllocationType 'Permanent' -Description 'Sampletest' -IsRemotePC $False -MachinesArePhysical $True -MinimumFunctionalLevel "L7_9" -Name $catalogName -LoggingId $UUID -PersistUserChanges "OnLocal" -ProvisioningType "Manual" -SessionSupport "SingleSession"
New-BrokerMachine  -CatalogUid $result.Uid  -AdminAddress $borkerName  -LoggingId $UUID -MachineName $machineName 
$result = Get-BrokerCatalog  -AdminAddress $borkerName -Name $catalogName
Stop-LogHighLevelOperation  -AdminAddress $borkerName -IsSuccessful $True -HighLevelOperationId $UUID

$UUID = New-Guid

Start-LogHighLevelOperation  -AdminAddress $borkerName  -Source "Studio" -Text "Create Delivery Group `'KF-WiproLab`'"

Get-BrokerMachine  -AdminAddress $borkerName -Filter {(Uid -eq 2007)} -MaxRecordCount 1

$result = New-BrokerDesktopGroup  -AdminAddress $borkerName  -ColorDepth TwentyFourBit -DeliveryType "DesktopsOnly" -DesktopKind Private -InMaintenanceMode $False -IsRemotePC $False -LoggingId $log.Id -MinimumFunctionalLevel "L7_9" -Name "KF-WiproLab" -OffPeakBufferSizePercent 10 -PeakBufferSizePercent 10 -PublishedName "KF-WiproLab" -Scope @() -SecureIcaRequired $False -SessionSupport SingleSession -ShutdownDesktopsAfterUse $False -TimeZone "Pacific Standard Time"
 

Add-BrokerMachine  -AdminAddress $borkerName -DesktopGroup "KF-WiproLab" -InputObject @(2007) -LoggingId $UUID 

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName  -Name @("KF-WiproLab_Direct")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "NotViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $result.Uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId $UUID -Name "KF-WiproLab_Direct"

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName -Name @("KF-WiproLab_AG")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "ViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $result.Uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedSmartAccessTags @() -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId $UUID -Name "KF-WiproLab_AG"

New-BrokerAssignmentPolicyRule  -AdminAddress $borkerName -Description "" -DesktopGroupUid $result.Uid  -Enabled $True -IncludedUserFilterEnabled $False -IncludedUsers @() -LoggingId $UUID -MaxDesktops 1 -Name "hj_1" -PublishedName "hj"

Stop-LogHighLevelOperation  -AdminAddress $borkerName -HighLevelOperationId $UUID -IsSuccessful $True

#$UUID = New-Guid

#Start-LogHighLevelOperation  -AdminAddress $borkerName  -Source "Studio"  -Text "Edit Delivery Group `'KF-WiproLab`'"

#New-BrokerAssignmentPolicyRule  -AdminAddress $borkerName -Description "" -DesktopGroupUid $result.Uid  -Enabled $True -IncludedUserFilterEnabled $False -IncludedUsers @() -LoggingId $UUID -MaxDesktops 1 -Name "hj_1" -PublishedName "hj"


#Stop-LogHighLevelOperation  -AdminAddress $borkerName -HighLevelOperationId $UUID -IsSuccessful $True
