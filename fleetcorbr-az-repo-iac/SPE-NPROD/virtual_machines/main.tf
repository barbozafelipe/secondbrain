data "terraform_remote_state" "network_interface" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/network_interfaces/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_virtual_machine" "res-0" {
  location              = "brazilsouth"
  name                  = "spe-spe-vm-aut-01-nprd"
  network_interface_ids = [data.terraform_remote_state.network_interface.outputs.network_interface_id_res-0]
  resource_group_name   = "spe-spe-app-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "Virtual Machine"
  }
  vm_size = "Standard_B2ms"

  storage_os_disk {
    name              = "spe-spe-osdisk-aut-01-nprd"
    caching           = "ReadWrite"
    managed_disk_type = "Premium_LRS"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "vm-aut-01-nprd"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
    timezone = "E. South America Standard Time"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }
}

resource "azurerm_virtual_machine" "res-1" {
  location              = "brazilsouth"
  name                  = "spe-spe-vm-aut-02-nprd"
  network_interface_ids = [data.terraform_remote_state.network_interface.outputs.network_interface_id_res-2]
  resource_group_name   = "spe-spe-app-rg-nprd"
  tags = {
    AMBIENTE   = "SPE-NPROD"
    TECNOLOGIA = "Virtual Machine"
  }
  vm_size = "Standard_B2ms"

  storage_os_disk {
    name              = "spe-spe-osdisk-aut-02-nprd"
    caching           = "ReadWrite"
    managed_disk_type = "Premium_LRS"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "vm-aut-02-nprd"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_windows_config {
    timezone = "E. South America Standard Time"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = ""
  }

}