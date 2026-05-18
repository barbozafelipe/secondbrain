data "azurerm_resource_group" "rg" {
  name = "stp-dig-net-rg-nprd"
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "DIGITAL-NPROD/vnet/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

resource "azurerm_private_dns_zone" "priv-dns-0" {
  for_each            = toset(var.private_dns_zones)
  name                = each.key
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "priv-dns-link" {
  for_each = toset(var.private_dns_zones)

  name                  = "network-link-digital-nprod"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = each.key
  registration_enabled  = false
  virtual_network_id    = data.terraform_remote_state.vnet.outputs.vnet_id

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}
