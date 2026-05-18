resource "azurerm_service_plan" "res-1" {
  location            = "brazilsouth"
  name                = "ASP-spespeapprgnprd-899c"
  os_type             = "Windows"
  resource_group_name = data.azurerm_resource_group.res-0.name
  sku_name            = "Y1"
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}


resource "azurerm_linux_function_app" "res-2" {
  functions_extension_version = "~1"
  builtin_logging_enabled     = false
  client_certificate_mode     = "Required"
  https_only                  = true
  location                    = "brazilsouth"
  name                        = "spe-spe-app-func-executorbatch-qa"
  resource_group_name         = data.azurerm_resource_group.res-0.name
  service_plan_id             = azurerm_service_plan.res-1.id
  storage_account_name        = data.terraform_remote_state.storage_account.outputs.storage_account_name
  storage_account_access_key  = data.terraform_remote_state.storage_account.outputs.storage_account_key
  tags = {

  }
  app_settings = {

  }
  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = true
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
  }
  depends_on = [
    azurerm_service_plan.res-1,
  ]
}
