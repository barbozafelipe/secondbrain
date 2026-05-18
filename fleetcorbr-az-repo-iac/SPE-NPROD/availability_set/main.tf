data "terraform_remote_state" "network_interface" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/network_interfaces/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_availability_set" "avset" {
  name                         = "spe-spe-avail-01-nprd"
  location                     = "brazilsouth"
  resource_group_name          = "spe-spe-app-rg-nprd"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}