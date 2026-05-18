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

resource "azurerm_lb" "res-0" {
  name                = "spe-spe-lbi-01-nprd"
  resource_group_name = "spe-spe-app-rg-nprd"
  location            = "brazilsouth"
  sku                 = "Standard"
  frontend_ip_configuration {
    name                          = "spe-spe-lbi-01-ip-nprd"
    subnet_id                     = data.terraform_remote_state.vnet.outputs.subnet_app_id
    private_ip_address_allocation = "static"
    private_ip_address            = "10.17.200.134"
  }
}

resource "azurerm_lb_backend_address_pool" "res-1" {
  loadbalancer_id = azurerm_lb.res-0.id
  name            = "Rodocred-BackEndAddressPool"
}

/*
resource "azurerm_lb_probe" "loadbalancer_probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.sql-loadbalancer.id}"
  name                = "SQLAlwaysOnEndPointProbe"
  protocol            = "tcp"
  port                = 59999
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "SQLAlwaysOnEndPointListener" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.sql-loadbalancer.id}"
  name                           = "SQLAlwaysOnEndPointListener"
  protocol                       = "Tcp"
  frontend_port                  = 1433
  backend_port                   = 1433
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.loadbalancer_backend.id}"
  probe_id                       = "${azurerm_lb_probe.loadbalancer_probe.id}"
}
*/