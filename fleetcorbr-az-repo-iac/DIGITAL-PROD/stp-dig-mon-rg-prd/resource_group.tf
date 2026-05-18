module "rg" {
  source = "../../MODULES/resource_groups"

  resource_group_name = "stp-dig-mon-rg-prd"
  location            = "brazilsouth"

}