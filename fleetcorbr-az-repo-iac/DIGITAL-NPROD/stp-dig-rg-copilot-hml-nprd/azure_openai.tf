module "openai" {
  source = "../../MODULES/cognitive_account"

  name                          = "stp-dig-cog-copilot-hml-nprd"
  resource_group_name           = module.rg.resource_group_name
  location                      = "eastus"
  kind                          = "OpenAI"
  sku                           = "S0"
  public_network_access_enabled = true
  allowed_ips = [
    "136.226.0.0/16",
    "147.161.128.0/17",
    "165.225.192.0/18"
  ]

  tags = {
    Projeto = "Copiloto Atendimento"
  }
}


