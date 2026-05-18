module "cosmosdb" {
  source = "../../MODULES/cosmosdb"

  name                = "stp-dig-cdb-aiagentsapp-prd"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location

  create_private_endpoint               = true
  endpoint_resource_group               = data.azurerm_subnet.snet_db.resource_group_name
  endpoint_subnet_id                    = data.azurerm_subnet.snet_db.id
  private_dns_zone_ids                  = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  public_network_access_enabled         = true
  network_acl_bypass_for_azure_services = true
  ip_range_filter = [
    "54.94.237.166/32",
    "64.215.22.0/24",
    "165.225.214.0/23",
    "147.161.128.0/23",
    "136.226.62.0/23",
    "4.210.172.107",
    "13.88.56.148",
    "13.91.105.215",
    "40.91.218.243",
    "0.0.0.0"
  ]
  virtual_network_rules = []

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
    Projeto = "aiagentsapp"
  }
}