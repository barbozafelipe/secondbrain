resource "azurerm_resource_group" "res-2" {
  location = "brazilsouth"
  name     = "stp-cpp-mon-rg-prd"
}

resource "azurerm_resource_group" "res-1" {
  location = "brazilsouth"
  name     = "stp-cpp-rg-net-prd"
}