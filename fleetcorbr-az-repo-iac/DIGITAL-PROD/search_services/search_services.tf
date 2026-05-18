data "azurerm_resource_group" "res-0" {
  name = var.data_azurerm_resource_group
}

resource "azurerm_search_service" "res-82" {
  location            = "westeurope"
  name                = "stp-dig-cogsearch-prd"
  resource_group_name = data.azurerm_resource_group.res-0.name
  sku                 = "free"
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}

# Novo ambiente PROD
resource "azurerm_search_service" "srch-01" {
  name                          = "stp-dig-srch-chatbot-prd"
  resource_group_name           = "stp-dig-rg-chatbot-prd"
  location                      = "brazilsouth"
  sku                           = "basic"
  public_network_access_enabled = true
  allowed_ips = [
    "136.226.62.0/23",
    "147.161.128.0/23",
    "165.225.214.0/23",
    "40.124.115.40"
  ]

  tags = {
    FRENTE = "CHATBOT"
  }
}

resource "azurerm_search_service" "srch-02" {
  name                          = "stp-dig-srch-copilot-prd"
  resource_group_name           = "stp-dig-rg-copilot-prd"
  location                      = "brazilsouth"
  sku                           = "basic"
  public_network_access_enabled = true
  allowed_ips = [
    "136.226.62.0/23",
    "147.161.128.0/23",
    "165.225.214.0/23",
    "40.124.115.40"
  ]

  tags = {
    FRENTE = "COPILOTO ATENDIMENTO"
  }
}

# Private Endpoints 
resource "azurerm_private_endpoint" "pep-01" {
  name                          = "stp-dig-pep-srch-1-prd"
  resource_group_name           = "stp-dig-rg-net-prd"
  location                      = "brazilsouth"
  custom_network_interface_name = "stp-dig-pep-srch-1-prd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_ids[0]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-srch-1-prd"
    private_connection_resource_id = azurerm_search_service.srch-01.id
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  }

  depends_on = [azurerm_search_service.srch-01]

}

# Copiloto
resource "azurerm_private_endpoint" "pep-02" {
  name                          = "stp-dig-pep-srch-2-prd"
  resource_group_name           = "stp-dig-rg-net-prd"
  location                      = "brazilsouth"
  custom_network_interface_name = "stp-dig-pep-srch-2-prd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_ids[0]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-srch-2-prd"
    private_connection_resource_id = azurerm_search_service.srch-02.id
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  }

  depends_on = [azurerm_search_service.srch-02]

}