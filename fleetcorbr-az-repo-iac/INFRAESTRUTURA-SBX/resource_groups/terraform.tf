terraform {
  backend "azurerm" {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "INFRAESTRUTURA-SBX/resource_groups/terraform.tfstate"
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
  subscription_id = "cf11926c-96d3-41ab-83d7-1682fb067086"
}