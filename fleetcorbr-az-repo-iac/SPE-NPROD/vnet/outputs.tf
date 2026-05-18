output "subnet_db_id" {
  value = azurerm_subnet.res-4.id
}

output "subnet_plan_01_id" {
  value = azurerm_subnet.res-1.id
}

output "subnet_app_id" {
  value = azurerm_subnet.res-6.id
}

output "subnet_aks_id" {
  value = azurerm_subnet.res-8.id
}

output "vnet_id" {
  value = azurerm_virtual_network.res-0.id
}