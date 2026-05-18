variable "resource_group_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "virtual_network_id" {
  type = list(string)
}

variable "registration_enabled" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}