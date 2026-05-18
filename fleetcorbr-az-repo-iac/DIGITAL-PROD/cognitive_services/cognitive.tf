data "azurerm_resource_group" "res-0" {
  name = var.data_azurerm_resource_group
}

resource "azurerm_cognitive_account" "res-73" {
  custom_subdomain_name = "stp-dig-cog-prd"
  kind                  = "OpenAI"
  location              = "westeurope"
  name                  = "stp-dig-cog-prd"
  resource_group_name   = "stp-dig-rg-prd"
  sku_name              = "S0"
  network_acls {
    default_action = "Allow"
  }
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cognitive_deployment" "res-74" {
  cognitive_account_id = azurerm_cognitive_account.res-73.id
  name                 = "ada-embedding-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    capacity = 24
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.res-73,
  ]
}
resource "azurerm_cognitive_deployment" "res-75" {
  cognitive_account_id = azurerm_cognitive_account.res-73.id
  name                 = "gpt-35-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }
  scale {
    capacity = 20
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.res-73,
  ]
}

# Novo ambiente PROD
resource "azurerm_cognitive_account" "cog-01" {
  custom_subdomain_name         = "stp-dig-cog-chatbot-prd"
  kind                          = "OpenAI"
  location                      = "eastus"
  name                          = "stp-dig-cog-chatbot-prd"
  resource_group_name           = "stp-dig-rg-chatbot-prd"
  public_network_access_enabled = true
  sku_name                      = "S0"

  network_acls {
    default_action = "Deny"
    ip_rules = [
      "136.226.62.0/23",
      "147.161.128.0/23",
      "165.225.214.0/23"
    ]
  }

  tags = {
    FRENTE = "CHATBOT"
  }

  depends_on = []
}

resource "azurerm_cognitive_deployment" "cog-02" {
  cognitive_account_id = azurerm_cognitive_account.cog-01.id
  name                 = "ada-embedding-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    capacity = 24
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.cog-01,
  ]
}

resource "azurerm_cognitive_deployment" "cog-03" {
  cognitive_account_id = azurerm_cognitive_account.cog-01.id
  name                 = "gpt-35-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }
  scale {
    capacity = 20
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.cog-01,
  ]
}

# Copiloto atendimento
resource "azurerm_cognitive_account" "cog-04" {
  custom_subdomain_name         = "stp-dig-cog-copilot-prd"
  kind                          = "OpenAI"
  location                      = "eastus"
  name                          = "stp-dig-cog-copilot-prd"
  resource_group_name           = "stp-dig-rg-copilot-prd"
  public_network_access_enabled = true
  sku_name                      = "S0"

  network_acls {
    default_action = "Deny"
    ip_rules = [
      "136.226.62.0/23",
      "147.161.128.0/23",
      "165.225.214.0/23"
    ]
  }

  tags = {
    FRENTE = "COPILOTO ATENDIMENTO"
  }

  depends_on = []
}

resource "azurerm_cognitive_deployment" "cog-05" {
  cognitive_account_id = azurerm_cognitive_account.cog-04.id
  name                 = "ada-embedding-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "text-embedding-ada-002"
    version = "2"
  }
  scale {
    capacity = 24
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.cog-01,
  ]
}

resource "azurerm_cognitive_deployment" "cog-06" {
  cognitive_account_id = azurerm_cognitive_account.cog-04.id
  name                 = "gpt-35-azure"
  rai_policy_name      = "Microsoft.Default"
  model {
    format  = "OpenAI"
    name    = "gpt-35-turbo"
    version = "0301"
  }
  scale {
    capacity = 20
    type     = "Standard"
  }
  depends_on = [
    azurerm_cognitive_account.cog-01,
  ]
}

# Private endpoints
resource "azurerm_private_endpoint" "pep-0" {
  name                = "stp-dig-pep-cog-1-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[0]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cog-1-nprd"
    private_connection_resource_id = azurerm_cognitive_account.cog-01.id
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-1" {
  name                = "stp-dig-pep-cog-2-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[0]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cog-2-nprd"
    private_connection_resource_id = azurerm_cognitive_account.cog-04.id
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}