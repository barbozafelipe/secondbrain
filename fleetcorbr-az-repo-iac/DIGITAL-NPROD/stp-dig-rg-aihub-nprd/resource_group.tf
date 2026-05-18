module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-aihub-nprd"
  location            = "brazilsouth"
  tags = {
    Projeto = "AIHUB"
  }
}