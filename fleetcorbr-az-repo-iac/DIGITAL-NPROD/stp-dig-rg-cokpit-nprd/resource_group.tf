module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-rg-cokpit-nprd"
  location            = "brazilsouth"

}