
Connect-AzAccount -Tenant "b42df2dd-96ef-4ec2-8860-e074ba2d3ff6" -Subscription "ba5a0a9c-3264-4cd1-8576-ed7a3fd8b8ad"

$date = get-date
$dateexpire = $date.AddDays(-30)
$snapshots = Get-AzSnapshot | where TimeCreated -gt $dateexpire 

foreach($snapshot in $snapshots){
#*********************Get Resouce lock information***************************************
   $RL = Get-AzResourceLock -ResourceGroupName $snapshot.ResourceGroupName
   $RLName = $RL.name
   $RLlocklevel = $RL.Properties.level
   $RLrg = $snapshot.ResourceGroupName
#*********************Check for Tags*****************************************************
   if($snapshot.Tags.Get_Item("Delete") -eq "yes"){
        $name = $Snapshot.name
        Write-Host "$name is not removed"
   }else{
#*********************Remove Snapshots***************************************************
        $remove = Remove-AzResourceLock -LockName $RLName -ResourceGroupName $RLrg -Force    
        $name = $Snapshot.name
        Write-Host "$name is removing"
        Remove-AzSnapshot -ResourceGroupName $snapshot.ResourceGroupName -SnapshotName $snapshot.Name -Force;
        $set = Set-AzResourceLock -LockName $RLName -LockLevel $RLlocklevel -ResourceGroupName $RLrg -Force
   }
}


