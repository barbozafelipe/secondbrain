variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "sku" {
  type = string
}

variable "publisher_name" {
  type    = string
  default = "Sem Parar"
}

variable "publisher_email" {
  type    = string
  default = "stp@stp"
}

variable "virtual_network_type" {
  type    = string
  default = "None"
}

variable "public_network_access_enabled" {
  type    = bool
  default = true
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "identity" {
  type    = string
  default = "SystemAssigned"
}