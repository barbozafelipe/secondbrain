resource "azurerm_private_endpoint" "pep-0" {
  name                          = "stp-stp-pep-kv-1-nprd"
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  custom_network_interface_name = "stp-dig-pep-kv-1-nprd-nic"
  subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_app_id
  tags                          = {}

  private_service_connection {
    is_manual_connection           = false
    name                           = "stp-stp-pep-kv-1-nprd"
    private_connection_resource_id = "/subscriptions/936b1a91-dba6-4205-a0c5-c8e4fdf3465e/resourceGroups/spe-spe-app-rg-nprd/providers/Microsoft.KeyVault/vaults/spe-spe-kv-nprd"
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/936b1a91-dba6-4205-a0c5-c8e4fdf3465e/resourceGroups/spe-spe-net-rg-nprd/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]

  }

}