resource "azurerm_private_dns_zone" "res-3" {
  name                = "prd.oke.fleetcor.com.br"
  resource_group_name = "stp-cpp-rg-net-prd"

  depends_on = [
  ]
}
resource "azurerm_private_dns_a_record" "res-4" {
  name                = "*"
  records             = ["10.17.64.155"]
  resource_group_name = "stp-cpp-rg-net-prd"
  ttl                 = 3600
  zone_name           = "prd.oke.fleetcor.com.br"

  depends_on = [
    azurerm_private_dns_zone.res-3,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-6" {
  name                  = "stp-cpp-vnet-prd"
  private_dns_zone_name = "prd.oke.fleetcor.com.br"
  resource_group_name   = "stp-cpp-rg-net-prd"
  virtual_network_id    = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-cpp-vnet-prd"

  depends_on = [
    azurerm_private_dns_zone.res-3,
  ]
}
resource "azurerm_private_dns_zone" "res-7" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = "stp-cpp-rg-net-prd"

  depends_on = [
  ]
}
resource "azurerm_private_dns_a_record" "res-8" {
  name                = "stpcppstprd"
  records             = ["10.17.130.6"]
  resource_group_name = "stp-cpp-rg-net-prd"

  tags = {
    creator = "created by private endpoint stp-cpp-pep-share-01-prd with resource guid 63580c22-2950-452a-97f3-f28528267d56"
  }

  ttl       = 10
  zone_name = "privatelink.file.core.windows.net"

  depends_on = [
    azurerm_private_dns_zone.res-7,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-10" {
  name                  = "ez4rpauuqxxz2"
  private_dns_zone_name = "privatelink.file.core.windows.net"
  resource_group_name   = "stp-cpp-rg-net-prd"
  virtual_network_id    = "/subscriptions/01aae3e3-0cf0-4469-8435-ccf74c814ad8/resourceGroups/stp-cpp-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-cpp-vnet-prd"

  depends_on = [
    azurerm_private_dns_zone.res-7,
  ]
}
