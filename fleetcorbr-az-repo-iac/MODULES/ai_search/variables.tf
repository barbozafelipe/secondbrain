variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku" {
  type    = string
  default = "basic"

  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3", "storageOptimizedL1", "storageOptimizedL2"], var.sku)
    error_message = "The SKU must be one of the allowed values: free, basic, standard, standard2, standard3, storageOptimizedL1, storageOptimizedL2."
  }
}

variable "network_rule_bypass_option" {
  type    = string
  default = "AzureServices"

  validation {
    condition     = contains(["None", "AzureServices"], var.network_rule_bypass_option)
    error_message = "The network_rule_bypass_option must be either 'None' or 'AzureServices'."
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