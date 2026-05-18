resource "azurerm_private_dns_zone" "dns-zone" {
  name                = var.dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "priv-dns-link" {
  count = length(var.virtual_network_id)

  name                  = "network-link-${count.index}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns-zone.name
  registration_enabled  = false
  virtual_network_id    = var.virtual_network_id[count.index]

  depends_on = [
    azurerm_private_dns_zone.dns-zone
  ]
}
