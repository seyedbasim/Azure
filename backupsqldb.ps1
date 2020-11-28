$server = "asazure://southeastasia.asazure.windows.net/cbltest"
$Database = "adventureworks"
$BackupFolder = "C:\DB\"
$date = Get-Date -Format MM-dd-yyyy
$Filepath = "$($BackupFolder)$($Database)_db_$($date).bak"

$creds = Get-Credential
Backup-ASDatabase -name "dada" -backupfile "test.abf" -Server $server -Credential $creds

Backup-SqlDatabase

