module "managed_redis" {
  source = "../../MODULES/managed_redis"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  redis_name          = "stp-dig-redis-aihub-nprd"
  sku_name            = "Balanced_B0"

  tags = {
    Projeto = "AIHUB"
  }
}
