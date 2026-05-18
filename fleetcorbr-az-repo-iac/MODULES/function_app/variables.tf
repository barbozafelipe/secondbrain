variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

# App Service Plan Variables
variable "service_plan_name" {
  type = string
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "sku_name" {
  type    = string
  default = "B1"
}

# Function App Variables

variable "function_name" {
  type = string
}

variable "builtin_logging_enabled" {
  type    = bool
  default = true
}

variable "client_certificate_enabled" {
  type    = bool
  default = false
}

variable "client_certificate_mode" {
  type    = string
  default = "Optional"
}

variable "https_only" {
  type    = bool
  default = true
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "virtual_network_subnet_id" {
  type    = string
  default = null
}

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "site_config" {
  type        = any
  description = "Bloco de configurações da function"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Storage account variables
variable "create_storage_account" {
  type    = bool
  default = true
}

variable "storage_account_name" {
  type    = string
  default = ""
}

variable "storage_account_access_key" {
  type    = string
  default = ""
}

variable "storage_public_access_enabled" {
  type    = bool
  default = true
}

variable "network_rules" {
  type = list(object({
    default_action             = string
    ip_rules                   = optional(list(string))
    virtual_network_subnet_ids = optional(list(string))
  }))

  default = [{
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }]
}

# Application Insight variables
variable "create_application_insights" {
  type    = bool
  default = true
}

variable "application_insights_name" {
  type    = string
  default = ""
}