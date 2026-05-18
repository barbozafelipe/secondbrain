data "terraform_remote_state" "monitoramento" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "MONITORAMENTO/log_analytics_workspace/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

resource "azurerm_application_insights" "appi" {
  name                = var.appi_name
  resource_group_name = var.resource_group_name
  location            = var.location

  application_type    = var.application_type
  sampling_percentage = var.sampling_percentage
  retention_in_days   = var.retention_in_days
  workspace_id        = var.workspace_id

  tags = var.tags
}