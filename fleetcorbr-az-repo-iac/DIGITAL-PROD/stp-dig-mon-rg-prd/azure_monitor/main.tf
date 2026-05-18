data "azurerm_resource_group" "res-0" {
  name = "stp-dig-mon-rg-prd"
}

resource "azurerm_monitor_activity_log_alert" "alert_rules" {
  for_each = { for i, k in var.activity_log_alert : k.name => k }

  name                = each.key
  location            = data.azurerm_resource_group.res-0.location
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
    action_group_id = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.Insights/actiongroups/plt-mon-ag"
  }
}

resource "azurerm_monitor_metric_alert" "alert-0" {
  description         = "Low amount of requests on PROD enviroment."
  frequency           = "PT1H"
  name                = "AAHGPT3-PROD Low Requests"
  resource_group_name = data.azurerm_resource_group.res-0.name
  scopes              = ["/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/microsoft.insights/components/stp-dig-appi-gpt3-prd"]
  severity            = 0
  window_size         = "PT1H"
  action {
    action_group_id = "/subscriptions/B1BA0975-B0E9-4AA4-838A-CDB4B0C9E058/resourceGroups/stp-dig-rg-prd/providers/microsoft.insights/actionGroups/stp-dig-ag-gpt3"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "generate-completion Count"
    metric_namespace = "Azure.ApplicationInsights"
    operator         = "LessThanOrEqual"
    threshold        = 2
  }
}

resource "azurerm_monitor_alert_processing_rule_action_group" "alert-1" {
  add_action_group_ids = ["/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourcegroups/stp-dig-rg-prd/providers/microsoft.insights/actiongroups/stp-dig-ag-gpt3"]
  name                 = "stp-dig-alert-rule-prd"
  resource_group_name  = "stp-dig-rg-prd"
  scopes               = ["/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-prd/providers/microsoft.insights/components/stp-dig-appi-gpt3-prd"]
  schedule {
    effective_from = "2023-10-23T00:00:00"
    time_zone      = "E. South America Standard Time"
    recurrence {
      weekly {
        days_of_week = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        end_time     = "18:00:00"
        start_time   = "06:00:00"
      }
    }
  }
}

