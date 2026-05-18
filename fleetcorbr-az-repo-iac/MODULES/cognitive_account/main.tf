resource "azurerm_cognitive_account" "ai" {
  name                               = var.name
  resource_group_name                = var.resource_group_name
  location                           = var.location
  custom_subdomain_name              = var.custom_subdomain_name != null ? var.custom_subdomain_name : var.name
  kind                               = var.kind
  public_network_access_enabled      = var.public_network_access_enabled
  outbound_network_access_restricted = var.outbound_network_access_restricted
  sku_name                           = var.sku
  tags                               = var.tags

  network_acls {
    default_action = length(var.allowed_ips) > 0 ? "Deny" : "Allow"
    ip_rules       = var.allowed_ips
  }

}

# Private endpoints
resource "azurerm_private_endpoint" "pep" {
  count = var.create_private_endpoint == true ? 1 : 0

  name                          = var.endpoint_name != "" ? var.endpoint_name : var.name
  custom_network_interface_name = var.endpoint_name != "" ? var.endpoint_name : var.name
  resource_group_name           = var.endpoint_resource_group != "" ? var.endpoint_resource_group : var.resource_group_name
  location                      = var.location
  subnet_id                     = var.endpoint_subnet_id
  tags                          = var.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = azurerm_cognitive_account.ai.name
    private_connection_resource_id = azurerm_cognitive_account.ai.id
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

}