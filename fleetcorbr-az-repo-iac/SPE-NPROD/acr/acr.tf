resource "azurerm_container_registry" "res-1" {
  name                          = "spespeacrnprd"
  resource_group_name           = "spe-spe-aks-rg-nprd"
  location                      = "brazilsouth"
  sku                           = "Standard"
  public_network_access_enabled = true
  admin_enabled                 = true

  tags = {
    AMBIENTE   = "NPRD",
    FRENTE     = "SPE",
    TECNOLOGIA = "Registry Privado"


  }


}