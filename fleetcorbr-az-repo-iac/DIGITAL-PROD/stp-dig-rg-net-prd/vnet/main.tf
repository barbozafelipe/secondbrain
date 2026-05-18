locals {
  resource_group_name = "stp-dig-rg-net-prd"
}

module "vnet" {
  source = "../../../MODULES/vnet"

  resource_group_name = local.resource_group_name
  vnet_name           = "stp-dig-vnet-prd"
  vnet_address_space  = ["10.17.205.0/24"]

  subnets = [
    {
      name             = "stp-dig-snet-web-prd"
      address_prefixes = ["10.17.205.0/27"],
      service_endpoints = [
        "Microsoft.Web",
        "Microsoft.Storage",
        "Microsoft.KeyVault",
        "Microsoft.Sql",
        "Microsoft.ServiceBus",
        "Microsoft.EventHub",
        "Microsoft.AzureActiveDirectory",
        "Microsoft.AzureCosmosDB"
      ]
    },
    {
      name             = "stp-dig-snet-app-prd"
      address_prefixes = ["10.17.205.32/27"]
      delegation = [{
        name = "Microsoft.Web.serverFarms"
        service_delegation = [{
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
          name    = "Microsoft.Web/serverFarms"
        }]
      }]
      service_endpoints = [
        "Microsoft.Web",
        "Microsoft.Storage",
        "Microsoft.AzureCosmosDB",
        "Microsoft.CognitiveServices"
      ]
    },
    {
      name             = "stp-dig-snet-ai-prd"
      address_prefixes = ["10.17.205.64/27"]
    },
    {
      name             = "stp-dig-snet-db-prd"
      address_prefixes = ["10.17.205.96/27"]
    },
    {
      name             = "stp-dig-snet-pep-prd"
      address_prefixes = ["10.17.205.128/27"]
    },
    {
      name             = "stp-dig-snet-psql-prd"
      address_prefixes = ["10.17.205.160/27"]
      delegation = [{
        name = "Microsoft.DBforPostgreSQL.flexibleServers"
        service_delegation = [{
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
        }]
      }]
    }
  ]

  tags = {
    FRENTE = "CHATBOT"
  }
}

module "route_tables" {
  source = "../../../MODULES/route_tables"

  route_table_name    = "stp-dig-rt-prd"
  resource_group_name = local.resource_group_name
  subnet_id = [
    "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-ai-prd",
    "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-app-prd",
    "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-db-prd",
    "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-pep-prd",
    "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-psql-prd"
  ]

  routes = [
    {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.17.128.4"
    },
    {
      name           = "rt-apim-service"
      address_prefix = "ApiManagement"
      next_hop_type  = "Internet"
    },
    {
      name           = "rt-apim-metrics"
      address_prefix = "AzureMonitor"
      next_hop_type  = "Internet"
    }
  ]

  tags = {
    FRENTE = "CHATBOT"
  }

  depends_on = [module.vnet]
}

resource "azurerm_virtual_network_peering" "peer-01" {
  allow_forwarded_traffic   = true
  name                      = "stp-dig-peer-prd"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = local.resource_group_name
  use_remote_gateways       = true
  virtual_network_name      = module.vnet.vnet_name

  depends_on = [
    module.vnet
  ]
}