rule_collection_group = {
  GERENCIA = {
    priority = 100,
    application_rule_collections = [

    ],
    network_rule_collections = [
      {
        name     = "plt-net-afwp-splunk",
        action   = "Allow",
        priority = 200,
        rules = [
          {
            name                  = "coleta de logs para o splunk",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.128.0/17"],
            source_ip_groups      = [],
            destination_addresses = [],
            destination_ip_groups = ["/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/ipGroups/plt-net-ipg-splunk"],
            destination_ports     = ["8099", "8443", "9997"]
            destination_fqdns     = []
          }
        ]
      }

    ],
    nat_rule_collections = [

    ]
  }
}