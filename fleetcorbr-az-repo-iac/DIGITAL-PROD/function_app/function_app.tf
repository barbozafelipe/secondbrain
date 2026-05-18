data "azurerm_resource_group" "res-0" {
  name = "stp-dig-rg-prd"
}

data "terraform_remote_state" "app_insights" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/application_insights/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "apim" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/api_management/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "cosmosdb" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/cosmos_db/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

data "terraform_remote_state" "storage_account" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-PROD/storage_account/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

resource "azurerm_service_plan" "res-121" {
  location            = "brazilsouth"
  name                = "ASP-stpdigrgprd-8e89"
  os_type             = "Linux"
  resource_group_name = data.azurerm_resource_group.res-0.name
  sku_name            = "Y1"
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}

resource "azurerm_linux_function_app" "res-135" {
  builtin_logging_enabled    = false
  client_certificate_mode    = "Required"
  https_only                 = true
  location                   = "brazilsouth"
  name                       = "stp-dig-func-gpt3-prd"
  resource_group_name        = data.azurerm_resource_group.res-0.name
  service_plan_id            = azurerm_service_plan.res-121.id
  storage_account_name       = "stpdigrgprda398"
  storage_account_access_key = data.terraform_remote_state.storage_account.outputs.storage_account_key_a398
  tags = {
    "hidden-link: /app-insights-conn-string"         = data.terraform_remote_state.app_insights.outputs.connection_string_gpt-3
    "hidden-link: /app-insights-instrumentation-key" = data.terraform_remote_state.app_insights.outputs.instrumentation_key_gpt-3
    "hidden-link: /app-insights-resource-id"         = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/microsoft.insights/components/stp-dig-appi-gpt3-prd"
  }
  app_settings = {
    "EMBEDDING_DEPLOYMENT"  = "${var.EMBEDDING_DEPLOYMENT}"
    "GPT_DEPLOYMENT"        = "${var.GPT_DEPLOYMENT}"
    "INDEX_NAME"            = "${var.INDEX_NAME}"
    "OPENAI_API_KEY"        = "${var.OPENAI_API_KEY}"
    "OPENAI_API_URL"        = "${var.OPENAI_API_URL}"
    "OPENAI_API_VERSION"    = "${var.OPENAI_API_VERSION}"
    "VECTOR_STORE_ADDRESS"  = "${var.VECTOR_STORE_ADDRESS}"
    "VECTOR_STORE_PASSWORD" = "${var.VECTOR_STORE_PASSWORD}"
    "GPT_FUNCTION_URL"      = "${var.GPT_FUNCTION_URL}"
    "APIM_SUBSCRIPTION_KEY" = data.terraform_remote_state.apim.outputs.apim_subscription_key
    # CHG
    "COSMOS_KEY"            = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_key
    "GPT_STOP_WORDS"        = "${var.GPT_STOP_WORDS}"
    "COSMOS_ENDPOINT"       = "${var.COSMOS_ENDPOINT}"
    "COSMOS_DATABASE_NAME"  = "${var.COSMOS_DATABASE_NAME}"
    "COSMOS_CONTAINER_NAME" = "${var.COSMOS_CONTAINER_NAME}"
    "COSMOS_PARTITION_KEY"  = "${var.COSMOS_PARTITION_KEY}"
    "INDEX_NAME_CONTEXT"    = "${var.INDEX_NAME_CONTEXT}"
  }
  site_config {
    application_insights_connection_string = data.terraform_remote_state.app_insights.outputs.connection_string_gpt-3
    application_insights_key               = data.terraform_remote_state.app_insights.outputs.instrumentation_key_gpt-3
    ftps_state                             = "FtpsOnly"
    application_stack {
      python_version = "3.9"
    }
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
  depends_on = [
    azurerm_service_plan.res-121,
  ]
}
