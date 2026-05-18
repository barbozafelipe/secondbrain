data "azurerm_resource_group" "res-0" {
  name = "plt-mon-rg"
}

resource "azurerm_log_analytics_workspace" "res-1" {
  name                = "plt-mon-log"
  location            = data.azurerm_resource_group.res-0.location
  resource_group_name = data.azurerm_resource_group.res-0.name
}