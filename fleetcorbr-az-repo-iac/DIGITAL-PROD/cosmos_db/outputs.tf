output "cosmosdb_key" {
  value     = azurerm_cosmosdb_account.res-76.primary_key
  sensitive = true
}

output "cosmosdb_chatbot_key" {
  value     = azurerm_cosmosdb_account.cdb-01.primary_key
  sensitive = true
}

output "cosmosdb_chatbot_id" {
  value = azurerm_cosmosdb_account.cdb-01.id
}

output "cosmosdb_chatbot_connection_string" {
  value     = azurerm_cosmosdb_account.cdb-01.primary_sql_connection_string
  sensitive = true
}

# Copiloto
output "cosmosdb_copilot_key" {
  value     = azurerm_cosmosdb_account.cdb-04.primary_key
  sensitive = true
}

output "cosmosdb_copilot_id" {
  value = azurerm_cosmosdb_account.cdb-04.id
}

output "cosmosdb_copilot_connection_string" {
  value     = azurerm_cosmosdb_account.cdb-04.primary_sql_connection_string
  sensitive = true
}

output "cosmosdb_copilot_endpoint" {
  value = azurerm_cosmosdb_account.cdb-04.endpoint
}