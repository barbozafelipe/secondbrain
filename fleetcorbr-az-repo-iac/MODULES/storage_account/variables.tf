variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "account_kind" {
  type    = string
  default = "StorageV2"
  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "BlockBlobStorage", "FileStorage"], var.account_kind)
    error_message = "Invalid account kind, allowed values: Storage, StorageV2, BlobStorage, BlockBlobStorage, FileStorage"
  }
}

variable "account_replication_type" {
  type    = string
  default = "LRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Invalid account replication type, allowed values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS"
  }
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "cross_tenant_replication_enabled" {
  type    = bool
  default = false
}

variable "default_to_oauth_authentication" {
  type    = bool
  default = true
}

variable "public_network_access_enabled" {
  type    = bool
  default = false
}

variable "network_rules" {
  type = list(object({
    default_action             = string
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
    bypass                     = optional(list(string), ["AzureServices"])
  }))

  default = [{
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
    bypass                     = []
  }]
}

variable "tags" {
  type    = map(string)
  default = {}
}