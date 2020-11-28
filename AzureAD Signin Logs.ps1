
Install-Module AzureAd

Connect-AzureAD -TenantId "63eacdad-1a64-416d-9996-6be79554d18b"

Get-AzureADAuditSignInLogs -All
Install-Module -Name AzureADPreview

Get-module -listavailable

Import-Module AzureADPreview

