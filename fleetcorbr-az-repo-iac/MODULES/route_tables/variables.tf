variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "disable_bgp_route_propagation" {
  type    = bool
  default = false
}

variable "route_table_name" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}