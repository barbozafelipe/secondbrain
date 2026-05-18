output "cognitive_chatbot_id" {
  value = azurerm_cognitive_account.cog-01.id
}

output "cognitive_chatbot_endpoint" {
  value = azurerm_cognitive_account.cog-01.endpoint
}

output "cognitive_chatbot_key" {
  value     = azurerm_cognitive_account.cog-01.primary_access_key
  sensitive = true
}