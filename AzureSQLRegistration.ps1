  Set-AzVMSqlServerExtension -VMName "SQLVM1" `
  -ResourceGroupName "RestoreBackup" -Name "SQLIaasExtension" `
  -Version "2.0" -Location "Southeast Asia";
Get-AzSqlVM

Register-AzResourceProvider -ProviderNamespace Microsoft.SqlVirtualMachine

$vm = Get-AzVM -Name SSBIDevVM1 -ResourceGroupName SSBIDevQARG
New-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -SqlManagementType LightWeight -LicenseType 'PAYG' -Sku Developer -Location "Southeast Asia" -Offer SQL2016-WS2016

Update-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -SqlManagementType LightWeight -LicenseType 'PAYG' -Sku Developer -Offer SQL2016-WS2016

Connect-AzAccount -Tenant "d1f10aba-7a7e-4c41-92ae-10c2c053f6f1" -Subscription "c6a8acbf-ca2b-4fc7-afbe-faa81e84a502"
