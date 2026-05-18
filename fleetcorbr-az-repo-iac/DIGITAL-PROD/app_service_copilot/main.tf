module "web_app_copilot" {
  source = "../../MODULES/app_service_linux"

  resource_group_name = "stp-dig-rg-copilot-prd"
  location            = "brazilsouth"

  service_plan_name             = "spt-dig-asp-copilot-02-prd"
  sku_name                      = "B3"
  app_name                      = "stp-dig-app-copilot-prd"
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
      python_version = "3.10"
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
    FRENTE = "COPILOT ATENDIMENTO"
  }
}


resource "azurerm_private_endpoint" "pep" {
  name                = "stp-dig-pep-app-01-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = module.web_app_copilot.web_app_name
    private_connection_resource_id = module.web_app_copilot.web_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}