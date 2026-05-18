variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "container_app_env_id" {
  type = string
}

variable "container_app_name" {
  type = string
}

variable "revision_mode" {
  type    = string
  default = "Single"
}

variable "template" {
  type = object({
    name         = string
    image        = string
    command      = optional(list(string), [])
    cpu          = number
    memory       = string
    min_replicas = number
    max_replicas = number

  })
}

variable "environment" {
  type = map(object({
    value       = optional(string)
    secret_name = optional(string)
  }))
  default = {}
}

variable "identity_type" {
  type    = string
  default = "SystemAssigned"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_ingress" {
  type    = bool
  default = false
}

variable "ingress" {
  type = object({
    allow_insecure_connections = optional(bool, false)
    client_certificate_mode    = optional(string, "ignore")
    external_enabled           = optional(bool, false)
    target_port                = number
    transport                  = optional(string, "auto")
  })
  default = {
    allow_insecure_connections = false
    client_certificate_mode    = "ignore"
    external_enabled           = false
    target_port                = 443
    transport                  = "auto"
  }
}

variable "registry_identity" {
  type    = string
  default = "system-environment"
}
variable "registry_endpoint" {
  type    = string
  default = ""
}