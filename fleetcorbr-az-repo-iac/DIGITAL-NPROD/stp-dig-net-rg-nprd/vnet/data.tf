data "azurerm_resource_group" "rg" {
  name = "stp-dig-net-rg-nprd"
}

data "terraform_remote_state" "route_tables" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/route_tables/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

data "terraform_remote_state" "nsg" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/nsg/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

data "terraform_remote_state" "vnet_hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "NETWORK/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}