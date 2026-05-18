data "azurerm_resource_group" "rg" {
  name = "stp-dig-net-rg-nprd"
}

resource "azurerm_route_table" "rt-0" {
  name                          = "stp-dig-rt-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  bgp_route_propagation_enabled = false
}

resource "azurerm_route" "route-0" {
  name                   = "rt-fw-dig-nprd"
  resource_group_name    = data.azurerm_resource_group.rg.name
  route_table_name       = azurerm_route_table.rt-0.name
  address_prefix         = "0.0.0.0/0"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"

  depends_on = [
    azurerm_route_table.rt-0,
  ]
}