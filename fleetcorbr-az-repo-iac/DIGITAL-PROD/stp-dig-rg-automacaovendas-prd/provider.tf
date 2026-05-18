provider "azurerm" {
  subscription_id = "b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058"
  features {
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/stp-dig-rg-automacaovendas-prd/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}
