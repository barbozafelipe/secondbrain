data "azurerm_virtual_network" "vnet" {
  name                = "stp-dig-vnet-prd"
  resource_group_name = "stp-dig-rg-net-prd"
}

data "azurerm_subnet" "snet_ai" {
  name                 = "stp-dig-snet-ai-prd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_app" {
  name                 = "stp-dig-snet-app-prd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_web" {
  name                 = "stp-dig-snet-web-prd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

output "subnets" {
  value = data.azurerm_virtual_network.vnet.subnets
}

data "azurerm_subnet" "snet_db" {
  name                 = "stp-dig-snet-db-prd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_subnet" "snet_psql" {
  name                 = "stp-dig-snet-psql-prd"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}
 