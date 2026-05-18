resource "azurerm_virtual_network_gateway_connection" "res-2" {
  express_route_circuit_id   = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/expressRouteCircuits/plt-net-erc-asct-0641"
  location                   = "brazilsouth"
  name                       = "plt-net-con-erc"
  resource_group_name        = "plt-net-rg"
  type                       = "ExpressRoute"
  virtual_network_gateway_id = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/virtualNetworkGateways/plt-net-snet-vgw"
  depends_on = [
    azurerm_express_route_circuit.res-3,
  ]
}
resource "azurerm_express_route_circuit" "res-3" {
  bandwidth_in_mbps     = 1000
  location              = "brazilsouth"
  name                  = "plt-net-erc-asct-0641"
  peering_location      = "Sao Paulo"
  resource_group_name   = "plt-net-rg"
  service_provider_name = "Ascenty"
  sku {
    family = "MeteredData"
    tier   = "Standard"
  }
}
resource "azurerm_express_route_circuit_peering" "res-4" {
  express_route_circuit_name    = "plt-net-erc-asct-0641"
  peering_type                  = "AzurePrivatePeering"
  primary_peer_address_prefix   = "10.0.128.224/30"
  resource_group_name           = "plt-net-rg"
  secondary_peer_address_prefix = "10.0.128.224/30"
  vlan_id                       = 554
  depends_on = [
    azurerm_express_route_circuit.res-3,
  ]
}
