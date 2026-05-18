resource "azurerm_firewall_policy" "res-9" {
  location            = "brazilsouth"
  name                = "plt-net-2-afwp"
  resource_group_name = "plt-net-rg"

  sku = "Premium"

  dns {
    proxy_enabled = true
    #servers       = []
  }

}

resource "azurerm_firewall_policy" "res-5" {
  location            = "brazilsouth"
  name                = "plt-net-1-afwp"
  resource_group_name = "plt-net-rg"
}

resource "azurerm_firewall_policy_rule_collection_group" "res-6" {
  firewall_policy_id = azurerm_firewall_policy.res-5.id
  name               = "DefaultApplicationRuleCollectionGroup"
  priority           = 300
  depends_on = [
    azurerm_firewall_policy.res-5,
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "res-7" {
  firewall_policy_id = azurerm_firewall_policy.res-5.id
  name               = "DefaultDnatRuleCollectionGroup"
  priority           = 100
  depends_on = [
    azurerm_firewall_policy.res-5,
  ]
}

resource "azurerm_firewall_policy_rule_collection_group" "res-8" {

  firewall_policy_id = azurerm_firewall_policy.res-9.id
  name               = "DefaultNetworkRuleCollectionGroup"
  priority           = 200

  dynamic "network_rule_collection" {
    for_each = var.network_rule_collections

    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
          source_addresses      = lookup(rule.value, "source_addresses", null)
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
          destination_addresses = lookup(rule.value, "destination_addresses", null)
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null)
          destination_ports     = lookup(rule.value, "destination_ports", null)
          protocols             = lookup(rule.value, "protocols", null)
        }
      }
    }
  }
  depends_on = [
    azurerm_firewall_policy.res-9,
  ]
}
