module "nsg" {
  source = "../../MODULES/nsg"

  nsg_name            = "stp-dig-nsg-prd"
  resource_group_name = "stp-dig-rg-net-prd"

  security_rules = [
    {
      name                       = "AllowHttpsAPIManagement"
      description                = "Allow inbound access to Api Management"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 110
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "443"
    },
    {
      name                       = "AllowAPIManagementEndpoint"
      access                     = "Allow"
      direction                  = "Inbound"
      priority                   = 120
      protocol                   = "Tcp"
      source_address_prefix      = "ApiManagement"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "3443"
    },
    {
      name                       = "AllowOutboundAccess"
      description                = "Allow outbound access"
      access                     = "Allow"
      direction                  = "Outbound"
      priority                   = 130
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    }
  ]
}