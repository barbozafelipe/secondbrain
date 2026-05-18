module "appi_gptappmcp" {
  source = "../../MODULES/application_insights"

  appi_name           = "stp-dig-appi-gptappmcp-nprd"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  retention_in_days   = 90
  sampling_percentage = 100
  workspace_id        = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"
}

module "appi_aihub" {
  source = "../../MODULES/application_insights"

  appi_name           = "stp-dig-appi-aihub-nprd"
  resource_group_name = module.rg.resource_group_name
  location            = module.rg.resource_group_location
  retention_in_days   = 90
  sampling_percentage = 100
  workspace_id        = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"
}