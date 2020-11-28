#---------------------------------------------------
$credential = Get-Credential
Connect-MsolService -Credential $credential
Connect-AzureAD -Credential $credential
#---------------------------------------------------
$Folder = "C:\AzureADDetails"
if (!(Test-path $Folder -PathType Container)){
    New-Item -ItemType Directory -Force -Path $Folder
}
#---------------------------------------------------
$users = Get-Msoluser -All
$date = Get-Date
$path = "C:\AzureADDetails\UserDetails" + ($date).ToString('yyyy-MM-dd_hh.mm') + ".csv"
Add-Content -Path $path  -Value '"UserPrincipalName","Email","EmployeeID","Licenses"'
$FriendlyNameHash = Get-Content -Raw -Path .\LicenseFriendlyName.txt -ErrorAction Stop | ConvertFrom-StringData

foreach($user in $users){
#*************************************************************************************************************
$alllicenses = $null
$Skus=$user.licenses.accountSKUId
foreach($Sku in $Skus)  #License loop
{
    $LicenseItem= $Sku -Split ":" | Select-Object -Last 1
    $EasyName=$FriendlyNameHash[$LicenseItem]
    $alllicenses = $alllicenses + $EasyName + "|"
}
#*************************************************************************************************************
$email = $null
$ProxyAddress = $user.ProxyAddresses[0]
$email = $ProxyAddress -Split ":" | Select-Object -Last 1
#*************************************************************************************************************
$empID = $null
$AzureAD = Get-AzureADUser -ObjectId $user.UserPrincipalName -ErrorAction SilentlyContinue
$empID = $AzureAD.ExtensionProperty.employeeId
#*************************************************************************************************************
$upn = $null
$upn = $user.UserPrincipalName
#*************************************************************************************************************
 $hash = @{
             "UserPrincipalName" = $upn
             "Email" = $email
             "EmployeeID" = $empID  
             "Licenses" = $alllicenses
             }

   $newRow = New-Object PsObject -Property $hash
   Export-Csv $path -inputobject $newrow -append -Force
}