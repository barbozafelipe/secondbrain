resource "azurerm_resource_group" "res-2" {
  location = "brazilsouth"
  name     = "plt-idt-mon-rg"
}
resource "azurerm_resource_group" "res-1" {
  location = "brazilsouth"
  name     = "plt-idt-net-rg"
}
resource "azurerm_resource_group" "res-0" {
  location = "brazilsouth"
  name     = "plt-idt-rg"
}
resource "azurerm_resource_group" "res-3" {
  location = "brazilsouth"
  name     = "plt-idt-kv-rg"
}