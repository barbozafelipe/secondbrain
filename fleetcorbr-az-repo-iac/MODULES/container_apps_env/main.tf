resource "azurerm_container_app_environment" "env" {
  name                       = var.container_app_env_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id

  identity {
    type = var.identity_type
  }
}
