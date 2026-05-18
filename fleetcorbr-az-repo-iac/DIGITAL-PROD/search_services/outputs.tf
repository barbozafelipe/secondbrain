output "search_chatbot_id" {
  value = azurerm_search_service.srch-01.id
}

output "search_chatbot_key" {
  value     = azurerm_search_service.srch-01.primary_key
  sensitive = true
}

output "search_copilot_id" {
  value = azurerm_search_service.srch-02.id
}

output "search_copilot_key" {
  value     = azurerm_search_service.srch-02.primary_key
  sensitive = true
}