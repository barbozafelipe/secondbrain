resource "azurerm_kubernetes_cluster" "aks-az-dbt" {
  name                = "spe-spe-aks-nprd"
  dns_prefix          = "spe-spe-aks-nprd"
  resource_group_name = "spe-spe-aks-rg-nprd"
  location            = "brazilsouth"

  role_based_access_control_enabled = true

  default_node_pool {
    name                = "agentpool"
    vm_size             = "Standard_D2_v5"
    enable_auto_scaling = false
    node_count          = 2
    vnet_subnet_id      = data.terraform_remote_state.vnet.outputs.subnet_aks_id
    zones               = [1, 2, 3]
  }

  /*
  oms_agent {
    msi_auth_for_monitoring_enabled = true
    log_analytics_workspace_id      = "/subscriptions/667b9d61-92ad-4e25-bda6-6b41477e53ae/resourceGroups/plt-mon-rg/providers/Microsoft.OperationalInsights/workspaces/plt-mon-log"

  }
*/

  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
    }
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    AMBIENTE   = "NPRD",
    FRENTE     = "SPE",
    TECNOLOGIA = "AKS"


  }

}


resource "azurerm_role_assignment" "acr-aks" {
  scope                = data.terraform_remote_state.acr.outputs.spespeacrnprd
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-az-dbt.kubelet_identity.0.object_id
}


resource "azurerm_role_assignment" "aks-subnet" {
  scope                = data.terraform_remote_state.vnet.outputs.vnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-az-dbt.identity.0.principal_id
}

resource "azurerm_role_assignment" "app-gw-rg-principal" {
  scope                = "/subscriptions/936b1a91-dba6-4205-a0c5-c8e4fdf3465e/resourceGroups/spe-spe-aks-rg-nprd"
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks-az-dbt.identity.0.principal_id
}

resource "azurerm_public_ip" "res-11" {
  name                = "spe-spe-pip-aks-lb-nprd"
  location            = "brazilsouth"
  resource_group_name = "MC_spe-spe-aks-rg-nprd_spe-spe-aks-nprd_brazilsouth"
  allocation_method   = "Static"
  domain_name_label   = "spe-spe-pip-aks-lb-nprd"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
}


