module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-blogagent-nprd"
  location            = "brazilsouth"
  tags = {
    Projeto = "BLOGAGENT"
  }
}