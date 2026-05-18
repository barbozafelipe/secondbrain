output "redis_name" {
  value = azurerm_managed_redis.redis.name
}

output "redis_id" {
  value = azurerm_managed_redis.redis.id
}

output "redis_endpoint" {
  value = azurerm_managed_redis.redis.hostname
}

