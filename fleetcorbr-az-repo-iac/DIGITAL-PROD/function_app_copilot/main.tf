module "function_app_copilot" {
  source = "../../MODULES/function_app"

  resource_group_name = "stp-dig-rg-copilot-prd"
  location            = "brazilsouth"

  service_plan_name = "spt-dig-asp-copilot-01-prd"
  sku_name          = "B3"

  # Application insights config
  create_application_insights = true
  application_insights_name   = "stp-dig-appi-copilot-prd"

  # Storage account Config
  create_storage_account        = true
  storage_account_name          = "stpdigstcopilotoprd"
  storage_public_access_enabled = true
  network_rules = [
    {
      default_action             = "Deny"
      virtual_network_subnet_ids = [data.terraform_remote_state.vnet.outputs.subnet_ids[1]]
    }

  ]

  # Function Config
  function_name                 = "stp-dig-func-copilot-prd"
  builtin_logging_enabled       = true
  public_network_access_enabled = true # Necessário para deploy
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_ids[1]

  site_config = {
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      python_version = "3.11"
    }

    cors = {
      allowed_origins = [
        "https://functions-next.azure.com",
        "https://functions-staging.azure.com",
        "https://functions.azure.com",
        "https://portal.azure.com"
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

  app_settings = {}

  tags = {
    FRENTE = "COPILOT ATENDIMENTO"
  }

}

resource "azurerm_private_endpoint" "pep-01" {
  name                = "stp-dig-pep-func-02-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[3]

  tags = {
    FRENTE = "COPILOTO ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-func-02-prd"
    private_connection_resource_id = module.function_app_copilot.function_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

  depends_on = [module.function_app_copilot]

}

resource "azurerm_private_endpoint" "pep-02" {
  name                = "stp-dig-pep-st-02-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[3]
  tags = {
    "FRENTE" = "COPILOTO ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stpdigstcopilotoprd"
    private_connection_resource_id = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-copilot-prd/providers/Microsoft.Storage/storageAccounts/stpdigstcopilotoprd"
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

}