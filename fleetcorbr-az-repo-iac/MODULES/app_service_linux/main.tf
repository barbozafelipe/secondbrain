resource "azurerm_service_plan" "asp" {
  count = var.create_app_service_plan == true ? 1 : 0

  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  client_certificate_mode       = var.client_certificate_mode
  https_only                    = var.https_only
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  service_plan_id               = var.create_app_service_plan == true ? azurerm_service_plan.asp[0].id : var.service_plan_id

  app_settings = var.app_settings

  tags = var.tags

  dynamic "site_config" {
    for_each = [var.site_config]

    content {
      app_command_line                  = lookup(site_config.value, "app_command_line", null)
      always_on                         = lookup(site_config.value, "always_on", true)
      api_management_api_id             = lookup(site_config.value, "api_management_api_id", null)
      ftps_state                        = lookup(site_config.value, "ftps_state", "FtpsOnly")
      http2_enabled                     = lookup(site_config.value, "http2_enabled", true)
      minimum_tls_version               = lookup(site_config.value, "minimum_tls_version", "1.2")
      ip_restriction_default_action     = lookup(site_config.value, "ip_restriction_default_action", "Allow")
      scm_ip_restriction_default_action = lookup(site_config.value, "scm_ip_restriction_default_action", "Allow")
      scm_use_main_ip_restriction       = lookup(site_config.value, "scm_use_main_ip_restriction", true)

      application_stack {
          docker_image_name        = lookup(site_config.value.application_stack, "docker_image_name", null)
          docker_registry_url      = lookup(site_config.value.application_stack, "docker_registry_url", null)
          docker_registry_username = lookup(site_config.value.application_stack, "docker_registry_username", null)
          docker_registry_password = lookup(site_config.value.application_stack, "docker_registry_password", null)
          node_version             = lookup(site_config.value.application_stack, "node_version", null)
          python_version           = lookup(site_config.value.application_stack, "python_version", null)
      }

      # dynamic "application_stack" {
      #   for_each = site_config.value.application_stack
      #   content {
      #     docker_image_name        = lookup(site_config.value.application_stack, "docker_image_name", null)
      #     docker_registry_url      = lookup(site_config.value.application_stack, "docker_registry_url", null)
      #     docker_registry_username = lookup(site_config.value.application_stack, "docker_registry_username", null)
      #     docker_registry_password = lookup(site_config.value.application_stack, "docker_registry_password", null)
      #     node_version             = lookup(site_config.value.application_stack, "node_version", null)
      #     python_version           = lookup(site_config.value.application_stack, "python_version", null)
      #   }
      # }

      dynamic "cors" {
        for_each = site_config.value.cors != null ? [site_config.value.cors] : []
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
          priority                  = lookup(ip_restriction.value, "priority", 300)
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
    ignore_changes = [
      app_settings,
      sticky_settings,
      site_config[0].application_stack[0].docker_image_name,
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"],
    ]
  }

  depends_on = [
    azurerm_service_plan.asp,
  ]
}
