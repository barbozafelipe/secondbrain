output "cognitive_account_id" {
  value = azurerm_cognitive_account.ai.id
}

output "cognitive_account_name" {
  value = azurerm_cognitive_account.ai.name
}

output "cognitive_account_endpoint" {
  value = azurerm_cognitive_account.ai.endpoint
}

output "cognitive_account_key" {
  value     = azurerm_cognitive_account.ai.primary_access_key
  sensitive = true
}
