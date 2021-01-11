Connect-AzAccount -Tenant "2540d87a-8a0d-43bf-b61d-83bfc5fbd9fd" -Subscription "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

#Provide the subscription Id of the subscription where snapshot is created
$subscriptionId = "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

# Set the context to the subscription Id where Snapshot is created
Select-AzSubscription -SubscriptionId $SubscriptionId


$rgName = "AD"  #Already Created
$vnetName = "AD-vnet"  #Already Created
$subnetName = "Subnet01"  #Already Created 
$location = "Southeast Asia"
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

$singleSubnet = Get-AzVirtualNetworkSubnetConfig -VirtualNetwork $vnet -Name $subnetName 

$nsgName = "DC01-nsg"  #Already Created

#$rdpRule = New-AzNetworkSecurityRuleConfig -Name myRdpRule -Description "Allow RDP" `
#    -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
#    -SourceAddressPrefix Internet -SourcePortRange * `
#    -DestinationAddressPrefix * -DestinationPortRange 3389

$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $rgName -Name $nsgName

$ipName = "myIP2" #Create New
$pip = New-AzPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location `
    -AllocationMethod Static

$nicName = "myNicName1" #Create New
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName `
 -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

$vmName = "myDestVM" #Create New
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize "Standard_A2"

$vm = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

$osDiskUri = "https://wvdtest1234.blob.core.windows.net/test/OSVhd2.vhd"
$osDiskName = $vmName + "osDisk"
$vm = Set-AzVMOSDisk -VM $vm -Name $osDiskName -VhdUri $osDiskUri -CreateOption attach -Linux

$dataDiskName = $vmName + "dataDisk"
$vm = Add-AzVMDataDisk -VM $vm -Name $dataDiskName -VhdUri $dataDiskUri -Lun 1 -CreateOption attach

#Create the new VM
New-AzVM -ResourceGroupName $rgName -Location $location -VM $vm



