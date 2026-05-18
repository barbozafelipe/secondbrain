resource "azurerm_public_ip" "res-11" {
  allocation_method   = "Static"
  location            = "brazilsouth"
  name                = "plt-net-pip-afw"
  resource_group_name = "plt-net-rg"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}
resource "azurerm_public_ip" "res-12" {
  allocation_method   = "Static"
  location            = "brazilsouth"
  name                = "plt-net-pip-erc"
  resource_group_name = "plt-net-rg"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}
