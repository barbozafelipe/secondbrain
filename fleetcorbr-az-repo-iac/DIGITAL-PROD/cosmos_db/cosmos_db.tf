data "azurerm_resource_group" "res-0" {
  name = var.data_azurerm_resource_group
}

resource "azurerm_cosmosdb_account" "res-76" {
  name                             = "stp-dig-cdb-prd"
  location                         = "brazilsouth"
  resource_group_name              = data.azurerm_resource_group.res-0.name
  free_tier_enabled                = true
  multiple_write_locations_enabled = true
  minimal_tls_version              = "Tls12"
  offer_type                       = "Standard"
  public_network_access_enabled    = true
  ip_range_filter                  = "54.94.237.166/32,64.215.22.0/24,165.225.214.0/23,147.161.128.0/23,136.226.62.0/23,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"


  tags = {
    defaultExperience       = "Core (SQL)"
    hidden-cosmos-mmspecial = ""
  }
  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    failover_priority = 0
    location          = "brazilsouth"
  }
  geo_location {
    failover_priority = 1
    location          = "southcentralus"
  }
  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cosmosdb_sql_database" "res-77" {
  account_name        = azurerm_cosmosdb_account.res-76.name
  name                = "chat-history"
  resource_group_name = data.azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_cosmosdb_account.res-76,
  ]
}
resource "azurerm_cosmosdb_sql_container" "res-78" {
  account_name          = azurerm_cosmosdb_account.res-76.name
  database_name         = "chat-history"
  name                  = "chats"
  partition_key_paths   = ["/pk"]
  partition_key_version = 2
  resource_group_name   = data.azurerm_resource_group.res-0.name
  depends_on = [
    azurerm_cosmosdb_sql_database.res-77,
  ]
}

# Novo ambiente PROD
resource "azurerm_cosmosdb_account" "cdb-01" {
  name                             = "stp-dig-cdb-chatbot-prd"
  resource_group_name              = "stp-dig-rg-chatbot-prd"
  location                         = "brazilsouth"
  free_tier_enabled                = false
  multiple_write_locations_enabled = false
  minimal_tls_version              = "Tls12"
  public_network_access_enabled    = true
  ip_range_filter                  = "54.94.237.166/32,64.215.22.0/24,165.225.214.0/23,147.161.128.0/23,136.226.62.0/23,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"
  offer_type                       = "Standard"

  tags = {
    defaultExperience       = "Core (SQL)"
    hidden-cosmos-mmspecial = ""
    FRENTE                  = "CHATBOT"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    failover_priority = 0
    location          = "brazilsouth"
  }

}

resource "azurerm_cosmosdb_sql_database" "cdb-02" {
  account_name        = azurerm_cosmosdb_account.cdb-01.name
  name                = "chat-history"
  resource_group_name = "stp-dig-rg-chatbot-prd"

  depends_on = [
    azurerm_cosmosdb_account.cdb-01,
  ]
}

resource "azurerm_cosmosdb_sql_container" "cdb-03" {
  account_name          = azurerm_cosmosdb_account.cdb-01.name
  database_name         = azurerm_cosmosdb_sql_database.cdb-02.name
  resource_group_name   = "stp-dig-rg-chatbot-prd"
  name                  = "chats"
  partition_key_paths   = ["/pk"]
  partition_key_version = 2

  depends_on = [
    azurerm_cosmosdb_sql_database.cdb-02,
  ]
}

# Copiloto Atendimento PRD
resource "azurerm_cosmosdb_account" "cdb-04" {
  name                              = "stp-dig-cdb-copilot-prd"
  resource_group_name               = "stp-dig-rg-copilot-prd"
  location                          = "brazilsouth"
  free_tier_enabled                 = false
  multiple_write_locations_enabled  = false
  minimal_tls_version               = "Tls12"
  public_network_access_enabled     = true
  is_virtual_network_filter_enabled = true
  ip_range_filter                   = "54.94.237.166/32,64.215.22.0/24,165.225.214.0/23,147.161.128.0/23,136.226.62.0/23,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,13.88.56.148,40.91.218.243,13.91.105.215,4.210.172.107,0.0.0.0"
  offer_type                        = "Standard"

  virtual_network_rule {
    id                                   = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-app-02-prd"
    ignore_missing_vnet_service_endpoint = false
  }
  virtual_network_rule {
    id                                   = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-app-prd"
    ignore_missing_vnet_service_endpoint = false
  }
  virtual_network_rule {
    id                                   = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-web-prd"
    ignore_missing_vnet_service_endpoint = false
  }

  tags = {
    defaultExperience       = "Core (SQL)"
    hidden-cosmos-mmspecial = ""
    FRENTE                  = "COPILOTO ATENDIMENTO"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    failover_priority = 0
    location          = "brazilsouth"
  }

}

# Private endpoint

resource "azurerm_private_endpoint" "pep-01" {
  name                = "stp-dig-pep-cdb-1-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[2]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cdb-1-prd"
    private_connection_resource_id = azurerm_cosmosdb_account.cdb-01.id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}

resource "azurerm_private_endpoint" "pep-02" {
  name                = "stp-dig-pep-cdb-2-prd"
  resource_group_name = "stp-dig-rg-net-prd"
  location            = "brazilsouth"
  subnet_id           = data.terraform_remote_state.vnet.outputs.subnet_ids[2]

  tags = {
    FRENTE = "CHATBOT"
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-dig-pep-cdb-2-prd"
    private_connection_resource_id = azurerm_cosmosdb_account.cdb-04.id
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/privateDnsZones/privatelink.documents.azure.com"]
  }

}