data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_service_plan" "res-0" {
  name                = "spe-spe-plan-01-nprd"
  location            = "brazilsouth"
  resource_group_name = "spe-spe-plan-01-rg-nprd"
  os_type             = "Windows"
  sku_name            = "B1" # Dev/Test
}

resource "azurerm_windows_web_app" "res-1" {
  name                      = "spe-spe-app-rodocred-qa-nprd"
  location                  = "brazilsouth"
  resource_group_name       = "spe-spe-plan-01-rg-nprd"
  service_plan_id           = azurerm_service_plan.res-0.id
  virtual_network_subnet_id = data.terraform_remote_state.vnet.outputs.subnet_plan_01_id
  client_affinity_enabled   = true
  app_settings = {
    "WEBSITE_TIME_ZONE"         = "E. South America Standard Time"
    "WEBSITE_LOAD_USER_PROFILE" = "1"
  }

  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = false

  }
}

resource "azurerm_windows_web_app" "res-2" {
  name                      = "spe-spe-app-integracaofleetcor-qa-nprd"
  location                  = "brazilsouth"
  resource_group_name       = "spe-spe-plan-01-rg-nprd"
  service_plan_id           = azurerm_service_plan.res-0.id
  virtual_network_subnet_id = data.terraform_remote_state.vnet.outputs.subnet_plan_01_id
  client_affinity_enabled   = true
  https_only                = true
  app_settings = {
    "WEBSITE_TIME_ZONE"         = "E. South America Standard Time"
    "WEBSITE_LOAD_USER_PROFILE" = "1"

  }
  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = false
    always_on         = false
    virtual_application {
      physical_path = "site\\wwwroot"
      preload       = false
      virtual_path  = "/"
    }

  }
}

resource "azurerm_windows_web_app" "res-3" {
  https_only                = true
  name                      = "spe-spe-app-consumer-qa-nprod"
  location                  = "brazilsouth"
  resource_group_name       = "spe-spe-app-rg-nprd"
  service_plan_id           = azurerm_service_plan.res-0.id
  virtual_network_subnet_id = data.terraform_remote_state.vnet.outputs.subnet_plan_01_id
  client_affinity_enabled   = true
  app_settings = {
    "WEBSITE_TIME_ZONE" = "E. South America Standard Time"
  }

  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = true

  }
}


resource "azurerm_windows_web_app" "res-4" {
  https_only                    = true
  name                          = "spe-spe-app-cofre-nprd"
  location                      = "brazilsouth"
  resource_group_name           = "spe-spe-plan-01-rg-nprd"
  service_plan_id               = azurerm_service_plan.res-0.id
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_plan_01_id
  client_affinity_enabled       = true
  public_network_access_enabled = false
  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = true

  }
}


