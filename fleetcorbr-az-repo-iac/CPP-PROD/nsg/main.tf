resource "azurerm_network_security_group" "res-1" {
  location            = "brazilsouth"
  name                = "spt-cpp-nsg-prd"
  resource_group_name = "stp-cpp-rg-net-prd"
  depends_on = [
    #azurerm_resource_group.res-0,
  ]
}
resource "azurerm_network_security_rule" "res-2" {
  access                       = "Allow"
  destination_address_prefixes = ["136.226.62.0/23", "147.161.128.0/23", "165.225.214.0/23"]
  destination_port_range       = "3389"
  direction                    = "Inbound"
  name                         = "AllowAnyRDPInbound"
  network_security_group_name  = "spt-cpp-nsg-prd"
  priority                     = 100
  protocol                     = "Tcp"
  resource_group_name          = "stp-cpp-rg-net-prd"
  source_address_prefix        = "*"
  source_port_range            = "*"
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}