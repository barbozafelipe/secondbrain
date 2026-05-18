data "azurerm_resource_group" "res-0" {
  name = "spe-spe-app-rg-nprd"
}

resource "azurerm_storage_account" "res-102" {
  name                = "spespestgfuncnprd"
  resource_group_name = data.azurerm_resource_group.res-0.name
  location            = data.azurerm_resource_group.res-0.location

  account_kind                     = "Storage"
  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  cross_tenant_replication_enabled = false
  default_to_oauth_authentication  = true
  public_network_access_enabled    = true

  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}

resource "azurerm_storage_container" "res-104" {
  name                 = "azure-webjobs-hosts"
  storage_account_name = azurerm_storage_account.res-102.name

  depends_on = [azurerm_storage_account.res-102]
}

