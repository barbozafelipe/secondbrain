module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-copilot-hml-nprd"
  location            = "brazilsouth"
  tags = {
    Projeto = "Copiloto Atendimento"
  }
}