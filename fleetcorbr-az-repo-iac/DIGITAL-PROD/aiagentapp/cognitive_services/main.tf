locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
}

resource "azurerm_cognitive_account" "oai-01" {
  name                          = "stp-dig-cog-aiagentapp-prd"
  resource_group_name           = local.resource_group_name
  custom_subdomain_name         = "stp-dig-cog-aiagentapp-prd"
  location                      = "eastus2"
  kind                          = "OpenAI"
  public_network_access_enabled = true
  sku_name                      = "S0"


  # network_acls {
  #   default_action = "Deny"
  #   ip_rules = [
  #     "136.226.62.0/23",
  #     "147.161.128.0/23",
  #     "165.225.214.0/23"
  #   ]
  # }

}