output "storage_account_name" {
  value = azurerm_storage_account.res-102.name
}

output "storage_account_key" {
  value     = azurerm_storage_account.res-102.primary_access_key
  sensitive = true
}

output "storage_account_id" {
  value = azurerm_storage_account.res-102.id
}
