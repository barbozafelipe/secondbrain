variable "intrusion_detection" {
  type = list(object({
    mode = string

    signature_override = list(object({
      id    = string
      state = string
    }))

    traffic_bypass = list(object({
      name                  = string
      protocols             = string
      description           = string
      destination_addresses = list(string)
      destination_ip_groups = list(string)
      destination_ports     = list(string)
      source_addresses      = list(string)
      source_ip_groups      = list(string)
    }))
  }))

  default = [{
    mode = "Off"
    signature_override = [{
      id    = ""
      state = ""
    }]
    traffic_bypass = [{
      name                  = ""
      protocols             = ""
      description           = ""
      destination_addresses = []
      destination_ip_groups = []
      destination_ports     = []
      source_addresses      = []
      source_ip_groups      = []
    }]
  }]
}

