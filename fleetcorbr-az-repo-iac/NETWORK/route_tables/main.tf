resource "azurerm_route_table" "res-13" {
  location            = "brazilsouth"
  name                = "plt-net-rt-firewall"
  resource_group_name = "plt-net-rg"
}
resource "azurerm_route" "res-14" {
  address_prefix         = "10.17.130.0/24"
  name                   = "rt-cpp-prd"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "plt-net-rg"
  route_table_name       = "plt-net-rt-firewall"
  depends_on = [
    azurerm_route_table.res-13,
  ]
}
resource "azurerm_route" "res-15" {
  address_prefix         = "10.17.184.0/24"
  name                   = "rt-shared"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "plt-net-rg"
  route_table_name       = "plt-net-rt-firewall"
  depends_on = [
    azurerm_route_table.res-13,
  ]
}

resource "azurerm_route" "res-16" {
  address_prefix         = "10.17.200.0/22"
  name                   = "rt-spe-nprd"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "plt-net-rg"
  route_table_name       = "plt-net-rt-firewall"
  depends_on = [
    azurerm_route_table.res-13,
  ]
}