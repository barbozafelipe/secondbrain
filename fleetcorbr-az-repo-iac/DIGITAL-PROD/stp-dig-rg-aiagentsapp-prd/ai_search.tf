module "ai_search" {
  source = "../../MODULES/ai_search"

  name                = "stp-dig-srch-aiagentsapp-prd"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  sku                 = "basic"

  create_private_endpoint       = true
  endpoint_resource_group       = data.azurerm_subnet.snet_ai.resource_group_name
  endpoint_subnet_id            = data.azurerm_subnet.snet_ai.id
  private_dns_zone_ids          = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  public_network_access_enabled = true
  allowed_ips = [
    "40.124.115.40/32",
    "136.226.0.0/16",
    "147.161.128.0/17",
    "165.225.192.0/18",
    "170.85.0.0/16",
  ]

  tags = {
    Projeto = "AIHUB"
  }
}