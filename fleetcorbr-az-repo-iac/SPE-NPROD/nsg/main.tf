data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}


resource "azurerm_network_security_group" "res-0" {
  location            = "brazilsouth"
  name                = "spe-spe-nsg-nprd"
  resource_group_name = "spe-spe-net-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "Network Security Group"
  }
}

resource "azurerm_network_security_rule" "allow_management_inbound" {
  name                        = "allow_management_inbound"
  priority                    = 106
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["9000", "9003", "1438", "1440", "1452"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_network_security_rule" "allow_misubnet_inbound" {
  name                        = "allow_misubnet_inbound"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.17.200.0/27"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_network_security_rule" "allow_health_probe_inbound" {
  name                        = "allow_health_probe_inbound"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_network_security_rule" "allow_tds_inbound" {
  name                        = "allow_tds_inbound"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_network_security_rule" "allow_management_outbound" {
  name                        = "allow_management_outbound"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = ["80", "443", "12000"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_network_security_rule" "allow_misubnet_outbound" {
  name                        = "allow_misubnet_outbound"
  priority                    = 200
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "10.17.200.0/27"
  destination_address_prefix  = "*"
  resource_group_name         = "spe-spe-net-rg-nprd"
  network_security_group_name = azurerm_network_security_group.res-0.name
}

resource "azurerm_subnet_network_security_group_association" "sub-ass-db" {
  subnet_id                 = data.terraform_remote_state.vnet.outputs.subnet_db_id
  network_security_group_id = azurerm_network_security_group.res-0.id
}

resource "azurerm_subnet_network_security_group_association" "sub-ass-app" {
  subnet_id                 = data.terraform_remote_state.vnet.outputs.subnet_app_id
  network_security_group_id = azurerm_network_security_group.res-0.id
}
