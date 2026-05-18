data "terraform_remote_state" "app_insights" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/application_insights/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "apim" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/api_management/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "cosmosdb" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/cosmos_db/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "cognitive_services" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/cognitive_services/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "search_services" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/search_services/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "storage_account" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/storage_account/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/vnet/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}