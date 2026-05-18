resource "azurerm_route_table" "res-4" {
  disable_bgp_route_propagation = true
  location                      = "brazilsouth"
  name                          = "plt-shared-rt"
  resource_group_name           = "plt-idt-net-rg"
}
resource "azurerm_route" "res-5" {
  address_prefix         = "0.0.0.0/0"
  name                   = "rt-fw-shared"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "plt-idt-net-rg"
  route_table_name       = azurerm_route_table.res-4.name
  depends_on = [
    azurerm_route_table.res-4,
  ]
}
