module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-blogagent-hml-nprd"
  location            = "brazilsouth"
  tags = {
    Projeto = "BLOGAGENT"
  }
}