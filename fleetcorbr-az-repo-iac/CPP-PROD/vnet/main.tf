resource "azurerm_virtual_network" "res-13" {
  address_space       = ["10.17.130.0/24"]
  location            = "brazilsouth"
  name                = "stp-cpp-vnet-prd"
  resource_group_name = "stp-cpp-rg-net-prd"
  depends_on = [
    # azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-14" {
  address_prefixes     = ["10.17.130.0/27"]
  name                 = "stp-cpp-snet-1-prd"
  resource_group_name  = "stp-cpp-rg-net-prd"
  service_endpoints    = ["Microsoft.Storage"]
  virtual_network_name = "stp-cpp-vnet-prd"
  depends_on = [
    azurerm_virtual_network.res-13,
  ]
}
resource "azurerm_subnet_route_table_association" "res-15" {
  route_table_id = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/routeTables/stp-cpp-rt-prd"
  subnet_id      = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-cpp-vnet-prd/subnets/stp-cpp-snet-1-prd"
  depends_on = [
    # azurerm_route_table.res-11,
    azurerm_subnet.res-14,
  ]
}
resource "azurerm_virtual_network_peering" "res-16" {
  allow_forwarded_traffic   = true
  name                      = "stp-cpp-peer-prd"
  remote_virtual_network_id = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/virtualNetworks/plt-net-vnet"
  resource_group_name       = "stp-cpp-rg-net-prd"
  use_remote_gateways       = true
  virtual_network_name      = "stp-cpp-vnet-prd"
  depends_on = [
    azurerm_virtual_network.res-13,
  ]
}
