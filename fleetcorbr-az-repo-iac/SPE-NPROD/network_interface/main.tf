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

data "terraform_remote_state" "nsg" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/nsg/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_network_interface" "res-0" {
  location            = "brazilsouth"
  name                = "spe-spe-nic-aut-01-nprd"
  resource_group_name = "spe-spe-app-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "Virtual Machine"
  }
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.17.200.134"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_app_id
  }
}
resource "azurerm_network_interface_security_group_association" "res-1" {
  network_interface_id      = azurerm_network_interface.res-0.id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id
  depends_on = [
    azurerm_network_interface.res-0,
  ]
}
resource "azurerm_network_interface" "res-2" {
  location            = "brazilsouth"
  name                = "spe-spe-nic-aut-02-nprd"
  resource_group_name = "spe-spe-app-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "Virtual Machine"
  }
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.17.200.135"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_app_id
  }
}
resource "azurerm_network_interface_security_group_association" "res-8" {
  network_interface_id      = azurerm_network_interface.res-2.id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id
  depends_on = [
    azurerm_network_interface.res-2,
  ]
}

