resource "azurerm_private_endpoint" "pep" {
  name                          = var.private_endpoint_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  custom_network_interface_name = "${var.private_endpoint_name}-nic"
  subnet_id                     = var.subnet_id

  tags = var.tags

  private_service_connection {
    is_manual_connection           = var.is_manual_connection
    name                           = var.resource_name
    private_connection_resource_id = var.resource_id
    subresource_names              = var.subresource_names
  }

  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_id
  }

}