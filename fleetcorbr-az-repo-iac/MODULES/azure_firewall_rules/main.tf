data "terraform_remote_state" "azure_firewall" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "NETWORK/azure_firewall/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "rule_collection_group" {
  for_each = var.rule_collection_group

  firewall_policy_id = var.firewall_policy_id
  name               = each.key
  priority           = each.value["priority"]

  dynamic "application_rule_collection" {
    for_each = each.value["application_rule_collections"]

    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules

        content {
          name = rule.value.name
          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
          source_addresses      = lookup(rule.value, "source_addresses", null)
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
          destination_addresses = lookup(rule.value, "destination_addresses", null)
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null)
          destination_fqdn_tags = lookup(rule.value, "destination_fqdn_tags", null)
          destination_urls      = lookup(rule.value, "destination_urls", null)
          terminate_tls         = lookup(rule.value, "terminate_tls", null)
          web_categories        = lookup(rule.value, "web_categories", null)
        }
      }
    }
  }

  dynamic "network_rule_collection" {
    for_each = each.value["network_rule_collections"]

    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules

        content {
          name                  = rule.value.name
          protocols             = lookup(rule.value, "protocols", null)
          source_addresses      = lookup(rule.value, "source_addresses", null)
          source_ip_groups      = lookup(rule.value, "source_ip_groups", null)
          destination_addresses = lookup(rule.value, "destination_addresses", null)
          destination_fqdns     = lookup(rule.value, "destination_fqdns", null)
          destination_ip_groups = lookup(rule.value, "destination_ip_groups", null)
          destination_ports     = lookup(rule.value, "destination_ports", null)

        }
      }
    }
  }

  dynamic "nat_rule_collection" {
    for_each = each.value["nat_rule_collections"]

    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules

        content {
          name                = rule.value.name
          protocols           = lookup(rule.value, "protocols", null)
          source_addresses    = lookup(rule.value, "source_addresses", null)
          source_ip_groups    = lookup(rule.value, "source_ip_groups", null)
          destination_address = lookup(rule.value, "destination_address", null)
          destination_ports   = lookup(rule.value, "destination_ports", null)
          translated_address  = lookup(rule.value, "translated_address", null)
          translated_fqdn     = lookup(rule.value, "translated_fqdn", null)
          translated_port     = lookup(rule.value, "translated_port", null)
        }
      }
    }
  }
}  