module "acr" {
  source = "../../MODULES/container_registry"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  name                = "stpdigacraiagentshmlnprd"

}