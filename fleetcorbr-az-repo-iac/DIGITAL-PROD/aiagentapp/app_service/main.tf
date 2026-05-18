locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
  location            = "brazilsouth"
  web_app_name        = "stp-dig-app-aiagentsapp-prd"
}

module "web_app_copilot" {
  source = "../../../MODULES/app_service_linux"

  resource_group_name = local.resource_group_name
  location            = local.location

  create_app_service_plan = true
  service_plan_name       = "stp-dig-asp-aiagentsapp-02-prd"

  app_name                      = local.web_app_name
  builtin_logging_enabled       = true
  public_network_access_enabled = true # Necessário para deploy do app
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_ids[1]

  app_settings = {}

  site_config = {
    always_on                         = true
    scm_use_main_ip_restriction       = false
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      node_version = "22-lts"
    }

    cors = {
      allowed_origins = ["https://portal.azure.com"]
    }

    scm_ip_restriction = {
      1 = {
        action     = "Allow"
        ip_address = "147.161.128.0/23"
      },
      2 = {
        action     = "Allow"
        ip_address = "136.226.62.0/23"
      },
      3 = {
        action     = "Allow"
        ip_address = "165.225.214.0/23"
      },
      4 = {
        action     = "Allow"
        ip_address = "165.225.222.0/23"
      },
      5 = {
        action     = "Allow"
        ip_address = "64.215.22.0/24"
      },
      6 = {
        action     = "Allow"
        ip_address = "197.98.201.0/24"
      }
      7 = {
        action     = "Allow"
        ip_address = "165.225.34.0/23"
      },
      8 = {
        action     = "Allow"
        ip_address = "201.72.145.18/28"
      }
      9 = {
        action     = "Allow"
        ip_address = "177.19.186.226/29"
      },
      10 = {
        action     = "Allow"
        ip_address = "189.2.204.98/28"
      },
      11 = {
        action     = "Allow"
        ip_address = "189.112.14.105/29"
      }
      12 = {
        action     = "Allow"
        ip_address = "177.19.170.91/29"
      },
      13 = {
        action     = "Allow"
        ip_address = "189.42.46.100/26"
      },
      14 = {
        action     = "Allow"
        ip_address = "75.2.98.97/32"
      },
      15 = {
        action     = "Allow"
        ip_address = "99.83.150.238/32"
      }
    }

  }

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }
}