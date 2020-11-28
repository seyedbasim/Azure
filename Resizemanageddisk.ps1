#Resizing Managed Disk

Connect-AzAccount
Select-AzSubscription –SubscriptionName 'Microsoft Azure Sponsorship'
$rgName = 'hyprvasr'
$vmName = 'RDS'

$vm = Get-AzVM -ResourceGroupName $rgName -Name $vmName

Stop-AzVM -ResourceGroupName $rgName -Name $vmName

$disk= Get-AzDisk -ResourceGroupName $rgName -DiskName $vm.StorageProfile.OsDisk.Name
$disk.DiskSizeGB = 64
Update-AzDisk -ResourceGroupName $rgName -Disk $disk -DiskName $disk.Name

Start-AzVM -ResourceGroupName $rgName -Name $vmName
