resource "azurerm_api_management" "apim" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  sku_name                      = var.sku
  publisher_email               = var.publisher_email
  publisher_name                = var.publisher_name
  public_network_access_enabled = var.public_network_access_enabled
  virtual_network_type          = var.virtual_network_type


  dynamic "virtual_network_configuration" {
    for_each = var.virtual_network_type == "External" || var.virtual_network_type == "Internal" ? [1] : []
    content {
      subnet_id = var.subnet_id
    }

  }

  identity {
    type = var.identity
  }

}