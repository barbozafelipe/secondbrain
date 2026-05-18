data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv-01" {
  name                          = "plt-idt-kv-ocp-hml"
  location                      = "brazilsouth"
  resource_group_name           = "plt-idt-kv-rg"
  enabled_for_disk_encryption   = true
  public_network_access_enabled = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
      "List"
    ]

    storage_permissions = [
      "Get",
      "List"
    ]
  }
}