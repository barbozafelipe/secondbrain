data "azurerm_resource_group" "res-0" {
  name = "stp-dig-rg-prd"
}

data "azurerm_application_insights" "res-150" {
  name                = "stp-dig-appi-gpt-prd"
  resource_group_name = data.azurerm_resource_group.res-0.name
}

resource "azurerm_api_management" "res-1" {
  location            = "westeurope"
  name                = "stp-dig-func-gpt-apim-prd"
  publisher_email     = "stp@stp"
  publisher_name      = "sp"
  resource_group_name = data.azurerm_resource_group.res-0.name
  sku_name            = "Basic_1"
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}

resource "azurerm_api_management_api" "res-12" {
  api_management_name = azurerm_api_management.res-1.name
  description         = "Import from \"stp-dig-func-gpt3-prd\" Function App"
  name                = "stp-dig-func-gpt3"
  display_name        = "stp-dig-func-gpt3"
  protocols           = ["https"]
  resource_group_name = data.azurerm_resource_group.res-0.name
  revision            = "1"
  depends_on = [
    azurerm_api_management.res-1,
  ]
}
resource "azurerm_api_management_api_operation" "res-13" {
  api_management_name = azurerm_api_management.res-1.name
  api_name            = "stp-dig-func-gpt3"
  display_name        = "generate-completion"
  method              = "POST"
  operation_id        = "post-generate-completion"
  resource_group_name = data.azurerm_resource_group.res-0.name
  url_template        = "/generate-completion"
  depends_on = [
    azurerm_api_management_api.res-12,
  ]
}
# resource "azurerm_api_management_api_operation_policy" "res-14" {
#   api_management_name = azurerm_api_management.res-1.name
#   api_name            = "stp-dig-func-gpt3"
#   operation_id        = "post-generate-completion"
#   resource_group_name = data.azurerm_resource_group.res-0.name
#   depends_on = [
#     azurerm_api_management_api_operation.res-13,
#   ]
# }
resource "azurerm_api_management_backend" "res-15" {
  api_management_name = azurerm_api_management.res-1.name
  description         = "stp-dig-func-gpt"
  name                = "stp-dig-func-gpt"
  protocol            = "http"
  resource_group_name = data.azurerm_resource_group.res-0.name
  resource_id         = "https://management.azure.com/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/Microsoft.Web/sites/stp-dig-func-gpt"
  url                 = "https://stp-dig-func-gpt.azurewebsites.net/api"
  credentials {
    header = {
      x-functions-key = "{{stp-dig-func-gpt-key}}"
    }
  }
  depends_on = [
    azurerm_api_management.res-1,
  ]
}
resource "azurerm_api_management_backend" "res-16" {
  api_management_name = azurerm_api_management.res-1.name
  description         = "stp-dig-func-gpt3"
  name                = "stp-dig-func-gpt3"
  protocol            = "http"
  resource_group_name = data.azurerm_resource_group.res-0.name
  resource_id         = "https://management.azure.com/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/Microsoft.Web/sites/stp-dig-func-gpt3"
  url                 = "https://stp-dig-func-gpt3.azurewebsites.net/api"
  credentials {
    header = {
      x-functions-key = "{{stp-dig-func-gpt3-key}}"
    }
  }
  depends_on = [
    azurerm_api_management.res-1,
  ]
}

resource "azurerm_api_management_backend" "res-18" {
  api_management_name = "stp-dig-func-gpt-apim-prd"
  description         = "stp-dig-func-gpt3-prd"
  name                = "stp-dig-func-gpt3-prd"
  protocol            = "http"
  resource_group_name = "stp-dig-rg-prd"
  resource_id         = "https://management.azure.com/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/Microsoft.Web/sites/stp-dig-func-gpt3-prd"
  url                 = "https://stp-dig-func-gpt3-prd.azurewebsites.net/api"
  credentials {
    header = {
      x-functions-key = "{{stp-dig-func-gpt3-prd-key}}"
    }
  }
}

