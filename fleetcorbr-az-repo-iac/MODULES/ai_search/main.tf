resource "azurerm_search_service" "ai_search" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku

  allowed_ips                   = var.public_network_access_enabled == true ? var.allowed_ips : null
  network_rule_bypass_option    = var.network_rule_bypass_option
  public_network_access_enabled = var.public_network_access_enabled

  tags = var.tags
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
    name                           = azurerm_search_service.ai_search.name
    private_connection_resource_id = azurerm_search_service.ai_search.id
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

}