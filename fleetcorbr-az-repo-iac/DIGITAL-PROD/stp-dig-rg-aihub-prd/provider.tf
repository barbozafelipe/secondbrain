provider "azurerm" {
  features {}
  subscription_id = "b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058"
}

terraform {
  backend "azurerm" {
    storage_account_name = "pltidtsttfstate"
    resource_group_name  = "plt-idt-rg"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/stp-dig-rg-aihub-prd/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
    tenant_id            = "e710eef2-4915-4eba-8fbe-5fd8583a44f8"
  }
}