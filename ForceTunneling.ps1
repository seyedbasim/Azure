Connect-AzAccount -Tenant "6c603d40-8fdf-4d5e-96dd-bea1cc978a72" -Subscription "e0c39d71-ad77-48bc-b850-fe779b7cb552"

#routetable next hop for default route to VPN
#Associate to VNet

$localgw = Get-AzLocalNetworkGateway -ResourceGroupName "NTBWVDNetwork"
$azvirtualgw = Get-AzVirtualNetworkGateway -ResourceGroupName "NTBWVDNetwork"
Set-AzVirtualNetworkGatewayDefaultSite -GatewayDefaultSite $localgw -VirtualNetworkGateway $azvirtualgw

get-AzVirtualNetworkGatewayDefaultSite
Get-AzVirtualNetworkGatewayConnection -ResourceGroupName "NTBWVDNetwork"
#Edit

