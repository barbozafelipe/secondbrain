### Global Variables ###
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

### Managed Redis Variables ###
variable "redis_name" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "high_availability_enabled" {
  type    = bool
  default = false
}

variable "default_database_settings" {
  type = object({
    access_keys_authentication_enabled = bool
    client_protocol                    = string
    clustering_policy                  = string
    eviction_policy                    = string
    geo_replication_group_name         = string
  })
  default = {
    access_keys_authentication_enabled = true
    client_protocol                    = "Encrypted"
    clustering_policy                  = "OSSCluster"
    eviction_policy                    = "NoEviction"
    geo_replication_group_name         = null
  }
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = list(string)
  })

  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}
