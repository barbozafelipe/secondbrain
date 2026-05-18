# Firewall policy
variable "firewall_policy_id" {
  type = string
}

# Define a variavel rule collection group
variable "rule_collection_group" {
  type = map(object({
    priority = number

    application_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name = string
        protocols = optional(list(object({
          type = string
          port = number
        })))
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_fqdn_tags = optional(list(string))
        destination_urls      = optional(list(string))
        terminate_tls         = optional(bool)
        web_categories        = optional(list(string))
      }))
    }))

    network_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = optional(list(string))
        source_ip_groups      = optional(list(string))
        destination_addresses = optional(list(string))
        destination_fqdns     = optional(list(string))
        destination_ip_groups = optional(list(string))
        destination_ports     = list(string)
      }))
    }))

    nat_rule_collections = list(object({
      name     = string
      priority = number
      action   = string
      rules = list(object({
        name                = string
        protocols           = list(string)
        source_addresses    = optional(list(string))
        source_ip_groups    = optional(list(string))
        destination_address = optional(string)
        destination_ports   = optional(list(string))
        translated_address  = optional(string)
        translated_fqdn     = optional(string)
        translated_port     = string
      }))
    }))

  }))
}