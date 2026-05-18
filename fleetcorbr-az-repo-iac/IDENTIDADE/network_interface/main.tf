data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "IDENTIDADE/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

data "terraform_remote_state" "nsg" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "IDENTIDADE/nsg/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_network_interface" "res-5" {
  location            = "brazilsouth"
  name                = "azrdt1-svacdp01555"
  resource_group_name = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id
  }
}
resource "azurerm_network_interface_security_group_association" "res-6" {
  network_interface_id      = azurerm_network_interface.res-5.id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id
  depends_on = [
    azurerm_network_interface.res-5,
  ]
}
resource "azurerm_network_interface" "res-7" {
  location            = "brazilsouth"
  name                = "azrdt1-svacdp02836"
  resource_group_name = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id
  }
}
resource "azurerm_network_interface_security_group_association" "res-8" {
  network_interface_id      = azurerm_network_interface.res-7.id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id
  depends_on = [
    azurerm_network_interface.res-7,
  ]
}
resource "azurerm_network_interface" "res-9" {
  location            = "brazilsouth"
  name                = "azrdt1-svacdp03783"
  resource_group_name = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id
  }
}
resource "azurerm_network_interface_security_group_association" "res-10" {
  network_interface_id      = azurerm_network_interface.res-9.id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id
  depends_on = [
    azurerm_network_interface.res-9,
  ]
}
