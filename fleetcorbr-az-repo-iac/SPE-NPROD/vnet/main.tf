data "terraform_remote_state" "route_tables" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/route_tables/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

data "terraform_remote_state" "vnet_hub" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "NETWORK/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}


resource "azurerm_virtual_network" "res-0" {
  address_space       = ["10.17.200.0/22"]
  location            = "brazilsouth"
  name                = "spe-spe-vnet-nprd"
  resource_group_name = "spe-spe-net-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "VNET"
  }
}
resource "azurerm_subnet" "res-1" {
  address_prefixes     = ["10.17.200.0/26"]
  name                 = "spe-spe-snet-plan-01-nprd"
  resource_group_name  = "spe-spe-net-rg-nprd"
  virtual_network_name = azurerm_virtual_network.res-0.name
  depends_on = [
    azurerm_virtual_network.res-0,
  ]
  delegation {
    name = "Microsoft.Web/serverFarms"
    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet_route_table_association" "res-2" {
  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.res-1.id
  depends_on = [
    azurerm_subnet.res-1,
  ]
}

resource "azurerm_virtual_network_peering" "res-3" {
  allow_forwarded_traffic   = true
  name                      = "spe-spe-peer-nprd"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = "spe-spe-net-rg-nprd"
  use_remote_gateways       = true
  virtual_network_name      = azurerm_virtual_network.res-0.name
  depends_on = [
    azurerm_virtual_network.res-0,
  ]
}

resource "azurerm_subnet" "res-4" {
  address_prefixes     = ["10.17.200.64/26"]
  name                 = "spe-spe-snet-db-nprd"
  resource_group_name  = "spe-spe-net-rg-nprd"
  virtual_network_name = azurerm_virtual_network.res-0.name
  depends_on = [
    azurerm_virtual_network.res-0,
  ]
  delegation {
    name = "managedinstancedelegation"

    service_delegation {
      name = "Microsoft.Sql/managedInstances"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
      ]
    }
  }
}

resource "azurerm_subnet_route_table_association" "res-5" {
  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.res-4.id
  depends_on = [
    azurerm_subnet.res-4,
  ]
}


resource "azurerm_subnet" "res-6" {
  address_prefixes     = ["10.17.200.128/26"]
  name                 = "spe-spe-snet-app-nprd"
  resource_group_name  = "spe-spe-net-rg-nprd"
  virtual_network_name = azurerm_virtual_network.res-0.name
  depends_on = [
    azurerm_virtual_network.res-0,
  ]
}

resource "azurerm_subnet_route_table_association" "res-7" {
  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.res-6.id
  depends_on = [
    azurerm_subnet.res-6,
  ]
}

resource "azurerm_subnet" "res-8" {
  address_prefixes     = ["10.17.202.0/23"]
  name                 = "spe-spe-snet-aks-nprd"
  resource_group_name  = "spe-spe-net-rg-nprd"
  virtual_network_name = azurerm_virtual_network.res-0.name
  depends_on = [
    azurerm_virtual_network.res-0,
  ]
}

resource "azurerm_subnet_route_table_association" "res-9" {
  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.res-8.id
  depends_on = [
    azurerm_subnet.res-8,
  ]
}