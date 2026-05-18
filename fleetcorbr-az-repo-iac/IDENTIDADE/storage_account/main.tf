resource "azurerm_storage_account" "res-11" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = "brazilsouth"
  name                     = "pltidtsttfstate"
  resource_group_name      = "plt-idt-rg"
}
resource "azurerm_storage_container" "res-13" {
  name                 = "tfsstate"
  storage_account_name = azurerm_storage_account.res-11.name
}

resource "azurerm_storage_account" "res-17" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = "brazilsouth"
  name                     = "stgazsharedtf"
  resource_group_name      = "plt-idt-rg"
  tags = {
    AMBIENTE = "SHARED"
  }
}
resource "azurerm_storage_container" "res-19" {
  name                 = "dbtstate"
  storage_account_name = azurerm_storage_account.res-17.name
}
resource "azurerm_storage_container" "res-20" {
  name                 = "shared"
  storage_account_name = azurerm_storage_account.res-17.name
}
resource "azurerm_storage_container" "res-21" {
  name                 = "tfsstate"
  storage_account_name = azurerm_storage_account.res-17.name
}
resource "azurerm_storage_container" "res-22" {
  name                 = "vbstate"
  storage_account_name = azurerm_storage_account.res-17.name
}
