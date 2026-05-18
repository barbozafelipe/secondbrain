module "container_app_env" {
  source = "../../MODULES/container_apps_env"

  container_app_env_name     = "stp-dig-cae-aihub-hml-nprd"
  location                   = module.rg.resource_group_location
  resource_group_name        = module.rg.resource_group_name
  log_analytics_workspace_id = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"
}

module "container_app_mcp" {
  source = "../../MODULES/container_apps"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location

  container_app_name   = "stp-dig-ca-gptappmcp-hml-nprd"
  container_app_env_id = module.container_app_env.id
  registry_endpoint    = module.acr.acr_endpoint

  template = {
    name         = "stp-dig-ca-gptappmcp-hml-nprd"
    image        = "mcr.microsoft.com/k8se/quickstart:latest"
    cpu          = 0.5
    memory       = "1Gi"
    min_replicas = 1
    max_replicas = 3
  }

  # environment = {
  #   "VAR1" = {
  #     value = "value1"
  #   }
  # }


  enable_ingress = true
  ingress = {
    external_enabled = false
    target_port      = 8000
  }

}