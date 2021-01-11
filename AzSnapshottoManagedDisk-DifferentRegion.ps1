#Provide the subscription Id of the subscription where snapshot is created
$subscriptionId = "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

# Set the context to the subscription Id where Snapshot is created
Select-AzSubscription -SubscriptionId $SubscriptionId

Connect-AzAccount -SubscriptionId $SubscriptionId

#Provide the name of your resource group where snapshot is created
$resourceGroupName ="Linux-Bed"

#Provide the snapshot name 
$snapshotName = "snap01osdisk"

#Provide Shared Access Signature (SAS) expiry duration in seconds e.g. 3600.
#Know more about SAS here: https://docs.microsoft.com/en-us/Az.Storage/storage-dotnet-shared-access-signature-part-1
$sasExpiryDuration = "3600"

#Provide storage account name where you want to copy the snapshot. 
$storageAccountName = "vhdtes123"

#Name of the storage container where the downloaded snapshot will be stored
$storageContainerName = "vgds"

#Provide the key of the storage account where you want to copy snapshot. 
$storageAccountKey = 'A8tVARk0AwsUQ9EgYUEk326aC2QFHdD9GISDIh2rtQ2JFaHe2G6KxQsvNpZjA6ls7ZWRqSYy7huEqJX5RV6iTA=='

#Provide the name of the VHD file to which snapshot will be copied.
$destinationVHDFileName = "OSVhd1.vhd"

#Generate the SAS for the snapshot 
$sas = Grant-AzSnapshotAccess -ResourceGroupName $ResourceGroupName -SnapshotName $SnapshotName  -DurationInSecond $sasExpiryDuration -Access Read
#Create the context for the storage account which will be used to copy snapshot to the storage account 
$destinationContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

#Copy the snapshot to the storage account 
$destBlob = Start-AzStorageBlobCopy -AbsoluteUri $sas.AccessSAS -DestContainer $storageContainerName -DestContext $destinationContext -DestBlob $destinationVHDFileName

$destBlob | Get-AzStorageBlobCopyState -WaitForComplete
Get-AzStorageBlobCopyState -Blob "OSVhd.vhd" -Container "vgds" -Context $destinationContext -WaitForComplete
##########Create Managed Disk from SnapShot###############################################

#Provide the subscription Id where Managed Disks will be created
$subscriptionId = "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

#Provide the name of your resource group where Managed Disks will be created. 
$resourceGroupName ='AD'

#Provide the name of the Managed Disk
$diskName = 'OSDisk'

#Provide the size of the disks in GB. It should be greater than the VHD file size.
$diskSize = '200'

#Provide the storage type for Managed Disk. Premium_LRS or Standard_LRS.
$storageType = 'Premium_LRS'

#Provide the Azure region (e.g. westus) where Managed Disk will be located.
#This location should be same as the storage account where VHD file is stored
#Get all the Azure location using command below:
#Get-AzLocation
$location = 'East Asia'

#Provide the URI of the VHD file (page blob) in a storage account. Please not that this is NOT the SAS URI of the storage container where VHD file is stored. 
#e.g. https://contosostorageaccount1.blob.core.windows.net/vhds/contosovhd123.vhd
#Note: VHD file can be deleted as soon as Managed Disk is created.
$sourceVHDURI = 'https://vhdtes123.blob.core.windows.net/vgds/OSVhd'

#Provide the resource Id of the storage account where VHD file is stored.
#e.g. /subscriptions/6472s1g8-h217-446b-b509-314e17e1efb0/resourceGroups/MDDemo/providers/Microsoft.Storage/storageAccounts/contosostorageaccount
#This is an optional parameter if you are creating managed disk in the same subscription
$storageAccountId = '/subscriptions/ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad/resourceGroups/AD/providers/Microsoft.Storage/storageAccounts/vhdtes123'

#Set the context to the subscription Id where Managed Disk will be created
Select-AzSubscription -SubscriptionId $SubscriptionId

$diskConfig = New-AzDiskConfig -AccountType $storageType -Location $location -CreateOption Import -StorageAccountId $storageAccountId -SourceUri $sourceVHDURI

New-AzDisk -Disk $diskConfig -ResourceGroupName $resourceGroupName -DiskName $diskName

