resource "azurerm_route_table" "res-11" {
  disable_bgp_route_propagation = true
  location                      = "brazilsouth"
  name                          = "stp-cpp-rt-prd"
  resource_group_name           = "stp-cpp-rg-net-prd"
  depends_on = [
    # azurerm_resource_group.res-0,
  ]
}
resource "azurerm_route" "res-12" {
  address_prefix         = "0.0.0.0/0"
  name                   = "stp-cpp-rt-fw"
  next_hop_in_ip_address = "10.17.128.4"
  next_hop_type          = "VirtualAppliance"
  resource_group_name    = "stp-cpp-rg-net-prd"
  route_table_name       = "stp-cpp-rt-prd"
  depends_on = [
    azurerm_route_table.res-11,
  ]
}