data "azurerm_virtual_network" "vnet" {
  name                = "stp-dig-vnet-nprd"
  resource_group_name = "stp-dig-net-rg-nprd"
}

data "azurerm_subnet" "snet_ai" {
  name                 = "stp-dig-snet-ai-nprd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_app" {
  name                 = "stp-dig-snet-app-nprd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_web" {
  name                 = "stp-dig-snet-web-nprd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_psql" {
  name                 = "stp-dig-snet-psql-nprd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

output "subnets" {
  value = data.azurerm_virtual_network.vnet.subnets
}