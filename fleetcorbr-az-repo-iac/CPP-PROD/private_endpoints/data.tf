data "azurerm_resource_group" "rg" {
  name = "stp-cpp-rg-net-prd"
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "CPP-PROD/vnet/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "azurerm_storage_account" "storage_account" {
  name                = "stpcppstprd"
  resource_group_name = "stp-cpp-rg-prd"
}

