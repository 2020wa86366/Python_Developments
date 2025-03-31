Get-Host
Get-Date
Add-PSSnapin Citrix*

$UUID = New-Guid
$catalogName = "WIN1"
$machineName = "KANUFLEMWIPRO\WIN10-T3"
$userAssignement = "KANUFLEMWIPRO\fleminpaulson" 
$borkerName = "kf-cs-v7.kanuflemwiprolab.com:80"


Start-LogHighLevelOperation  -AdminAddress $borkerName  -Source "Studio" -Text "Create Delivery Group `'kfooh`'"

Get-BrokerMachine  -AdminAddress $borkerName -Filter {(Uid -eq 2021)} -MaxRecordCount *

$result = New-BrokerDesktopGroup  -AdminAddress $borkerName  -ColorDepth TwentyFourBit -DeliveryType "DesktopsOnly" -DesktopKind Private -InMaintenanceMode $False -IsRemotePC $False -LoggingId $log.Id -MinimumFunctionalLevel "L7_9" -Name "kfooh" -OffPeakBufferSizePercent 10 -PeakBufferSizePercent 10 -PublishedName "kfooh" -Scope @() -SecureIcaRequired $False -SessionSupport SingleSession -ShutdownDesktopsAfterUse $False -TimeZone "Pacific Standard Time"
 

Add-BrokerMachine  -AdminAddress $borkerName -DesktopGroup "kfooh" -InputObject @(2021) -LoggingId $UUID 

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName  -Name @("kfooh_Direct")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "NotViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $result.Uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId $UUID -Name "kfooh_Direct"

Test-BrokerAccessPolicyRuleNameAvailable  -AdminAddress $borkerName -Name @("kfooh_AG")

New-BrokerAccessPolicyRule  -AdminAddress $borkerName -AllowedConnections "ViaAG" -AllowedProtocols @("HDX","RDP") -AllowedUsers "AnyAuthenticated" -AllowRestart $True -DesktopGroupUid $result.Uid -Enabled $True -IncludedSmartAccessFilterEnabled $True -IncludedSmartAccessTags @() -IncludedUserFilterEnabled $True -IncludedUsers @() -LoggingId $UUID -Name "kfooh_AG"

New-BrokerAssignmentPolicyRule  -AdminAddress $borkerName -Description "" -DesktopGroupUid $result.Uid  -Enabled $True -IncludedUserFilterEnabled $False -IncludedUsers @() -LoggingId $UUID -MaxDesktops 1 -Name "kl_1" -PublishedName "kl"

Stop-LogHighLevelOperation  -AdminAddress $borkerName -HighLevelOperationId $UUID -IsSuccessful $True
