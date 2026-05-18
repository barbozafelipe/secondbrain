module "openai" {
  source = "../../MODULES/cognitive_account"

  name                          = "stp-dig-cog-automacaovendas-prd"
  resource_group_name           = module.rg.resource_group_name
  location                      = "eastus"
  kind                          = "OpenAI"
  sku                           = "S0"
  public_network_access_enabled = true

  tags = {
    AMBIENTE = "PRD"
  }
}