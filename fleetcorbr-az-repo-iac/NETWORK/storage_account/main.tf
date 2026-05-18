resource "azurerm_storage_account" "res-26" {
  account_replication_type         = "LRS"
  account_tier                     = "Standard"
  allow_nested_items_to_be_public  = false
  location                         = "brazilsouth"
  name                             = "pltnetst"
  resource_group_name              = "plt-net-rg"
  cross_tenant_replication_enabled = false
  tags = {
    ms-resource-usage = "azure-cloud-shell"
  }
}
resource "azurerm_storage_share" "res-27" {
  name                 = "pltnetshare"
  quota                = 6
  storage_account_name = "pltnetst"
}
