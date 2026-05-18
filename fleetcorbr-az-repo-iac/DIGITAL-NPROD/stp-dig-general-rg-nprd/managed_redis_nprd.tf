module "managed_redis" {
  source = "../../MODULES/managed_redis"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  redis_name          = "stp-dig-redis-nprd"
  sku_name            = "Balanced_B0"

  tags = {
    environment = "nprd"
  }
}

output "redis_endpoint" {
  value = module.managed_redis.redis_endpoint
}

output "redis_id" {
  value = module.managed_redis.redis_id
}