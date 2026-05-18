resource "azurerm_monitor_activity_log_alert" "alert_rules" {
  for_each = { for i, k in var.activity_log_alert : k.name => k }

  name                = each.key
  resource_group_name = "spe-spe-mon-rg-nprd"
  scopes              = var.subscription_list
  description         = each.value.description

  dynamic "criteria" {
    for_each = each.value.criteria

    content {
      operation_name = criteria.value.operation_name
      category       = criteria.value.category
    }

  }

}
