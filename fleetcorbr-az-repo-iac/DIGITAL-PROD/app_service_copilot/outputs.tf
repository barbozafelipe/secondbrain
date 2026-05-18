data "azurerm_network_interface" "nic" {
  name                = azurerm_private_endpoint.pep.network_interface[0].name
  resource_group_name = azurerm_private_endpoint.pep.resource_group_name
}

output "private_ip_address" {
  value = data.azurerm_network_interface.nic.private_ip_address
}