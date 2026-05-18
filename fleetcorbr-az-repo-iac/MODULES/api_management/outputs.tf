output "api_management_id" {
  value = azurerm_api_management.apim.id
}

output "api_management_endpoint" {
  value = azurerm_api_management.apim.gateway_url
}