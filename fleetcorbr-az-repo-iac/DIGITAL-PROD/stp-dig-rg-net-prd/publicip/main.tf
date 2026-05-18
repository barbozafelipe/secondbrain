locals {
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
}

resource "azurerm_public_ip" "pip-01" {
  name                = "stp-dig-pip-apim-chatbot-prd"
  location            = local.location
  resource_group_name = local.resource_group_name
  allocation_method   = "Static"
  domain_name_label   = "stp-dig-pip-apim-chatbot-prd"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}