resource "azurerm_network_security_group" "res-1" {
  location            = "brazilsouth"
  name                = "nsg-az-vm-shared"
  resource_group_name = "plt-idt-net-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Network Security Group"
  }
}
resource "azurerm_network_security_rule" "res-2" {
  access                      = "Allow"
  destination_address_prefix  = "10.17.184.0/26"
  destination_port_range      = "3389"
  direction                   = "Inbound"
  name                        = "RDP"
  network_security_group_name = "nsg-az-vm-shared"
  priority                    = 1001
  protocol                    = "Tcp"
  resource_group_name         = "plt-idt-net-rg"
  source_address_prefix       = "10.0.183.180/32"
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}
resource "azurerm_network_security_rule" "res-3" {
  access                      = "Allow"
  destination_address_prefix  = "10.17.184.0/26"
  destination_port_range      = "*"
  direction                   = "Inbound"
  name                        = "onpremisse"
  network_security_group_name = "nsg-az-vm-shared"
  priority                    = 1011
  protocol                    = "*"
  resource_group_name         = "plt-idt-net-rg"
  source_address_prefixes     = ["10.0.128.0/17", "192.168.100.0/24"]
  source_port_range           = "*"
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}
