Import-Module AzureAD
Connect-AzureAD
#Register the Tenant
Install-Module -Name Microsoft.RDInfra.RDPowerShell
Import-Module -Name Microsoft.RDInfra.RDPowerShell

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
New-RdsTenant -Name <TenantName> -AadTenantId <DirectoryID> -AzureSubscriptionId <SubscriptionID>
                                             
New-RdsTenant -Name "WVD-POC"-AadTenantId "2540d87a-8a0d-43bf-b61d-83bfc5fbd9fd" -AzureSubscriptionId "a2ce3fc4-1e55-410a-b561-ff264ae38bc3"
#eg : New-RdsTenant -Name Contoso -AadTenantId 00000000-1111-2222-3333-444444444444 -AzureSubscriptionId 55555555-6666-7777-8888-999999999999

New-RdsRoleAssignment -Tenantname "honelab.onmicrosoft.com" -SignInName "gayan@honelab.onmicrosoft.com" -RoleDefinitionName "RDS Owner"

#Create a service principal in Azure Active Directory

$aadContext = Connect-AzureAD
$svcPrincipal = New-AzureADApplication -AvailableToOtherTenants $true -DisplayName "Windows Virtual Desktop Svc Principal"
$svcPrincipalCreds = New-AzureADApplicationPasswordCredential -ObjectId $svcPrincipal.ObjectId

$svcPrincipalCreds.Value
$aadContext.TenantId.Guid
$svcPrincipal.AppId

#Create a role assignment in Windows Virtual Desktop Preview
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"
Get-RdsTenant

$myTenantName = "honelab.onmicrosoft.com"
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -ApplicationId $svcPrincipal.AppId -TenantName $myTenantName

#Sign in with the service principal
$creds = New-Object System.Management.Automation.PSCredential($svcPrincipal.AppId, (ConvertTo-SecureString $svcPrincipalCreds.Value -AsPlainText -Force))
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com" -Credential $creds -ServicePrincipal -AadTenantId $aadContext.TenantId.Guid

#Create a host pool by using the Azure Marketplace
Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

#Create Remote App
New-RdsAppGroup <tenantname> <hostpoolname> <appgroupname> -ResourceType "RemoteApp"

New-RdsAppGroup "honelab.onmicrosoft.com" "SalesPool-1" "SalesApp-1" -ResourceType "RemoteApp"
Get-RdsStartMenuApp "honelab.onmicrosoft.com" -HostPoolName "SalesPool-1" -AppGroupName "SalesApp-1"

New-RdsRemoteApp -TenantName "honelab.onmicrosoft.com" -HostPoolName "SalesPool-1" -AppGroupName "SalesApp-1" -AppAlias word



#Get-RdsAppGroup <tenantname> <hostpoolname>
Get-RdsAppGroup "honelab.onmicrosoft.com" "WVDpool1"
#Get-RdsStartMenuApp <tenantname> <hostpoolname> <appgroupname>
Get-RdsStartMenuApp "honelab.onmicrosoft.com" "WVDpool1" "AppPool1"
#New-RdsRemoteApp <tenantname> <hostpoolname> <appgroupname> -Name <remoteappname> -AppAlias <appalias>
New-RdsRemoteApp "honelab.onmicrosoft.com" "WVDpool1" "AppPool1" -Name "painttest" -AppAlias "paint"
#New-RdsRemoteApp <tenantname> <hostpoolname> <appgroupname> -Name <remoteappname> -Filepath <filepath> -IconPath <iconpath> -IconIndex <iconindex>
#Get-RdsRemoteApp <tenantname> <hostpoolname> <appgroupname>
Get-RdsRemoteApp "honelab.onmicrosoft.com" "WVDpool1" "AppPool1"
#Publish
#Add-RdsAppGroupUser <tenantname> <hostpoolname> <appgroupname> -UserPrincipalName <userupn>
Add-RdsAppGroupUser "honelab.onmicrosoft.com" "WVDpool1" "AppPool1" -UserPrincipalName "basim@honelab.onmicrosoft.com"

#Create a host pool to validate service updates

#Deploy a management tool

New-RdsHostPool -TenantName "honelab.onmicrosoft.com" -Name "testserver2012r2"
New-RdsRegistrationInfo -TenantName "honelab.onmicrosoft.com" -HostPoolName "testserver2012r2" -ExpirationHours 48






