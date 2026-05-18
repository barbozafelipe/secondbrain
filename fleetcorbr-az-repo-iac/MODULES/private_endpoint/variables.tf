variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "brazilsouth"
}

variable "private_endpoint_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "is_manual_connection" {
  type    = bool
  default = false
}

variable "resource_name" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "subresource_names" {
  type    = list(string)
  default = []
}

variable "private_dns_zone_group_name" {
  type    = string
  default = "default"
}

variable "private_dns_zone_id" {
  type = list(string)
}