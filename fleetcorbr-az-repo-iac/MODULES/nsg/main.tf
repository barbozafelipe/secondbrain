resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                                       = security_rule.value.name
      description                                = lookup(security_rule.value, "description", null)
      priority                                   = lookup(security_rule.value, "priority", null)
      direction                                  = lookup(security_rule.value, "direction", null)
      access                                     = lookup(security_rule.value, "access", null)
      protocol                                   = lookup(security_rule.value, "protocol", null)
      source_port_range                          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges                         = lookup(security_rule.value, "source_port_ranges", [])
      destination_port_range                     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges                    = lookup(security_rule.value, "destination_port_ranges", [])
      source_address_prefix                      = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes                    = lookup(security_rule.value, "source_address_prefixes", [])
      destination_address_prefix                 = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes               = lookup(security_rule.value, "destination_address_prefixes", [])
      source_application_security_group_ids      = lookup(security_rule.value, "destination_address_prefixes", [])
      destination_application_security_group_ids = lookup(security_rule.value, "destination_address_prefixes", [])
    }
  }

  tags = var.tags
}