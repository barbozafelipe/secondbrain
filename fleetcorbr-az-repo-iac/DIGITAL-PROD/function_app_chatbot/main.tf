module "function_app" {
  source = "../../MODULES/function_app"

  resource_group_name = "stp-dig-rg-chatbot-prd"
  location            = "brazilsouth"

  function_name     = "stp-dig-func-chatbot-prd"
  service_plan_name = "spt-dig-asp-chatbot-01-prd"
  sku_name          = "B2"

  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_ids[1]
  public_network_access_enabled = true

  # Storage account config
  storage_account_name          = "stpdigstchatbotprd"
  storage_public_access_enabled = true
  network_rules = [{
    default_action = "Deny"
    ip_rules       = ["165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23", "136.226.138.0/23", "136.226.140.0/23"]
    }
  ]

  create_application_insights = true
  application_insights_name   = "stp-dig-appi-chatbot-prd"

  site_config = {
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      python_version = "3.9"
    }

    cors = {
      allowed_origins = [
        "*"
      ]
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

  app_settings = {
  }

  tags = {
    FRENTE = "CHATBOT"
  }

}

resource "azurerm_private_endpoint" "pep-01" {
  name                = "stp-dig-pep-func-1-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[3]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-func-1-prd"
    private_connection_resource_id = module.function_app.function_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

  depends_on = [module.function_app]

}