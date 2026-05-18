module "openai" {
  source = "../../MODULES/cognitive_account"

  name                          = "stp-dig-cog-chatbot-nprd"
  resource_group_name           = module.rg.resource_group_name
  location                      = "eastus"
  kind                          = "OpenAI"
  sku                           = "S0"
  public_network_access_enabled = true
  allowed_ips = [
    "136.226.62.0/23",
    "147.161.128.0/23",
    "165.225.214.0/23"
  ]

  tags = {
    Projeto = "Super Carol"
  }
}

resource "azurerm_private_endpoint" "pep" {
  name                          = "stp-dig-pep-cog-chatbot-nprd"
  resource_group_name           = "stp-dig-net-rg-nprd"
  location                      = "brazilsouth"
  custom_network_interface_name = "stp-dig-nic-cog-chatbot-nprd"
  subnet_id                     = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-nprd/subnets/stp-dig-snet-ai-nprd"
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = module.openai.cognitive_account_name
    private_connection_resource_id = module.openai.cognitive_account_id
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}