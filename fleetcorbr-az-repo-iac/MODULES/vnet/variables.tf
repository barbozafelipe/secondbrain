variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "subnets" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
    delegation = optional(list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    })))
    service_endpoints = optional(list(string))
  }))

  default = []
}

# Route Table
# variable "route_table_name" {
#   type = string
# }

# variable "disable_bgp_route_propagation" {
#   type    = bool
#   default = false
# }

# variable "route_tables" {
#   type = list(object({
#     name = string
#     routes = list(object({
#       name                   = string
#       address_prefix         = string
#       next_hop_type          = string
#       next_hop_in_ip_address = optional(string)
#     }))
#   }))
# }