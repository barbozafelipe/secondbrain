resource "azurerm_managed_redis" "redis" {
  name                      = var.redis_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  sku_name                  = var.sku_name
  high_availability_enabled = var.high_availability_enabled
  tags                      = var.tags

  default_database {
    access_keys_authentication_enabled = lookup(var.default_database_settings, "access_keys_authentication_enabled", true)
    client_protocol                    = lookup(var.default_database_settings, "client_protocol", "Encrypted")
    clustering_policy                  = lookup(var.default_database_settings, "clustering_policy", "OSSCluster")
    eviction_policy                    = lookup(var.default_database_settings, "eviction_policy", "NoEviction")
    geo_replication_group_name         = lookup(var.default_database_settings, "geo_replication_group_name", null)
  }

  identity {
    type         = var.identity.type
    identity_ids = lookup(var.identity, "identity_ids", [])
  }
}