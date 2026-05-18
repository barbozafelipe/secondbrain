# Cria storage account para uso da function
module "storage_account" {
  count  = var.create_storage_account == true ? 1 : 0
  source = "../storage_account"

  storage_account_name          = var.storage_account_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  public_network_access_enabled = var.storage_public_access_enabled
  network_rules                 = var.network_rules

  tags = var.tags
}

# Cria App service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

# Cria Application Insights
module "application_insights" {
  count  = var.create_application_insights == true ? 1 : 0
  source = "../application_insights"

  appi_name           = var.application_insights_name
  resource_group_name = var.resource_group_name
  location            = var.location
  retention_in_days   = 90
  sampling_percentage = 100
  workspace_id        = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"

  tags = var.tags
}

# Cria Azure Function
resource "azurerm_linux_function_app" "func" {
  name                = var.function_name
  resource_group_name = var.resource_group_name
  location            = var.location

  builtin_logging_enabled       = var.builtin_logging_enabled
  client_certificate_mode       = var.client_certificate_mode
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id

  service_plan_id            = azurerm_service_plan.asp.id
  storage_account_name       = var.create_storage_account == true ? module.storage_account[0].storage_account_name : var.storage_account_name
  storage_account_access_key = var.create_storage_account == true ? module.storage_account[0].storage_account_key : var.storage_account_access_key

  app_settings = var.app_settings

  tags = var.tags

  dynamic "site_config" {
    for_each = [var.site_config]

    content {
      always_on                              = lookup(site_config.value, "always_on", true)
      api_management_api_id                  = lookup(site_config.value, "api_management_api_id", null)
      application_insights_connection_string = lookup(site_config.value, "application_insights_connection_string", var.create_application_insights == true ? module.application_insights[0].application_insights_connection_string : 0)
      application_insights_key               = lookup(site_config.value, "application_insights_key", var.create_application_insights == true ? module.application_insights[0].application_insights_instrumentation_key : 0)
      ftps_state                             = lookup(site_config.value, "ftps_state", "FtpsOnly")
      http2_enabled                          = lookup(site_config.value, "http2_enabled", true)
      ip_restriction_default_action          = lookup(site_config.value, "ip_restriction_default_action", "Allow")
      scm_ip_restriction_default_action      = lookup(site_config.value, "scm_ip_restriction_default_action", "Allow")
      minimum_tls_version                    = lookup(site_config.value, "minimum_tls_version", "1.2")

      dynamic "app_service_logs" {
        for_each = lookup(site_config.value, "app_service_logs", null) != null ? [lookup(site_config.value, "app_service_logs", null)] : []
        content {
          disk_quota_mb         = lookup(app_service_logs.value, "disk_quota_mb", 35)
          retention_period_days = lookup(app_service_logs.value, "retention_period_days", 0)
        }
      }

      dynamic "application_stack" {
        for_each = site_config.value.application_stack
        content {
          python_version = lookup(site_config.value.application_stack, "python_version", null)
        }
      }

      dynamic "cors" {
        for_each = site_config.value.cors
        content {
          allowed_origins     = lookup(site_config.value.cors, "allowed_origins", ["*"])
          support_credentials = lookup(site_config.value.cors, "support_credentials", false)
        }
      }

      dynamic "ip_restriction" {
        for_each = lookup(site_config.value, "ip_restriction", {})
        content {
          name                      = lookup(ip_restriction.value, "name", null)
          ip_address                = lookup(ip_restriction.value, "ip_address", null)
          virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
          service_tag               = lookup(ip_restriction.value, "service_tag", null)
          priority                  = lookup(ip_restriction.value, "priority", null)
          action                    = lookup(ip_restriction.value, "action", null)
          headers                   = lookup(ip_restriction.value, "headers", [])
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = lookup(site_config.value, "scm_ip_restriction", {})
        content {
          name                      = lookup(scm_ip_restriction.value, "name", null)
          ip_address                = lookup(scm_ip_restriction.value, "ip_address", null)
          virtual_network_subnet_id = lookup(scm_ip_restriction.value, "virtual_network_subnet_id", null)
          service_tag               = lookup(scm_ip_restriction.value, "service_tag", null)
          priority                  = lookup(scm_ip_restriction.value, "priority", null)
          action                    = lookup(scm_ip_restriction.value, "action", null)
          headers                   = lookup(scm_ip_restriction.value, "headers", [])
        }
      }
    }
  }

  lifecycle {
    create_before_destroy = false
    ignore_changes = [
      app_settings,
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }

  depends_on = [
    azurerm_service_plan.asp,
    module.storage_account
  ]
}
