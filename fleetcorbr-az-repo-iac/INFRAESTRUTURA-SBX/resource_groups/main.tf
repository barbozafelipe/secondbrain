resource "azurerm_resource_group" "rg-01" {
  location = "brazilsouth"
  name     = "sbx-inf-net-rg"
}
resource "azurerm_resource_group" "rg-02" {
  location = "brazilsouth"
  name     = "sbx-inf-aks-rg"
}
