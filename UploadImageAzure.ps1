Connect-AzAccount

Set-AzContext -SubscriptionId "a2ce3fc4-1e55-410a-b561-ff264ae38bc3"

$disk = Get-AzDisk -ResourceGroupName 'WVD-hostpools' -DiskName 'WVD-sales-cu1_OsDisk_1_16ef0ad64a6e45f6ad4e602a2e8b74d3'

$location = 'Southeast Asia'
$imageName = 'win10multisessionappimg'
$rgName = 'WVD-hostpools'

$imageConfig = New-AzImageConfig `
   -Location $location
$imageConfig = Set-AzImageOsDisk `
   -Image $imageConfig `
   -OsState Generalized `
   -OsType Windows `
   -ManagedDiskId $disk.Id

$image = New-AzImage `
   -ImageName $imageName `
   -ResourceGroupName $rgName `
   -Image $imageConfig

