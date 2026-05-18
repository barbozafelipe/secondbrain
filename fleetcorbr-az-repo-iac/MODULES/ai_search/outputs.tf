output "ai_search_name" {
  value = azurerm_search_service.ai_search.name
}

output "ai_search_id" {
  value = azurerm_search_service.ai_search.id
}

output "ai_search_primary_key" {
  value     = azurerm_search_service.ai_search.primary_key
  sensitive = true
}