output "storage_account_name" {
  value = module.storage_account.storage_account_name
}

output "storage_account_key" {
  value     = module.storage_account.storage_account_key
  sensitive = true
}

output "storage_account_primary_blob_endpoint" {
  value = module.storage_account.primary_blob_endpoint
}