data "terraform_remote_state" "network_interface" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "IDENTIDADE/network_interfaces/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_virtual_machine" "res-1" {
  location              = "brazilsouth"
  name                  = "AZRDT1-SVACDP01"
  network_interface_ids = [data.terraform_remote_state.network_interface.outputs.network_interface_id_res-5]
  resource_group_name   = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  vm_size = "Standard_D2ls_v5"
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    create_option = "Attach"
    name          = "AZRDT1-SVACDP01_OsDisk_1_babac9e7c6be49a29c2e37180965c3e3"
  }
}

resource "azurerm_virtual_machine_extension" "res-2" {
  auto_upgrade_minor_version = true
  name                       = "enablevmaccess"
  publisher                  = "Microsoft.Compute"
  settings                   = "{\"UserName\":\"adminuser\"}"
  type                       = "VMAccessAgent"
  type_handler_version       = "2.0"
  virtual_machine_id         = azurerm_virtual_machine.res-1.id
  depends_on = [
    azurerm_virtual_machine.res-1,
  ]
}

resource "azurerm_virtual_machine" "res-3" {
  location              = "brazilsouth"
  name                  = "AZRDT1-SVACDP02"
  network_interface_ids = [data.terraform_remote_state.network_interface.outputs.network_interface_id_res-7]
  resource_group_name   = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  vm_size = "Standard_D2ls_v5"
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    create_option = "Attach"
    name          = "AZRDT1-SVACDP02_OsDisk_1_04fc516d1350438b8fc2e45e06084dda"
  }
}

resource "azurerm_virtual_machine" "res-4" {
  location              = "brazilsouth"
  name                  = "AZRDT1-SVACDP03"
  network_interface_ids = [data.terraform_remote_state.network_interface.outputs.network_interface_id_res-9]
  resource_group_name   = "plt-idt-rg"
  tags = {
    AMBIENTE   = "SHARED"
    TECNOLOGIA = "Virtual Machine"
  }
  vm_size = "Standard_D2ls_v5"
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
  storage_os_disk {
    create_option = "Attach"
    name          = "AZRDT1-SVACDP03_OsDisk_1_a5adf4d6bcb540e98d29968ff9646998"
  }
}
