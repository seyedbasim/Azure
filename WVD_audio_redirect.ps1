Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

$properties = "audiocapturemode:i:1;camerastoredirect:s:*;audiomode:i:0"

Set-RdsHostPool -TenantName "madushan.onmicrosoft.com" -Name "HNB-Lab-win10" -CustomRdpProperty $properties

