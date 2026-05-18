output "application_insights_id" {
  value = azurerm_application_insights.appi.id
}

output "application_insights_app_id" {
  value = azurerm_application_insights.appi.app_id
}

output "application_insights_connection_string" {
  value     = azurerm_application_insights.appi.connection_string
  sensitive = true
}

output "application_insights_instrumentation_key" {
  value     = azurerm_application_insights.appi.instrumentation_key
  sensitive = true
}

