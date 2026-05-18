variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "appi_name" {
  type = string
}

variable "application_type" {
  type    = string
  default = "web"

  validation {
    condition     = can(regex("^(ios|java|MobileCenter|Node.JS|other|phone|store|web)$", var.application_type))
    error_message = "Invalid application type, allowed values: ios|java|MobileCenter|Node.JS|other|phone|store|web. Default 'web'"
  }
}

variable "sampling_percentage" {
  type    = number
  default = 100
}

variable "retention_in_days" {
  type    = number
  default = 90
}

variable "workspace_id" {
  type    = string
  default = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourcegroups/plt-mon-rg/providers/microsoft.operationalinsights/workspaces/plt-mon-log"
}

variable "tags" {
  type    = map(string)
  default = {}
}