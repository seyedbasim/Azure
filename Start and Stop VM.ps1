Connect-AzAccount -SubscriptionId "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

$vm = Get-AzVM -ResourceGroupName "AD" -Name "hp01-1" -Status
$Status = $vm.Statuses[1].Code.Split("/")[1]

if($Status -eq "deallocated"){
    Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
}else{
    Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
}
