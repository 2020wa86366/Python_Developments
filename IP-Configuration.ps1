 Get-NetAdapter "Ethernet" | New-NetIPAddress -IPAddress 10.0.0.20 -AddressFamily IPv4 -DefaultGateway 10.0.0.1 -PrefixLength 24 

 #Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName 10.0.0.20

 Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName 10.0.0.20 | Select-Object -Property [a-z]* -ExcludeProperty IPX*,WINS*

 Set-DnsClientServerAddress -InterfaceIndex -ServerAddresses ("10.0.0.5")
 
 ping 10.0.0.5

 Rename-Computer -NewName "VM5" -Restart

 Add-Computer -DomainName "kanuflemwiprolab.com" -Restart

