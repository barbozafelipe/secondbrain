module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-automacaovendas-prd"
  location            = "brazilsouth"

  tags = {
    AMBIENTE = "PRD"
  }
}