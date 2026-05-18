# Network rules Collections ###
network_rule_collections = [
  {
    name     = "plt-net-afwp-infraestructure",
    action   = "Allow",
    priority = 200,
    rules = [
      {
        name                  = "infra team - acesso remoto para gerencia",
        protocols             = ["TCP", "ICMP"],
        source_addresses      = [],
        source_ip_groups      = ["/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/ipGroups/plt-net-ipg-infra-team"],
        destination_addresses = ["10.17.184.0/24"],
        destination_ip_groups = [],
        destination_ports     = ["3389"]
      },
      {
        name                  = "teste-icmp",
        protocols             = ["Any"],
        source_addresses      = ["10.17.184.0/24"],
        source_ip_groups      = [],
        destination_addresses = ["10.0.128.0/17"],
        destination_ip_groups = [],
        destination_ports     = ["*"]
      },
      {
        name                  = "test",
        protocols             = ["Any"],
        source_ip_groups      = [],
        source_addresses      = ["10.0.128.0/17"],
        destination_addresses = ["10.17.184.0/24"],
        destination_ip_groups = [],
        destination_ports     = ["*"]
      },
      {
        name                  = "DC",
        protocols             = ["Any"],
        source_ip_groups      = [],
        source_addresses      = ["192.168.100.166/32"],
        destination_addresses = ["10.17.184.0/24"],
        destination_ip_groups = [],
        destination_ports     = ["*"]
      }
    ]
  }
]