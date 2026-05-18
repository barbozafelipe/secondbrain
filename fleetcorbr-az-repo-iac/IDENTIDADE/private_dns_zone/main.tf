locals {
  private_dns_zones = [
    "privatelink.azurewebsites.net",
    "privatelink.blob.core.windows.net",
    "privatelink.documents.azure.com",
    "privatelink.openai.azure.com",
    "privatelink.search.windows.net",
    "privatelink.redis.cache.windows.net"
  ]
}

module "private_dns_zone" {
  source = "../../MODULES/private_dns_zone"

  count = length(local.private_dns_zones)

  dns_zone_name        = local.private_dns_zones[count.index]
  resource_group_name  = "plt-idt-net-rg"
  registration_enabled = false
  virtual_network_id = [
    data.terraform_remote_state.vnet.outputs.vnet_id,
    data.terraform_remote_state.vnet.outputs.vnet_abastece_id,
    data.terraform_remote_state.vnet-dig-prd.outputs.vnet_id
  ]

  tags = {
    TECNOLOGIA = "PRIVATE_DNS_ZONE"
  }
}