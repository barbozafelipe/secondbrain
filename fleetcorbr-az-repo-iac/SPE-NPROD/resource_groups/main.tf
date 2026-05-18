resource "azurerm_resource_group" "res-0" {
  location = "brazilsouth"
  name     = "spe-spe-net-rg-nprd"
}
resource "azurerm_resource_group" "res-1" {
  location = "brazilsouth"
  name     = "spe-spe-app-rg-nprd"
}
resource "azurerm_resource_group" "res-2" {
  location = "brazilsouth"
  name     = "spe-spe-db-rg-nprd"
}
resource "azurerm_resource_group" "res-3" {
  location = "brazilsouth"
  name     = "spe-spe-plan-01-rg-nprd"
}
resource "azurerm_resource_group" "res-4" {
  location = "brazilsouth"
  name     = "spe-spe-mon-rg-nprd"
}
resource "azurerm_resource_group" "res-5" {
  location = "brazilsouth"
  name     = "spe-spe-aks-rg-nprd"
}