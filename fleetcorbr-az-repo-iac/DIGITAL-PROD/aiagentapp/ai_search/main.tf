locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
}

resource "azurerm_search_service" "srch-01" {
  name                          = "stp-dig-srch-aiagentapp-prd"
  resource_group_name           = local.resource_group_name
  location                      = "brazilsouth"
  public_network_access_enabled = true

  sku = "basic"

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }
}