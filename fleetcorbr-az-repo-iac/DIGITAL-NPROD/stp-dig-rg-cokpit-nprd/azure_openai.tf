module "openai" {
  source = "../../MODULES/cognitive_account"

  name                          = "stp-dig-cog-cokpit-nprd"
  custom_subdomain_name         = "stp-dig-rg-cokpit-nprd"
  resource_group_name           = module.rg.resource_group_name
  location                      = "eastus"
  kind                          = "OpenAI"
  sku                           = "S0"
  public_network_access_enabled = true

  tags = {
    FRENTE = "COKPIT"
  }
}


