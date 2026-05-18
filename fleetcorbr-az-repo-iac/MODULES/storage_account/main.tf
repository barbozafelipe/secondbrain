resource "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind                     = var.account_kind
  account_replication_type         = var.account_replication_type
  account_tier                     = var.account_tier
  cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
  default_to_oauth_authentication  = var.default_to_oauth_authentication
  public_network_access_enabled    = var.public_network_access_enabled

  dynamic "network_rules" {
    for_each = var.network_rules

    content {
      default_action             = lookup(network_rules.value, "default_action", "Allow")
      ip_rules                   = lookup(network_rules.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", [])
      bypass                     = lookup(network_rules.value, "bypass", ["AzureServices"])
    }
  }

  tags = var.tags
}