$vmName = 'myVM'
$location = 'Southeast Asia' 
$osDiskName = 'myOsDisk'
$destinationResourceGroup = "REST"

$snapshot = Get-AzSnapshot -ResourceGroupName "REST" -SnapshotName "Linux_key"

$osDisk = New-AzDisk -DiskName $osDiskName -Disk `
    (New-AzDiskConfig  -Location $location -CreateOption Copy `
	-SourceResourceId $snapshot.Id) `
    -ResourceGroupName $destinationResourceGroup

$datadisk1 = 
$datadisk2 = 
$datadisk3 = 

$vnet = Get-AzVirtualNetwork -Name "MABStest-vnet" -ResourceGroupName "MABStest"
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name "default" -VirtualNetwork $vnet

$nicName = "myNicName"
$nic = New-AzNetworkInterface -Name $nicName `
   -ResourceGroupName $destinationResourceGroup `
   -Location $location -SubnetId $Subnet.Id


$vmName = "myVM"
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_B2s"

Standard E8s v3 (8 vcpus, 64 GiB memory)

$vm = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id
Set-AzVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType Standard_LRS `
    -DiskSizeInGB 128 -CreateOption Attach -Linux

$vm = Set-AzVMDataDisk -Caching ReadOnly -Lun 0 -VM $vm -ManagedDiskId $datadisk1.Id -StorageAccountType Standard_LRS `
    -DiskSizeInGB 256 -CreateOption Attach

$vm = Set-AzVMOSDisk -VM $vm -ManagedDiskId $osDisk.Id -StorageAccountType Standard_LRS `
    -DiskSizeInGB 128 -CreateOption Attach -Linux

New-AzVM -ResourceGroupName $destinationResourceGroup -Location $location -VM $vm

C:\Test\Linux_key.pem
ssh -i C:\Test\Linux_key.pem azureuser@52.230.52.89
