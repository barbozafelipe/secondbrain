data "azurerm_resource_group" "rg" {
  name = "stp-dig-net-rg-nprd"
}

resource "azurerm_public_ip" "res-11" {
  name                = "stp-dig-pip-apim-nprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "stp-dig-pip-apim-nprd"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}

### Public IP Chatbot
resource "azurerm_public_ip" "pip-03" {
  name                = "stp-dig-pip-apim-chatbot-nprd"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "stp-dig-pip-apim-chatbot-nprd"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}