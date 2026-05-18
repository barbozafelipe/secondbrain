data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "spe-spe-kv-nprd" {
  name                          = "spe-spe-kv-nprd"
  location                      = "brazilsouth"
  resource_group_name           = "spe-spe-app-rg-nprd"
  enabled_for_disk_encryption   = true
  public_network_access_enabled = false
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}