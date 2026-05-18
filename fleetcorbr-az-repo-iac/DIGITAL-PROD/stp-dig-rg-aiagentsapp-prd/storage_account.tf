module "storage_account" {
  source = "../../MODULES/storage_account"

  storage_account_name          = "stpdigaiagentsprd"
  resource_group_name           = module.rg.resource_group_name
  location                      = module.rg.resource_group_location
  public_network_access_enabled = true
  network_rules = [{
    default_action             = "Allow"
    ip_rules                   = ["165.225.214.0/23", "147.161.128.0/23", "136.226.62.0/23", "136.226.138.0/23", "136.226.140.0/23"]
    virtual_network_subnet_ids = [data.azurerm_subnet.snet_app.id]
    bypass                     = ["AzureServices"]
  }]

  tags = {
    application = "aiagentsapp"
    environment = "prd"
    team        = "digital"
  }
}