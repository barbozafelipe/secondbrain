variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "free_tier_enabled" {
  type    = bool
  default = false
}
variable "offer_type" {
  type    = string
  default = "Standard"
}

variable "kind" {
  type    = string
  default = "GlobalDocumentDB"
}

variable "minimal_tls_version" {
  type    = string
  default = "Tls12"
}

variable "automatic_failover_enabled" {
  type    = bool
  default = true
}

variable "multiple_write_locations_enabled" {
  type    = bool
  default = false

}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "network_acl_bypass_for_azure_services" {
  type    = bool
  default = false
}

variable "virtual_network_rules" {
  type    = list(string)
  default = []
}

variable "ip_range_filter" {
  type    = list(string)
  default = null
}

variable "geo_location" {
  type = map(object({
    failover_priority = number
  }))

  default = {}
}

variable "capabilities" {
  type    = list(string)
  default = []
}

variable "consistency_level" {
  type = object({
    level                   = string
    max_interval_in_seconds = optional(number)
    max_staleness_prefix    = optional(number)
  })

  default = {
    level = "Session"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_private_endpoint" {
  type    = bool
  default = false
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

variable "subresource_names" {
  type    = list(string)
  default = ["sql"]
}