locals {
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  web_app_name        = "stp-dig-app-aiagentsapp-hml-nprd"
}

module "web_app_aiagentsapp" {
  source = "../../MODULES/app_service_linux"

  resource_group_name = local.resource_group_name
  location            = local.location

  create_app_service_plan = true
  service_plan_name       = "stp-dig-asp-aiagentsapp-02-hml-nprd"

  app_name                      = local.web_app_name
  builtin_logging_enabled       = true
  public_network_access_enabled = true # Necessário para deploy do app
  virtual_network_subnet_id     = data.azurerm_subnet.snet_app.id

  app_settings = {}

  site_config = {
    always_on                         = true
    app_command_line                  = "npm start"
    scm_use_main_ip_restriction       = false
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      node_version = "22-lts"
    }

    cors = {
      allowed_origins = ["https://portal.azure.com"]
    }

    ip_restriction = {
      1 = {
        action     = "Allow"
        ip_address = "20.201.95.124/32"
      }
      2 = {
        action     = "Allow"
        ip_address = "45.60.0.0/16"
      }
      3 = {
        action     = "Allow"
        ip_address = "45.64.64.0/22"
      }
      4 = {
        action     = "Allow"
        ip_address = "45.223.0.0/16"
      }
      5 = {
        action     = "Allow"
        ip_address = "103.28.248.0/22"
      }
      6 = {
        action     = "Allow"
        ip_address = "107.154.0.0/16"
      }
      7 = {
        action     = "Allow"
        ip_address = "131.125.128.0/17"
      }
      8 = {
        action     = "Allow"
        ip_address = "149.126.72.0/21"
      }
      9 = {
        action     = "Allow"
        ip_address = "185.11.124.0/22"
      }
      10 = {
        action     = "Allow"
        ip_address = "192.230.64.0/18"
      }
      11 = {
        action     = "Allow"
        ip_address = "198.143.32.0/19"
      }
      12 = {
        action     = "Allow"
        ip_address = "199.83.128.0/21"
      }
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
    application = "aiagentsapp"
    environment = "nprd"
    team        = "digital"
  }
}