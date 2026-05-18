output "cosmosdb_id" {
  value = azurerm_cosmosdb_account.db.id
}

output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.db.endpoint
}

output "cosmosdb_name" {
  value = azurerm_cosmosdb_account.db.name
}

output "cosmosdb_primary_key" {
  value     = azurerm_cosmosdb_account.db.primary_key
  sensitive = true
}
