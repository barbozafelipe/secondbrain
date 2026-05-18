output "subnet_id" {
  description = "Virtual Subnet ID"
  value       = [for snet in azurerm_subnet.snet : snet.id]
}

output "subnets_abastece_id" {
  description = "Virtual Subnet ID"
  value       = [for snet in azurerm_subnet.snet-1 : snet.id]
}


output "vnet_id" {
  value = azurerm_virtual_network.vnet-0.id
}

output "vnet_abastece_id" {
  value = azurerm_virtual_network.vnet-1.id
}