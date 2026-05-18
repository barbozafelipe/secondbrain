output "function_app_id" {
  value = azurerm_linux_function_app.func.id
}

output "function_app_name" {
  value = azurerm_linux_function_app.func.name
}

output "function_app_url" {
  value = azurerm_linux_function_app.func.default_hostname
}

output "function_app_outbound_ip_address_list" {
  value = azurerm_linux_function_app.func.outbound_ip_address_list
}

output "function_app_hostname" {
  value = azurerm_linux_function_app.func.default_hostname
}

output "storage_account_name" {
  value = var.create_storage_account == true ? module.storage_account[0].storage_account_name : null
}

output "storage_account_id" {
  value = var.create_storage_account == true ? module.storage_account[0].storage_account_name : null
}