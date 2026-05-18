module "storage_account_copilot" {
  source = "../../MODULES/storage_account"

  resource_group_name           = "stp-dig-rg-copilot-nprd"
  location                      = "brazilsouth"
  storage_account_name          = "stpdigcopilotstnprd"
  public_network_access_enabled = true

  network_rules = [{
    default_action             = "Deny"
    ip_rules                   = ["165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23", "136.226.138.0/23", "136.226.140.0/23"]
    virtual_network_subnet_ids = ["/subscriptions/36df8ac5-dab6-4301-9cbf-97aa398ba021/resourceGroups/stp-dig-net-rg-nprd/providers/Microsoft.Network/virtualNetworks/stp-dig-vnet-nprd/subnets/stp-dig-snet-app-nprd"]
    }
  ]

  tags = {
    Projeto = "Copiloto Atendimento"
  }
}