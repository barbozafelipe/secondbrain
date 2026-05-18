rule_collection_group = {
  SPE-NPROD = {
    priority = 250,
    application_rule_collections = [

    ],
    network_rule_collections = [
      {
        name     = "plt-net-afwp-spe-nprod",
        action   = "Allow",
        priority = 200,
        rules = [
          {
            name                  = "Acesso OCP NPROD e URLs NPROD - CHG0073389",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.200.0/26", "10.17.200.128/26"],
            source_ip_groups      = [],
            destination_addresses = ["10.0.192.100", "10.0.192.185", "10.0.192.186", "172.17.0.45", "10.0.192.116"],
            destination_ip_groups = [],
            destination_ports     = ["443"],
            destination_fqdns     = []
          },
          {
            name                  = "Acesso SMTP Relay - CHG0073389",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.200.0/26", "10.17.200.128/26"],
            source_ip_groups      = [],
            destination_addresses = ["10.0.169.22"],
            destination_ip_groups = [],
            destination_ports     = ["25"],
            destination_fqdns     = []
          },
          {
            name                  = "Acesso LDAP - CHG0073389",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.200.0/26", "10.17.200.128/26"],
            source_ip_groups      = [],
            destination_addresses = ["10.0.180.25"],
            destination_ip_groups = [],
            destination_ports     = ["389"],
            destination_fqdns     = []
          },
          {
            name                  = "Acesso Microsiga Homolog - CHG0073389",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.200.0/26", "10.17.200.128/26"],
            source_ip_groups      = [],
            destination_addresses = ["10.0.201.75"],
            destination_ip_groups = [],
            destination_ports     = ["89"],
            destination_fqdns     = []
          }
        ]
      },
    ],
    nat_rule_collections = [

    ]
  }
}