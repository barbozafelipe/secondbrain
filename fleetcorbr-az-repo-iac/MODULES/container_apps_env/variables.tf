variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_app_env_name" {
  type = string
}

variable "log_analytics_workspace_id" {
  type    = string
  default = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}