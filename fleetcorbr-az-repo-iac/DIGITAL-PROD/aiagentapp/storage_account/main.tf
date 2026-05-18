locals {
  resource_group_name = "stp-dig-rg-aiagentsapp-prd"
  location            = "brazilsouth"
}

module "storage_account" {
  source = "../../../MODULES/storage_account"

  storage_account_name          = "stpdigaiagentsprd"
  resource_group_name           = local.resource_group_name
  location                      = local.location
  public_network_access_enabled = true
  network_rules = [{
    default_action             = "Deny"
    ip_rules                   = ["165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23", "136.226.138.0/23", "136.226.140.0/23"]
    virtual_network_subnet_ids = ["/subscriptions/b1ba0975-b0e9-4aa4-838a-cdb4b0c9e058/resourceGroups/stp-dig-rg-net-prd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-prd/subnets/stp-dig-snet-app-prd"]
    bypass                     = ["AzureServices"]
  }]

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }
}