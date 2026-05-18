module "function_app_chatbot" {
  source = "../../MODULES/function_app"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location

  service_plan_name = "spt-dig-asp-chatbot-nprd"
  sku_name          = "B1"

  create_application_insights = true
  create_storage_account      = true

  function_name                 = "stp-dig-func-chatbot-nprd"
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_id[1]
  public_network_access_enabled = true
  builtin_logging_enabled       = true

  application_insights_name = "stp-dig-appi-chatbot-nprd"

  # Storage Account Settings
  storage_account_name          = "stpdigstchatbotnprd"
  storage_public_access_enabled = true
  network_rules = [{
    default_action             = "Deny"
    ip_rules                   = ["165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23", "136.226.138.0/23", "136.226.140.0/23"]
    virtual_network_subnet_ids = [data.terraform_remote_state.vnet.outputs.subnet_id[1]]
    }
  ]

  site_config = {
    api_management_api_id             = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-chatbot-nprd/providers/Microsoft.ApiManagement/service/stp-dig-apim-chatbot-nprd/apis/stp-dig-func-chatbot-nprd"
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Allow"

    application_stack = {
      python_version = "3.13"
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
      11= {
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

  app_settings = {}

  tags = {
    Projeto = "Super Carol"
  }

}

resource "azurerm_private_endpoint" "pep-01" {
  name                          = "stp-dig-pep-func-chatbot-nprd"
  resource_group_name           = "stp-dig-net-rg-nprd"
  location                      = "brazilsouth"
  custom_network_interface_name = "stp-dig-nic-chatbot-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = module.function_app_chatbot.function_app_name
    private_connection_resource_id = module.function_app_chatbot.function_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}