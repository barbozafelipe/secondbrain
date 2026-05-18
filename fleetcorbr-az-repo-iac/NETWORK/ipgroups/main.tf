resource "azurerm_ip_group" "res-11" {
  for_each = var.ip_groups

  name                = each.key
  resource_group_name = "plt-net-rg"
  location            = "brazilsouth"

  cidrs = each.value["cidrs"]
}

