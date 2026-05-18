data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/vnet/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

module "function_app_copilot" {
  source = "../../MODULES/function_app"

  resource_group_name = "stp-dig-rg-copilot-nprd"
  location            = "brazilsouth"

  service_plan_name = "spt-dig-asp-copilot-01-nprd"
  sku_name          = "B1"

  create_application_insights = true
  application_insights_name   = "stp-dig-appi-copilot-nprd"
  create_storage_account      = false

  function_name                 = "stp-dig-func-copilot-nprd"
  builtin_logging_enabled       = true
  public_network_access_enabled = true # Necessário para deploy
  storage_account_name          = module.storage_account_copilot.storage_account_name
  storage_account_access_key    = module.storage_account_copilot.storage_account_key
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_id[1]

  site_config = {
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Deny"

    application_stack = {
      python_version = "3.11"
    }

    app_service_logs = {
      disk_quota_mb         = 100
      retention_period_days = 3
    }

    cors = {
      allowed_origins = [
        "https://victorious-meadow-0240cb70f.4.azurestaticapps.net",
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
    "Projeto" = "Copiloto Atendimento"
  }

}
