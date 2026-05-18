module "apim" {
  source = "../../MODULES/api_management"

  name                 = "stp-dig-apim-aihub-nprd"
  resource_group_name  = module.rg.resource_group_name
  location             = module.rg.resource_group_location
  sku                  = "Developer_1"
  virtual_network_type = "External"
  subnet_id            = data.azurerm_subnet.snet_web.id

  tags = {
    Projeto = "AIHUB"
  }

}