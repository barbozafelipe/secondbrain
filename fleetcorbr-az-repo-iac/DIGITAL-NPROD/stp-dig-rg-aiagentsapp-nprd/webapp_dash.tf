module "web_app_dash" {
  source = "../../MODULES/app_service_linux"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location

  service_plan_name             = "stp-dig-app-aiagentsdash-nprd"
  sku_name                      = "B1"
  app_name                      = "stp-dig-app-aiagentsdash-nprd"
  builtin_logging_enabled       = true
  https_only                    = true
  public_network_access_enabled = true
  virtual_network_subnet_id     = data.azurerm_subnet.snet_app.id

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT = true
  }

  site_config = {
    always_on                         = true
    scm_use_main_ip_restriction       = false
    ip_restriction_default_action     = "Allow"
    scm_ip_restriction_default_action = "Allow"

    application_stack = {
      docker_image_name   = "mcr.microsoft.com/k8se/quickstart:latest"
    }

    cors = {
      allowed_origins     = ["*"]
      support_credentials = false
    }

    scm_ip_restriction = {
      1 = {
        action     = "Allow"
        ip_address = "147.161.128.0/17"
      },
      2 = {
        action     = "Allow"
        ip_address = "136.226.0.0/16"
      },
      3 = {
        action     = "Allow"
        ip_address = "165.225.192.0/18"
      },
      4 = {
        action     = "Allow"
        ip_address = "170.85.0.0/16"
      }
    }
  }
}