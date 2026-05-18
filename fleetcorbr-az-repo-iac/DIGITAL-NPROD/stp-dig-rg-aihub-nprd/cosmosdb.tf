module "cosmosdb" {
  source = "../../MODULES/cosmosdb"

  name                = "stp-dig-cdb-aihub-nprd"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location

  create_private_endpoint               = true
  endpoint_resource_group               = "stp-dig-net-rg-nprd"
  endpoint_subnet_id                    = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-nprd/subnets/stp-dig-snet-db-nprd"
  private_dns_zone_ids                  = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  public_network_access_enabled         = true
  network_acl_bypass_for_azure_services = true
  ip_range_filter = [
    "54.94.237.166/32",
    "64.215.22.0/24",
    "165.225.192.0/18",
    "147.161.128.0/17",
    "136.226.0.0/16",
    "4.210.172.107",
    "13.88.56.148",
    "13.91.105.215",
    "40.91.218.243",
    "170.85.0.0/16",
    "0.0.0.0"
  ]
  virtual_network_rules = [
    "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-nprd/subnets/stp-dig-snet-db-nprd"
  ]

  geo_location = {
    brazilsouth = {
      failover_priority = 0
    }
  }

  capabilities = [
    "EnableServerless"
  ]

  consistency_level = {
    level = "Session"
  }

  tags = {
    Projeto = "AIHUB"
  }
}