rule_collection_group = {
  CPP-PROD = {
    priority = 220,
    application_rule_collections = [
      {
        name     = "acesso internet-SIG",
        action   = "Allow",
        priority = 300,
        rules = [
          {
            name = "acesso internet SIG-CHG0071892"
            protocols = [
              {
                port = 443
                type = "Https"
              }
            ]
            source_addresses      = ["10.17.130.0/27"]
            source_ip_groups      = []
            destination_addresses = []
            destination_fqdns     = ["beneficios.sempararempresas.com.br", "valetransporte.caixaprepagos.com.br", "pas.windows.net", "www.msftconnecttest.com", "enterpriseregistration.windows.net", "stpcppstprd.blob.core.windows.net"]
          },
        ]
      }
    ],
    network_rule_collections = [
      {
        name     = "plt-net-afwp-virtual-desktop",
        action   = "Allow",
        priority = 200,
        rules = [
          {
            name                  = "acesso virtual desktop ao banco oracle no oci",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.130.0/27"],
            source_ip_groups      = [],
            destination_addresses = [],
            destination_ip_groups = ["/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/ipGroups/plt-net-ipg-oci-exadata"],
            destination_ports     = ["1500-2000"],
            destination_fqdns     = []
          },
          {
            name             = "acesso virtual desktop agent-1-CHG0071892",
            protocols        = ["TCP"],
            source_addresses = ["10.17.130.0/27"],
            source_ip_groups = [],
            destination_addresses = ["WindowsVirtualDesktop",
              "AzureFrontDoor.Frontend",
              "AzureMonitor",
            ]
            destination_ip_groups = [],
            destination_ports     = ["443"]
            destination_fqdns     = []
          },
          {
            name                  = "acesso virtual desktop agent-2-CHG0071892",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.130.0/27"],
            source_ip_groups      = [],
            destination_addresses = []
            destination_ip_groups = [],
            destination_ports     = ["443", "80"]
            destination_fqdns = ["login.microsoftonline.com",
              "mrsglobalsteus2prod.blob.core.windows.net",
              "wvdportalstorageblob.blob.core.windows.net",
              "oneocsp.microsoft.com",
              "www.microsoft.com"
            ]
          },
          {
            name                  = "acesso virtual desktop agent-3-CHG0071892",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.130.0/27"],
            source_ip_groups      = [],
            destination_addresses = ["20.118.99.224", "40.83.235.53", "23.102.135.246"]
            destination_ip_groups = [],
            destination_ports     = ["1688"]
            destination_fqdns     = []
          },
          {
            name                  = "acesso virtual desktop ao oke oci-CHG0071892",
            protocols             = ["TCP"],
            source_addresses      = ["10.17.130.0/27"],
            source_ip_groups      = [],
            destination_addresses = ["10.17.64.155"]
            destination_ip_groups = [],
            destination_ports     = ["443"]
            destination_fqdns     = []
          },
          {
            name                  = "Acesso File Share e Deploy SIG - CHG0073407",
            protocols             = ["TCP"],
            source_addresses      = ["10.0.134.70"],
            source_ip_groups      = [],
            destination_addresses = ["10.17.130.6"]
            destination_ip_groups = [],
            destination_ports     = ["443", "445"]
            destination_fqdns     = []
          }
        ]
      },
    ],
    nat_rule_collections = [

    ]
  }
}