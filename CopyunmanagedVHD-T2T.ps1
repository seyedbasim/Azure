Connect-AzAccount -Tenant "0b2ad702-c4fe-4319-a94f-4c01f321d5e7" -Subscription "5c7c1375-25cc-4b9d-aad7-fdb726e189e1"

#Provide the subscription Id of the subscription where Source Storage Account is created
$subscriptionId = "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"
$subscriptionId = "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

# Set the context to the subscription Id where Source Storage Account is created
Select-AzSubscription -SubscriptionId $SubscriptionId

#******************Source Account Details***************************************************
#Provide the name of the VHD file to which snapshot will be copied.
$SstorageAccountName = "wellnesslivestorage"

$SstorageAccountKey = 'Ln1gCSSSP20UeDCx2EholJLyNG32yS0LW3LUy7aGqm16BSKtQPdGMalUxjCi/tHx8xrm4pA229HrpWmgw+fKVw=='

$SstorageContainerName = "vhds"

$SourceContext = New-AzStorageContext -StorageAccountName $SstorageAccountName -StorageAccountKey $SstorageAccountKey

#******************Desitination Account Details***************************************************

#Provide storage account name where you want to copy the snapshot. 
$DstorageAccountName = "vhddest2021"

#Provide the key of the storage account where you want to copy snapshot. 
$DstorageAccountKey = 'Gg4N8Xftl3IoI3R1r7YFFBRvkwllUwcRoaEJ0J5WWBbdTda1lyCkadJc45REYJVXB3PkYIuPJDDv7e731lomNQ=='

#Name of the storage container where the downloaded snapshot will be stored
$DstorageContainerName = "osdisks"

$destinationContext = New-AzStorageContext -StorageAccountName $DstorageAccountName -StorageAccountKey $DstorageAccountKey

#*************************************************************************************************

#Copy the snapshot to the storage account 
$Copy = Get-AzStorageBlob -Container $SstorageContainerName -Context $SourceContext | Start-AzStorageBlobCopy -DestContainer $DstorageContainerName -DestContext $destinationContext

#Get-AzStorageBlob -Container $DstorageContainerName -Context $destinationContext
$sasurl = "https://wellnesslivestorage.blob.core.windows.net/vhds/wellnessDB-wellnessDB-0819-1.vhd?snapshot=2021-01-05T05:48:59.7460789Z"
#$sasurl = "https://vhdtes123.blob.core.windows.net/test/New%20Text%20Document.txt?sp=r&st=2020-12-22T16:33:03Z&se=2020-12-23T00:33:03Z&spr=https&sv=2019-12-12&sr=b&sig=JNjtm%2B7i3tyy41P00xFCcAOFILOdJu8Wa4%2Fl6%2Fg89iE%3D"
$destinationVHDFileName = "wellnessDB-wellnessDB-0819-1-4.vhd"
#$destinationVHDFileName = "Dest.txt"
$Copy = Start-AzStorageBlobCopy -AbsoluteUri $sasurl -DestContainer $SstorageContainerName -DestContext $SourceContext -DestBlob $destinationVHDFileName

$Copy | Get-AzStorageBlobCopyState -WaitForComplete
#Get-AzStorageBlobCopyState -Blob "DestOSDisk.vhd" -Container "vgds" -Context $destinationContext -WaitForComplete
