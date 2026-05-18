data "azurerm_resource_group" "res-0" {
  name = "spe-spe-aks-rg-nprd"
}

resource "azurerm_log_analytics_workspace" "res-1" {
  name                = "spe-spe-log-aks-nprd"
  location            = "brazilsouth"
  resource_group_name = spe-spe-aks-rg-nprd
}