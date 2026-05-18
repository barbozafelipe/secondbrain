data "terraform_remote_state" "route_tables" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "IDENTIDADE/route_tables/terraform.tfstate"
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


resource "azurerm_virtual_network" "res-6" {
  address_space       = ["10.17.184.0/24"]
  location            = "brazilsouth"
  name                = "vnet-az-shared"
  resource_group_name = "plt-idt-net-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "VNET"
  }
}
resource "azurerm_subnet" "res-7" {
  address_prefixes     = ["10.17.184.0/26"]
  name                 = "subnet-az-vm-shared"
  resource_group_name  = "plt-idt-net-rg"
  virtual_network_name = azurerm_virtual_network.res-6.name
  depends_on = [
    azurerm_virtual_network.res-6,
  ]
}
resource "azurerm_subnet_route_table_association" "res-8" {
  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.res-7.id
  depends_on = [
    azurerm_subnet.res-7,
  ]
}
resource "azurerm_virtual_network_peering" "res-9" {
  allow_forwarded_traffic   = true
  name                      = "plt-idt-peer"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = "plt-idt-net-rg"
  use_remote_gateways       = true
  virtual_network_name      = azurerm_virtual_network.res-6.name
  depends_on = [
    azurerm_virtual_network.res-6,
  ]
}
