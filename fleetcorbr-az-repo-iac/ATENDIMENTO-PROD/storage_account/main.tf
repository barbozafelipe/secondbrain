resource "azurerm_storage_account" "st-01" {
  name                = "stpatdst01prd"
  resource_group_name = "stp-atd-rg-prd"
  location            = "brazilsouth"

  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  account_kind                     = "StorageV2"
  cross_tenant_replication_enabled = false
  public_network_access_enabled    = true

  tags = {}
}

resource "azurerm_storage_container" "blob-01" {
  name                 = "images-beedoo"
  storage_account_name = azurerm_storage_account.st-01.name
}
