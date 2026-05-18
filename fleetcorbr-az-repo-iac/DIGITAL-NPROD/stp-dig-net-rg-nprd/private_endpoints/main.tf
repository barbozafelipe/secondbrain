resource "azurerm_private_endpoint" "pep-0" {
  name                          = "stp-dig-pep-cog-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-cog-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cog-1-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-nprd/providers/Microsoft.CognitiveServices/accounts/stp-dig-cog-nprd"
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-1" {
  name                          = "stp-dig-pep-st-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-st-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-pep-1-nprd"
    private_connection_resource_id = data.terraform_remote_state.storage_account.outputs.storage_account_id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-2" {
  name                          = "stp-dig-pep-cdb-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-cdb-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cdb-1-nprd"
    private_connection_resource_id = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-3" {
  name                          = "stp-dig-pep-srch-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-srch-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-srch-1-nprd"
    private_connection_resource_id = data.terraform_remote_state.search_services.outputs.search_service_id
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-4" {
  name                          = "stp-dig-pep-func-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-func-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-func-1-nprd"
    private_connection_resource_id = data.terraform_remote_state.func.outputs.function_app_id
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}

### Abastece

resource "azurerm_private_endpoint" "pep-5" {
  name                          = "stp-dig-pep-st-2-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-st-2-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnets_abastece_id[4]
  tags = {
    "FRENTE" = "ABASTECE"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = data.terraform_remote_state.storage_account.outputs.st_abastece_name
    private_connection_resource_id = data.terraform_remote_state.storage_account.outputs.st_abastece_id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-6" {
  name                          = "stp-dig-pep-cog-2-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-cog-2-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnets_abastece_id[4]
  tags = {
    "FRENTE" = "ABASTECE"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cog-abastece-nprd"
    private_connection_resource_id = data.terraform_remote_state.cog.outputs.cog_abastece_id
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-7" {
  name                          = "stp-dig-pep-cdb-2-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-cdb-2-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnets_abastece_id[4]
  tags = {
    "FRENTE" = "ABASTECE"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cdb-abastece-nprd"
    private_connection_resource_id = data.terraform_remote_state.cosmosdb.outputs.cosmosdb_abastece_id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-9" {
  name                          = "stp-dig-pep-func-2-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-func-2-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnets_abastece_id[4]
  tags = {
    "FRENTE" = "ABASTECE"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-func-abastece-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-abastece-nprd/providers/Microsoft.Web/sites/stp-dig-func-abastece-nprd"
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}

### Copilot Atendimento

resource "azurerm_private_endpoint" "pep-10" {
  name                          = "stp-dig-pep-st-3-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-st-3-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = data.terraform_remote_state.storage_account.outputs.st_copilot_name
    private_connection_resource_id = data.terraform_remote_state.storage_account.outputs.st_copilot_id
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-11" {
  name                          = "stp-dig-pep-func-3-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-func-3-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-func-copilot-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-nprd/providers/Microsoft.Web/sites/stp-dig-func-copilot-nprd"
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}

resource "azurerm_private_endpoint" "pep-12" {
  name                          = "stp-dig-pep-cdb-3-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-cdb-3-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cdb-copilot-nprd"
    private_connection_resource_id = data.terraform_remote_state.cosmosdb.outputs.cdb_copilot_id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}

# resource "azurerm_private_endpoint" "pep-13" {
#   name                          = "stp-dig-pep-srch-2-nprd"
#   resource_group_name           = data.azurerm_resource_group.rg.name
#   location                      = data.azurerm_resource_group.rg.location
#   custom_network_interface_name = "stp-dig-nic-pep-srch-2-nprd"
#   subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
#   tags = {
#     "FRENTE" = "COPILOT ATENDIMENTO"
#   }

#   private_service_connection {
#     is_manual_connection           = false
#     name                           = "stp-dig-srch-copilot-nprd"
#     private_connection_resource_id = data.terraform_remote_state.search_services.outputs.srch_copilot_id
#     subresource_names              = ["searchService"]
#   }

#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
#   }

# }

resource "azurerm_private_endpoint" "pep-14" {
  name                          = "stp-dig-pep-cog-3-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-cog-3-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cog-copilot-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-nprd/providers/Microsoft.CognitiveServices/accounts/stp-dig-cog-copilot-nprd"
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-15" {
  name                          = "stp-dig-pep-app-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-nic-pep-app-1-nprd"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-app-copilot-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-nprd/providers/Microsoft.Web/sites/stp-dig-app-copilot-nprd"
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}

### Copilot Atendimento HML

resource "azurerm_private_endpoint" "pep-16" {
  name                = "stp-dig-pep-st-4-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stpdigstcopilothmlnprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.Storage/storageAccounts/stpdigstcopilothmlnprd"
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-17" {
  name                = "stp-dig-pep-func-4-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-func-copilot-hml-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.Web/sites/stp-dig-func-copilot-hml-nprd"
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}

resource "azurerm_private_endpoint" "pep-18" {
  name                = "stp-dig-pep-cdb-4-hml-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cdb-copilot-hml-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.DocumentDB/databaseAccounts/stp-dig-cdb-copilot-hml-nprd"
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-19" {
  name                = "stp-dig-pep-srch-3-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-srch-copilot-hml-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.Search/searchServices/stp-dig-srch-copilot-hml-nprd"
    subresource_names              = ["searchService"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.search.windows.net"]
  }

}

resource "azurerm_private_endpoint" "pep-20" {
  name                = "stp-dig-pep-cog-4-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags                = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-cog-copilot-hml-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.CognitiveServices/accounts/stp-dig-cog-copilot-hml-nprd"
    subresource_names              = ["account"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.openai.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-21" {
  name                = "stp-dig-pep-app-2-hml-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_id[3]
  tags = {
    "FRENTE" = "COPILOT ATENDIMENTO"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-app-copilot-hml-nprd"
    private_connection_resource_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-rg-copilot-hml-nprd/providers/Microsoft.Web/sites/stp-dig-app-copilot-hml-nprd"
    subresource_names              = ["sites"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

}