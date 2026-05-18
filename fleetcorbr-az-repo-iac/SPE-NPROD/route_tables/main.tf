resource "azurerm_route_table" "res-0" {
  disable_bgp_route_propagation = true
  location                      = "brazilsouth"
  name                          = "spe-spe-rt-nprd"
  resource_group_name           = "spe-spe-net-rg-nprd"
}
resource "azurerm_route" "res-1" {
  address_prefix         = "0.0.0.0/0"
  name                   = "rt-fw-spe-nprd"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "spe-spe-net-rg-nprd"
  route_table_name       = azurerm_route_table.res-0.name
  depends_on = [
    azurerm_route_table.res-0,
  ]
}
