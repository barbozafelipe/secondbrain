output "api_management_id" {
  value = azurerm_api_management.res-1.id
}
output "apim_subscription_key" {
  value     = azurerm_api_management_subscription.res-56.primary_key
  sensitive = true
}