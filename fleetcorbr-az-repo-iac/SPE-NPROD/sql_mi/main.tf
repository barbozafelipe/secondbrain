data "terraform_remote_state" "vnet" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "SPE-NPROD/vnet/terraform.tfstate"
    subscription_id      = "${var.blob_subscription_id}"
  }
}

resource "azurerm_mssql_managed_instance" "mi-az-db-dbtrans" {
  name                = "spe-spe-sqlmi-nprd"
  resource_group_name = "spe-spe-db-rg-nprd"
  location            = "brazilsouth"

  license_type                   = "BasePrice"
  sku_name                       = "GP_Gen8IM"
  storage_size_in_gb             = 2560
  subnet_id                      = data.terraform_remote_state.vnet.outputs.subnet_db_id
  vcores                         = 8
  collation                      = "SQL_Latin1_General_CP1_CI_AS"
  timezone_id                    = "E. South America Standard Time"
  proxy_override                 = "Redirect"
  minimum_tls_version            = "1.2"
  maintenance_configuration_name = "SQL_BrazilSouth_MI_2"
  administrator_login            = "miadministrator"
  administrator_login_password   = "P@$$w0rd1234567!"
  identity {
    type = "SystemAssigned"
  }

  tags = {
    AMBIENTE   = "NPROD",
    FRENTE     = "SPE",
    TECNOLOGIA = "SQL Management Instance"


  }

}