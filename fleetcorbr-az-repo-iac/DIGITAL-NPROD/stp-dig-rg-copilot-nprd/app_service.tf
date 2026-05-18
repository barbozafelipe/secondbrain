module "web_app_copilot" {
  source = "../../MODULES/app_service_linux"

  resource_group_name = "stp-dig-rg-copilot-nprd"
  location            = "brazilsouth"

  service_plan_name             = "spt-dig-asp-copilot-02-nprd"
  sku_name                      = "B1"
  app_name                      = "stp-dig-app-copilot-nprd"
  builtin_logging_enabled       = true
  public_network_access_enabled = true # Necessário para deploy do app
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_id[1]

  app_settings = {
    SCM_DO_BUILD_DURING_DEPLOYMENT      = true
    AZURE_FUNCTION_NPRD_URL             = "https://stp-dig-func-copilot-nprd.azurewebsites.net/api/copilot_link_search?code=eVUlP4P8m67M9W-iiRb3FKJClkLv6tqC35ymV14_KwDLAzFucsR_3g%3D%3D"
    JWTKEY                              = "copiloto-atendimento"
    WEBSITES_CONTAINER_START_TIME_LIMIT = "1600"
  }

  site_config = {
    app_command_line                  = "startup.txt"
    always_on                         = true
    scm_use_main_ip_restriction       = false
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      python_version = "3.10"
    }

    cors = {
      allowed_origins = ["https://portal.azure.com"]
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
        ip_address = "64.215.22.0/24"
      },
      5 = {
        action     = "Allow"
        ip_address = "197.98.201.0/24"
      }
      6 = {
        action     = "Allow"
        ip_address = "165.225.34.0/23"
      },
      7 = {
        action     = "Allow"
        ip_address = "201.72.145.18/28"
      }
      8 = {
        action     = "Allow"
        ip_address = "177.19.186.226/29"
      },
      9 = {
        action     = "Allow"
        ip_address = "189.2.204.98/28"
      },
      10 = {
        action     = "Allow"
        ip_address = "189.112.14.105/29"
      }
      11 = {
        action     = "Allow"
        ip_address = "177.19.170.91/29"
      },
      12 = {
        action     = "Allow"
        ip_address = "189.42.46.100/26"
      },
      13 = {
        action     = "Allow"
        ip_address = "75.2.98.97/32"
      },
      14 = {
        action     = "Allow"
        ip_address = "99.83.150.238/32"
      },
      15 = {
        action     = "Allow"
        ip_address = "170.85.0.0/16"
      }
      
    }

  }


  tags = {
    Projeto = "Copiloto Atendimento"
  }
}