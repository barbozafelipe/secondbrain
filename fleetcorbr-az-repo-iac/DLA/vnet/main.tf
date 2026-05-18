locals {
  resource_group_name = "plt-dla-net-rg"
}

module "vnet" {
  source = "../../MODULES/vnet"

  resource_group_name = local.resource_group_name
  vnet_name           = "plt-dla-vnet"
  vnet_address_space  = ["10.17.208.0/22"]

  subnets = []

  tags = {
    FRENTE = "DLA"
  }
}

module "route_tables" {
  source = "../../MODULES/route_tables"

  route_table_name    = "plt-dla-rt-prd"
  resource_group_name = local.resource_group_name
  subnet_id           = []

  routes = [
    {
      name                   = "default-route"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.17.128.4"
    }
  ]

  tags = {
    FRENTE = "DLA"
  }

  depends_on = [module.vnet]
}

resource "azurerm_virtual_network_peering" "peer-01" {
  allow_forwarded_traffic   = true
  name                      = "plt-dla-peer-prd"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = local.resource_group_name
  use_remote_gateways       = true
  virtual_network_name      = module.vnet.vnet_name

  depends_on = [
    module.vnet
  ]
}