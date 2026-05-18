output "web_app_id" {
  value = azurerm_linux_web_app.app.id
}

output "web_app_name" {
  value = azurerm_linux_web_app.app.name
}

output "web_app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "web_app_outbound_ip_address_list" {
  value = azurerm_linux_web_app.app.outbound_ip_address_list
}

output "web_app_hostname" {
  value = azurerm_linux_web_app.app.default_hostname
}
