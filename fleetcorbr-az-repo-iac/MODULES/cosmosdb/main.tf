resource "azurerm_cosmosdb_account" "db" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind
  free_tier_enabled   = var.free_tier_enabled
  tags                = var.tags

  automatic_failover_enabled            = var.automatic_failover_enabled
  minimal_tls_version                   = var.minimal_tls_version
  multiple_write_locations_enabled      = var.multiple_write_locations_enabled
  ip_range_filter                       = var.ip_range_filter
  network_acl_bypass_for_azure_services = var.network_acl_bypass_for_azure_services
  public_network_access_enabled         = var.public_network_access_enabled
  is_virtual_network_filter_enabled     = length(var.virtual_network_rules) > 0 ? true : false

  dynamic "virtual_network_rule" {
    for_each = toset(var.virtual_network_rules != null ? var.virtual_network_rules : [])

    content {
      id                                   = virtual_network_rule.key
      ignore_missing_vnet_service_endpoint = false
    }

  }

  consistency_policy {
    consistency_level       = var.consistency_level.level
    max_interval_in_seconds = var.consistency_level.max_interval_in_seconds
    max_staleness_prefix    = var.consistency_level.max_staleness_prefix
  }

  dynamic "capabilities" {
    for_each = toset(var.capabilities != null ? var.capabilities : [])
    content {
      name = capabilities.key
    }
  }

  dynamic "geo_location" {
    for_each = var.geo_location != null ? var.geo_location : {}

    content {
      location          = geo_location.key
      failover_priority = geo_location.value.failover_priority
    }
  }

}

resource "azurerm_private_endpoint" "pep" {
  count = var.create_private_endpoint == true ? 1 : 0

  name                          = var.name
  custom_network_interface_name = var.name
  resource_group_name           = var.endpoint_resource_group != "" ? var.endpoint_resource_group : var.resource_group_name
  location                      = var.location
  subnet_id                     = var.endpoint_subnet_id
  tags                          = var.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = azurerm_cosmosdb_account.db.name
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    subresource_names              = var.subresource_names
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

}