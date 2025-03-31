$user = "VM5"
$Pass = ConvertTo-SecureString  "wipro@123" -AsPlainText -Force
$mycredit = New-Object System.Management.Automation.PSCredential ($user , $Pass)
Enter-PSSession -VMName $user -Credential $mycredit 
#Invoke-Command -VMName $user -Credential $mycredit -FilePath C:\Users\fleminp\Documents\Python_Directory\IPco.ps1


