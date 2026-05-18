output "vnet_id" {
  value = azurerm_virtual_network.res-17.id
}
output "gateway_subnet_id" {
  value = azurerm_subnet.res-19.id
}
output "azure_firewall_subnet_id" {
  value = azurerm_subnet.res-18.id
}
output "virtual_network_gateway_id" {
  value = azurerm_virtual_network_gateway.res-24.id
}