resource "azurerm_firewall" "res-1" {
  firewall_policy_id  = azurerm_firewall_policy.res-8.id
  location            = "brazilsouth"
  name                = "plt-net-afw"
  resource_group_name = "plt-net-rg"
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  zones               = ["1", "2", "3"]

  ip_configuration {
    name                 = "AzureFirewallIpConfiguration0"
    public_ip_address_id = "/subscriptions/5a039316-bb6f-43ad-8351-fbcf83c40a48/resourceGroups/plt-net-rg/providers/Microsoft.Network/publicIPAddresses/plt-net-pip-afw"
    subnet_id            = data.terraform_remote_state.vnet.outputs.azure_firewall_subnet_id
  }

  depends_on = [
    azurerm_firewall_policy.res-9,
  ]
}

### Firewall Policies ###

# Policy basic
resource "azurerm_firewall_policy" "res-8" {
  location            = "brazilsouth"
  name                = "plt-net-1-afwp"
  resource_group_name = "plt-net-rg"

  sku = "Standard"

  dns {
    proxy_enabled = true
    #servers       = []
  }

}

# Policy Premium
resource "azurerm_firewall_policy" "res-9" {
  location            = "brazilsouth"
  name                = "plt-net-2-afwp"
  resource_group_name = "plt-net-rg"

  sku = "Premium"

  dns {
    proxy_enabled = true
    #servers       = []
  }

}

# Diagnostic settings
resource "azurerm_monitor_diagnostic_setting" "res-2" {
  log_analytics_destination_type = "Dedicated"
  log_analytics_workspace_id     = data.terraform_remote_state.log_workspace.outputs.log_analytics_workspace_id
  name                           = "plt-net-afw-logs"
  target_resource_id             = azurerm_firewall.res-1.id

  enabled_log {
    category_group = "allLogs"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}