resource "azurerm_api_management_diagnostic" "res-17" {
  api_management_logger_id = azurerm_api_management_logger.res-24.id
  api_management_name      = azurerm_api_management.res-1.name
  identifier               = "applicationinsights"
  resource_group_name      = data.azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_api_management_logger.res-24,
  ]
}

resource "azurerm_api_management_logger" "res-24" {
  api_management_name = azurerm_api_management.res-1.name
  name                = "stp-dig-appi-gpt-prd"
  resource_group_name = data.azurerm_resource_group.res-0.name
  resource_id         = data.azurerm_application_insights.res-150.id
  application_insights {
    instrumentation_key = data.azurerm_application_insights.res-150.instrumentation_key
  }
  depends_on = [
    azurerm_api_management.res-1,
  ]
}

resource "azurerm_api_management_named_value" "res-26" {
  api_management_name = azurerm_api_management.res-1.name
  display_name        = "stp-dig-func-gpt-key"
  name                = "stp-dig-func-gpt-key"
  resource_group_name = data.azurerm_resource_group.res-0.name
  secret              = true
  value               = var.GPT-KEY
  tags                = ["key", "function", "auto"]
  depends_on = [
    azurerm_api_management.res-1,
  ]
}
resource "azurerm_api_management_named_value" "res-27" {
  api_management_name = azurerm_api_management.res-1.name
  display_name        = "stp-dig-func-gpt3-key"
  name                = "stp-dig-func-gpt3-key"
  resource_group_name = data.azurerm_resource_group.res-0.name
  secret              = true
  value               = var.GPT3-KEY
  tags                = ["key", "function", "auto"]
  depends_on = [
    azurerm_api_management.res-1,
  ]
}
resource "azurerm_api_management_policy" "res-35" {
  api_management_id = azurerm_api_management.res-1.id
  xml_content       = "<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n\t<inbound />\r\n\t<backend>\r\n\t\t<forward-request />\r\n\t</backend>\r\n\t<outbound />\r\n</policies>"
  depends_on = [
    azurerm_api_management.res-1,
  ]
}
resource "azurerm_api_management_product" "res-40" {
  api_management_name = azurerm_api_management.res-1.name
  description         = "Subscribers will be able to run 5 calls/minute up to a maximum of 100 calls/week."
  display_name        = "Starter"
  product_id          = "starter"
  published           = true
  resource_group_name = data.azurerm_resource_group.res-0.name
  subscriptions_limit = 1
  depends_on = [
    azurerm_api_management.res-1,
  ]
}

resource "azurerm_api_management_product" "res-46" {
  api_management_name = azurerm_api_management.res-1.name
  approval_required   = true
  description         = "Subscribers have completely unlimited access to the API. Administrator approval is required."
  display_name        = "Unlimited"
  product_id          = "unlimited"
  published           = true
  resource_group_name = data.azurerm_resource_group.res-0.name
  subscriptions_limit = 1
  depends_on = [
    azurerm_api_management.res-1,
  ]
}

resource "azurerm_api_management_subscription" "res-54" {
  allow_tracing       = false
  api_management_name = azurerm_api_management.res-1.name
  display_name        = "stp-dig-func-gpt-apim-sub-1"
  resource_group_name = data.azurerm_resource_group.res-0.name
  state               = "active"
  depends_on = [
    azurerm_api_management_product.res-40,
    #azurerm_api_management_user.res-72,
  ]
}
resource "azurerm_api_management_subscription" "res-55" {
  allow_tracing       = false
  api_management_name = azurerm_api_management.res-1.name
  display_name        = "stp-dig-func-gpt-apim-sub-2"
  resource_group_name = data.azurerm_resource_group.res-0.name
  state               = "active"
  depends_on = [
    azurerm_api_management_product.res-46,
    #azurerm_api_management_user.res-72,
  ]
}
resource "azurerm_api_management_subscription" "res-56" {
  allow_tracing       = false
  api_management_name = azurerm_api_management.res-1.name
  display_name        = "API stp-dig-func-gpt subscription"
  resource_group_name = data.azurerm_resource_group.res-0.name
  state               = "active"
  depends_on = [
    azurerm_api_management_api.res-12,
  ]
}
