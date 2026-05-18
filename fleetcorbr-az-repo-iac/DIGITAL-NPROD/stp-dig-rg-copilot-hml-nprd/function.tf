module "function_app_copilot_hml" {
  source = "../../MODULES/function_app"

  resource_group_name = "stp-dig-rg-copilot-hml-nprd"
  location            = "brazilsouth"

  service_plan_name = "spt-dig-asp-copilot-01-hml-nprd"
  sku_name          = "B1"

  create_application_insights = true
  create_storage_account      = true

  function_name                 = "stp-dig-func-copilot-hml-nprd"
  virtual_network_subnet_id     = data.terraform_remote_state.vnet.outputs.subnet_id[1]
  public_network_access_enabled = true
  builtin_logging_enabled       = true

  application_insights_name = "stp-dig-appi-copilot-hml-nprd"

  # Storage Account Settings
  storage_account_name          = "stpdigstcopilothmlnprd"
  storage_public_access_enabled = true
  network_rules = [{
    default_action             = "Deny"
    ip_rules                   = ["136.226.138.0/23", "136.226.140.0/23", "165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23"]
    virtual_network_subnet_ids = [data.terraform_remote_state.vnet.outputs.subnet_id[1]]
    }
  ]

  site_config = {
    app_command_line                  = "gunicorn app:app -k uvicorn.workers.UvicornWorker --bind=0.0.0.0:8000 --workers 2"
    always_on                         = true
    ip_restriction_default_action     = "Deny"
    scm_ip_restriction_default_action = "Allow"

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

  app_settings = {}

  tags = {
    Projeto = "Copiloto Atendimento"
  }

}