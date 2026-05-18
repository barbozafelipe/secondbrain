locals {
  resource_group_name = "stp-dig-rg-net-lab"
}

module "vnet" {
  source = "../../MODULES/vnet"

  resource_group_name = local.resource_group_name
  vnet_name           = "stp-dig-vnet-lab"
  vnet_address_space  = ["10.17.212.0/24"]

  subnets = [
    {
      name             = "stp-dig-snet-web-lab"
      address_prefixes = ["10.17.212.0/27"],
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
      name             = "stp-dig-snet-app-lab"
      address_prefixes = ["10.17.212.32/27"]
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
      name             = "stp-dig-snet-ai-lab"
      address_prefixes = ["10.17.212.64/27"]
    },
    {
      name             = "stp-dig-snet-db-lab"
      address_prefixes = ["10.17.212.96/27"]
    },
    {
      name             = "stp-dig-snet-pep-lab"
      address_prefixes = ["10.17.212.128/27"]
    }
  ]
}

module "route_tables" {
  source = "../../MODULES/route_tables"

  route_table_name    = "stp-dig-rt-lab"
  resource_group_name = local.resource_group_name
  subnet_id           = module.vnet.subnet_ids

  routes = [
    {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.17.128.4"
    }
  ]
  depends_on = [module.vnet]
}

resource "azurerm_virtual_network_peering" "peer-01" {
  allow_forwarded_traffic   = true
  name                      = "stp-dig-peer-lab"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = local.resource_group_name
  use_remote_gateways       = true
  virtual_network_name      = module.vnet.vnet_name

  depends_on = [
    module.vnet
  ]
}