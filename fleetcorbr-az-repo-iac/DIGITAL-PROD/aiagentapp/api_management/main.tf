locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
  location            = "brazilsouth"
}

resource "azurerm_api_management" "apim-01" {
  name                = "stp-dig-apim-aiagentsapp-prd"
  resource_group_name = local.resource_group_name
  location            = local.location

  sku_name             = "Developer_1"
  publisher_email      = "stp@stp"
  publisher_name       = "Digital"
  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = data.terraform_remote_state.vnet.outputs.subnet_ids[4]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }

}