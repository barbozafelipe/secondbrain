data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_eventhub_namespace" "res-0" {
  name                          = "spe-spe-evh-nprd"
  public_network_access_enabled = true
  location                      = "brazilsouth"
  resource_group_name           = "spe-spe-app-rg-nprd"
  sku                           = "Standard"
  capacity                      = 1


  tags = {
    environment = "NPROD"
  }
}

resource "azurerm_eventhub" "res-1" {
  for_each            = toset(var.eventhub_names)
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.res-0.name
  resource_group_name = "spe-spe-app-rg-nprd"
  partition_count     = 3
  message_retention   = 1
}

