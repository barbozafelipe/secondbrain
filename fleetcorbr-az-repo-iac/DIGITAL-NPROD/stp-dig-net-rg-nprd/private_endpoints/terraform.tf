terraform {
  backend "azurerm" {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/private_endpoints/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }
}
provider "azurerm" {
  features {
  }
  subscription_id = "36df8ac5-dab6-4301-9cbf-97aa398ba021"
}