variable "blob_subscription_id" {
}

# Subnets
variable "subnets" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
}

variable "subnets_abastece" {
  type = list(object({
    name             = string
    address_prefixes = list(string)
    delegation = list(object({
      name = string
      service_delegation = list(object({
        name    = string
        actions = list(string)
      }))
    }))
  }))
}