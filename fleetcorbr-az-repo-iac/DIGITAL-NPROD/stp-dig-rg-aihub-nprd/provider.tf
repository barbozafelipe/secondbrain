provider "azurerm" {
  features {}
  subscription_id = "36df8ac5-dab6-4301-9cbf-97aa398ba021"
}

terraform {
  backend "azurerm" {
    storage_account_name = "pltidtsttfstate"
    resource_group_name  = "plt-idt-rg"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/stp-dig-rg-aihub-nprd/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
    tenant_id            = "e710eef2-4915-4eba-8fbe-5fd8583a44f8"
  }
}