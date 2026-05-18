resource "azurerm_private_endpoint" "pep-0" {
  name                          = "stp-cpp-pep-share-01-prd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-cpp-pep-share-01-prd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_id
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-cpp-pep-share-01-prd"
    private_connection_resource_id = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/STP-CPP-RG-PRD/providers/Microsoft.Storage/storageAccounts/stpcppstprd"
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"]
  }

}
