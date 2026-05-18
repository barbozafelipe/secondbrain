variable "admin_password" {
    type = string
    sensitive = true
}
resource "azurerm_postgresql_flexible_server" "stp-dig-pg-aiagentsapp-nprd" {
  name                          = "stp-dig-pg-aiagentsapp-nprd"
  resource_group_name           = module.rg.resource_group_name
  location                      = module.rg.resource_group_location
  version                       = "18"
  delegated_subnet_id           = data.azurerm_subnet.snet_psql.id
  private_dns_zone_id           = module.private_dns_zone.private_dns_id
  public_network_access_enabled = false
  administrator_login           = "psqladmin"
  administrator_password        = var.admin_password
  zone                          = "1"

  storage_mb   = 32768
  storage_tier = "P4"

  sku_name   = "B_Standard_B1ms"
  # depends_on = [azurerm_private_dns_zone_virtual_network_link.example]

}