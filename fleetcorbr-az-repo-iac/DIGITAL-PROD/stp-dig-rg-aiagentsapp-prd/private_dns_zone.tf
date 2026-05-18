module "private_dns_zone" {
  source = "../../MODULES/private_dns_zone"
  dns_zone_name        = "stp-dig-aiagentsapp-prd.postgres.database.azure.com"
  resource_group_name  = module.rg.resource_group_name
  registration_enabled = false
  virtual_network_id = [
    data.azurerm_virtual_network.vnet.id
  ]

  tags = {
    TECNOLOGIA = "PRIVATE_DNS_ZONE"
  }
}