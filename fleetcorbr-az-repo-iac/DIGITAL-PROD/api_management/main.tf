resource "azurerm_api_management" "apim-01" {
  name                = "stp-dig-apim-chatbot-prd"
  resource_group_name = "stp-dig-rg-chatbot-prd"
  location            = "brazilsouth"

  sku_name             = "Developer_1"
  publisher_email      = "stp@stp"
  publisher_name       = "STP"
  public_ip_address_id = data.terraform_remote_state.publicip.outputs.apim_chatbot_public_ip_id
  virtual_network_type = "External"

  virtual_network_configuration {
    subnet_id = data.terraform_remote_state.vnet.outputs.subnet_ids[4]
  }

  depends_on = []
}