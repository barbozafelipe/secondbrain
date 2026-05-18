locals {
  resource_group_name = "sbx-inf-net-rg"
}

module "vnet" {
  source = "../../MODULES/vnet"

  resource_group_name = local.resource_group_name
  vnet_name           = "sbx-inf-vnet-aks"
  vnet_address_space  = ["10.17.207.0/24"]

  subnets = [
    {
      name              = "sbx-inf-snet-aks-01"
      address_prefixes  = ["10.17.207.0/26"],
      service_endpoints = []
    }
  ]

  tags = {}
}

resource "azurerm_virtual_network_peering" "peer-01" {
  allow_forwarded_traffic   = true
  name                      = "sbx-inf-peer"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = local.resource_group_name
  use_remote_gateways       = true
  virtual_network_name      = module.vnet.vnet_name

  depends_on = [
    module.vnet
  ]
}