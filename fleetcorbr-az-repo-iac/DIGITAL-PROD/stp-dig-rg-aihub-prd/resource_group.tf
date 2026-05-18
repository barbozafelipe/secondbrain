module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-aihub-prd"
  location            = "brazilsouth"
  tags = {
    Projeto = "AIHUB"
  }
}