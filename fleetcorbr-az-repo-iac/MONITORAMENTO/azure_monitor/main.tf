data "azurerm_resource_group" "res-0" {
  name = "plt-mon-rg"
}

resource "azurerm_monitor_action_group" "action_group" {
  name                = "plt-mon-ag"
  resource_group_name = data.azurerm_resource_group.res-0.name
  short_name          = "plt-mon-ag"

  arm_role_receiver {
    name                    = "Monitoring Contributor"
    role_id                 = "749f88d5-cbae-40b8-bcfc-e573ddc772fa"
    use_common_alert_schema = true
  }
  arm_role_receiver {
    name                    = "Monitoring Reader"
    role_id                 = "43d0d8ad-25c7-4714-9337-8ba259a9fe05"
    use_common_alert_schema = true
  }

  depends_on = [
    data.azurerm_resource_group.res-0,
  ]
}

resource "azurerm_monitor_activity_log_alert" "alert_rules" {
  for_each = { for i, k in var.activity_log_alert : k.name => k }

  name                = each.key
  resource_group_name = data.azurerm_resource_group.res-0.name
  scopes              = var.subscription_list
  description         = each.value.description

  dynamic "criteria" {
    for_each = each.value.criteria

    content {
      operation_name = criteria.value.operation_name
      category       = criteria.value.category
    }

  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}
