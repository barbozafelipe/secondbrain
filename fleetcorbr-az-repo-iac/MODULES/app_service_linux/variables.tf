variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

# App Service Plan Variables
variable "service_plan_name" {
  type    = string
  default = null
}

variable "service_plan_id" {
  type    = string
  default = null
}

variable "os_type" {
  type    = string
  default = "Linux"
}

variable "sku_name" {
  type    = string
  default = "B1"
}

# Web App Variables

variable "app_name" {
  type = string
}

variable "builtin_logging_enabled" {
  type    = bool
  default = false
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

# variable "storage_account_name" {
#   type = string
# }

# variable "storage_account_access_key" {
#   type = string
# }

variable "app_settings" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "site_config" {
  type        = any
  description = "Bloco de configurações da function"
}

variable "create_app_service_plan" {
  type    = bool
  default = true
}