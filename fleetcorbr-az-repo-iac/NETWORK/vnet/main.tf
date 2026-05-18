resource "azurerm_virtual_network" "res-17" {
  address_space       = ["10.17.128.0/24"]
  location            = "brazilsouth"
  name                = "plt-net-vnet"
  resource_group_name = "plt-net-rg"
}
resource "azurerm_subnet" "res-18" {
  address_prefixes     = ["10.17.128.0/26"]
  name                 = "AzureFirewallSubnet"
  resource_group_name  = "plt-net-rg"
  virtual_network_name = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}
resource "azurerm_subnet" "res-19" {
  address_prefixes     = ["10.17.128.96/27"]
  name                 = "GatewaySubnet"
  resource_group_name  = "plt-net-rg"
  virtual_network_name = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}
resource "azurerm_subnet_route_table_association" "res-20" {
  route_table_id = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/routeTables/plt-net-rt-firewall"
  subnet_id      = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/virtualNetworks/plt-net-vnet/subnets/GatewaySubnet"
  depends_on = [
    azurerm_subnet.res-19,
  ]
}
resource "azurerm_subnet" "res-21" {
  address_prefixes     = ["10.17.128.64/27"]
  name                 = "plt-net-snet-vgw"
  resource_group_name  = "plt-net-rg"
  virtual_network_name = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}


resource "azurerm_virtual_network_gateway" "res-24" {
  location            = "brazilsouth"
  name                = "plt-net-snet-vgw"
  resource_group_name = "plt-net-rg"
  sku                 = "ErGw1AZ"
  type                = "ExpressRoute"
  vpn_type            = "PolicyBased"
  ip_configuration {
    name                 = "default"
    public_ip_address_id = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/publicIPAddresses/plt-net-pip-erc"
    subnet_id            = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/virtualNetworks/plt-net-vnet/subnets/GatewaySubnet"
  }
  depends_on = [
    # One of azurerm_subnet.res-19,azurerm_subnet_route_table_association.res-20 (can't auto-resolve as their ids are identical)
  ]
}

resource "azurerm_virtual_network_peering" "res-22" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-idt"
  remote_virtual_network_id = "/subscriptions/8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9/resourceGroups/plt-idt-net-rg/providers/Microsoft.Network/virtualNetworks/vnet-az-shared"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}
resource "azurerm_virtual_network_peering" "res-23" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-stp-cpp-prd"
  remote_virtual_network_id = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-cpp-vnet-prd"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-25" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-spe-spe-nprod"
  remote_virtual_network_id = "/subscriptions/936b1a91-dba6-4205-a0c5-c8e4fdf3465e/resourceGroups/spe-spe-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/spe-spe-vnet-nprd"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-26" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-stp-dig-nprd"
  remote_virtual_network_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-nprd"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-27" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-stp-abastece-nprd"
  remote_virtual_network_id = "/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-abastece-nprd"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-28" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-stp-dig-prd"
  remote_virtual_network_id = "/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-29" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-sbx-inf"
  remote_virtual_network_id = "/subscriptions/cf11926c-96d3-41ab-83d7-1682fb067086/resourceGroups/sbx-inf-net-rg/providers/Microsoft.Network/virtualNetworks/sbx-inf-vnet-aks"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-30" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-dla"
  remote_virtual_network_id = "/subscriptions/6a4300d6-fc9d-41a5-86ae-123f772cfdf4/resourceGroups/plt-dla-net-rg/providers/Microsoft.Network/virtualNetworks/plt-dla-vnet"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}

resource "azurerm_virtual_network_peering" "res-31" {
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
  name                      = "plt-net-peer-dig-lab"
  remote_virtual_network_id = "/subscriptions/9fc62d46-7c68-4608-82a3-d712a8aab92e/resourceGroups/stp-dig-rg-net-lab/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-lab"
  resource_group_name       = "plt-net-rg"
  virtual_network_name      = "plt-net-vnet"
  depends_on = [
    azurerm_virtual_network.res-17,
  ]
}