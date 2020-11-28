#Install-Module -Name Az.DesktopVirtualization

Connect-AzAccount -Tenant '2540d87a-8a0d-43bf-b61d-83bfc5fbd9fd' -Subscription "97279c87-a9d5-490f-bb45-c964f8738ca2"

$rg = "All"
$hp = "hp01"

$users = Get-AzWvdUserSession -HostPoolName $hp -ResourceGroupName $rg

foreach($user in $users){
$split = $user.Id.Split("/")
$Sessionhost = $split[10]
$id = $split[12]
Send-AzWvdUserSessionMessage -ResourceGroupName $rg `
                             -HostPoolName $hp `
                             -UserSessionId $id `
                             -MessageBody 'Desktop will Shutdown in 15 minutes, Please save your files' `
                             -MessageTitle 'Shutdown Alert' `
                             -SessionHostName $Sessionhost
}



