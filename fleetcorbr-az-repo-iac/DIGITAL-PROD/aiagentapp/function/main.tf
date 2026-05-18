locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
  location            = "brazilsouth"
  function_name       = "stp-dig-func-aiagentsapp-prd"
}

module "function_app" {
  source = "../../../MODULES/function_app"

  resource_group_name = local.resource_group_name
  location            = local.location

  service_plan_name         = "stp-dig-asp-aiagentsapp-01-prd"
  application_insights_name = "stp-dig-appi-aiagentsapp-prd"
  sku_name                  = "B1"

  create_application_insights = true
  create_storage_account      = false

  function_name                 = local.function_name
  builtin_logging_enabled       = true
  public_network_access_enabled = true
  storage_account_name          = data.terraform_remote_state.storage_account.outputs.storage_account_name
  storage_account_access_key    = data.terraform_remote_state.storage_account.outputs.storage_account_key
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_ids[1]

  site_config = {
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      python_version = "3.12"
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
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }

}


resource "azurerm_private_endpoint" "pep-02" {
  name                = "stp-dig-pep-aiagentapp-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[3]

  private_service_connection {
    is_manual_connection           = false
    name                           = "stpdigstcopilotoprd"
    private_connection_resource_id = module.function_app.function_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }
}