data "azurerm_resource_group" "rg" {
  name = "spe-spe-net-rg-nprd"
}

data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/vnet/terraform.tfstate"
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

  name                  = "network-link-spe-nprod"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = each.key
  registration_enabled  = false
  virtual_network_id    = data.terraform_remote_state.vnet.outputs.vnet_id

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

# DNS records
resource "azurerm_private_dns_a_record" "dns-0" {
  name                = "*"
  records             = ["10.17.203.254"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "apps.aks-nprd.fleetcor.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-1" {
  name                = "appbssuat"
  records             = ["10.0.192.116"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "viafacil.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-2" {
  name                = "bredt1-svaplh10"
  records             = ["10.0.201.75"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "dtc.brflt.corp"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-3" {
  name                = "bredt1-svacdp10"
  records             = ["10.0.180.25"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "dtc.brflt.corp"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-4" {
  name                = "smtp"
  records             = ["10.0.169.22"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "dbtrans.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-5" {
  name                = "*.dev"
  records             = ["10.0.192.185"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "ocp.fleetcor.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-6" {
  name                = "*.pprd"
  records             = ["10.0.192.186"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "ocp.fleetcor.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}

resource "azurerm_private_dns_a_record" "dns-7" {
  name                = "*.qa"
  records             = ["10.0.192.186"]
  resource_group_name = data.azurerm_resource_group.rg.name

  ttl       = 3600
  zone_name = "ocp.fleetcor.com.br"

  depends_on = [
    azurerm_private_dns_zone.priv-dns-0
  ]
}