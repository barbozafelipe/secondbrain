variable "name" {
  type = string
}

variable "custom_subdomain_name" {
  type    = string
  default = null
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "kind" {
  type    = string
  default = "OpenAI"
}

variable "sku" {
  type    = string
  default = "S0"

  validation {
    condition     = contains(["C2", "C3", "C4", "D3", "DC0", "E0", "F0", "F1", "P0", "P1", "P2", "S", "S0", "S1", "S2", "S3", "S4", "S5", "S6"], var.sku)
    error_message = "The SKU must be one of the allowed values: C2, C3, C4, D3, DC0, E0, F0, F1, P0, P1, P2, S, S0, S1, S2, S3, S4, S5, S6."
  }
}

variable "allowed_ips" {
  type    = list(string)
  default = []
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "outbound_network_access_restricted" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_private_endpoint" {
  type    = bool
  default = false
}

variable "endpoint_name" {
  type    = string
  default = ""
}

variable "endpoint_resource_group" {
  type    = string
  default = ""
}

variable "endpoint_subnet_id" {
  type    = string
  default = ""
}

variable "private_dns_zone_ids" {
  type    = list(string)
  default = []
}