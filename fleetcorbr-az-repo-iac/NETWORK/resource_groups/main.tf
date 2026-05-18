resource "azurerm_resource_group" "res-2" {
  location = "brazilsouth"
  name     = "plt-net-mon-rg"
}
resource "azurerm_resource_group" "res-1" {
  location = "brazilsouth"
  name     = "plt-net-aut-rg"
}
resource "azurerm_resource_group" "res-0" {
  location = "brazilsouth"
  name     = "plt-net-rg"
}
