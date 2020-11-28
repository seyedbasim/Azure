Import-Module Microsoft.Online.SharePoint.PowerShell -DisableNameChecking
Connect-SPOService -Url https://acquestlk-admin.sharepoint.com -credential $credential
$url = "https://acquestlk-my.sharepoint.com/personal/admin_pm_acquest_lk/_layouts/15/onedrive.aspx"
Get-SPODeletedSite -Identity $url

