# Subscription
blob_subscription_id = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"

# Subnets
subnets = [
  {
    name             = "stp-dig-snet-web-nprd"
    address_prefixes = ["10.17.204.0/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-app-nprd"
    address_prefixes = ["10.17.204.32/27"]
    delegation = [{
      name = "Microsoft.Web.serverFarms"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        name    = "Microsoft.Web/serverFarms"
      }]
    }]
  },
  {
    name             = "stp-dig-snet-ai-nprd"
    address_prefixes = ["10.17.204.64/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-db-nprd"
    address_prefixes = ["10.17.204.96/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-pep-nprd"
    address_prefixes = ["10.17.204.128/27"]
    delegation       = []
  }
]

# Subnets abastece
subnets_abastece = [
  {
    name             = "stp-dig-snet-abastece-web-nprd"
    address_prefixes = ["10.17.206.0/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-abastece-app-nprd"
    address_prefixes = ["10.17.206.32/27"]
    delegation = [{
      name = "Microsoft.Web.serverFarms"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        name    = "Microsoft.Web/serverFarms"
      }]
    }]
  },
  {
    name             = "stp-dig-snet-abastece-ai-nprd"
    address_prefixes = ["10.17.206.64/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-abastece-db-nprd"
    address_prefixes = ["10.17.206.96/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-abastece-pep-nprd"
    address_prefixes = ["10.17.206.128/27"]
    delegation       = []
  },
  {
    name             = "stp-dig-snet-abastece-app-2-nprd"
    address_prefixes = ["10.17.206.160/27"]
    delegation = [{
      name = "Microsoft.Web.serverFarms"
      service_delegation = [{
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        name    = "Microsoft.Web/serverFarms"
      }]
    }]
  }
]