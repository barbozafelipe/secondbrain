resource "azurerm_monitor_activity_log_alert" "alert_rules" {
  for_each = { for i, k in var.activity_log_alert : k.name => k }

  name                = each.key
  resource_group_name = var.resource_group_name
  scopes              = var.subscription_id
  description         = each.value.description

  dynamic "criteria" {
    for_each = each.value.criteria

    content {
      operation_name = criteria.value.operation_name
      category       = criteria.value.category
    }

  }

  action {
    action_group_id = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.Insights/actiongroups/plt-mon-ag"
  }
}
