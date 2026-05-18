#
### Virtual networks
#
resource "azurerm_virtual_network" "vnet-0" {
  name                = "stp-dig-vnet-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "brazilsouth"
  address_space       = ["10.17.204.0/24"]

  tags = {
    AMBIENTE   = "DIGITAL-NPROD"
    TECNOLOGIA = "VNET"
  }
}

resource "azurerm_virtual_network" "vnet-1" {
  name                = "stp-dig-vnet-abastece-nprd"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = "brazilsouth"
  address_space       = ["10.17.206.0/24"]

  tags = {
    AMBIENTE   = "DIGITAL-NPROD"
    FRENTE     = "ABASTECE"
    TECNOLOGIA = "VNET"
  }
}

#
### Subnets
#
resource "azurerm_subnet" "snet" {
  for_each = { for i, k in var.subnets : k.name => k }

  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = each.value.address_prefixes
  virtual_network_name = azurerm_virtual_network.vnet-0.name

  dynamic "delegation" {
    for_each = each.value["delegation"]

    content {
      name = delegation.value.name

      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation

        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }

  }

  depends_on = [
    azurerm_virtual_network.vnet-0,
  ]
}

resource "azurerm_subnet" "snet-1" {
  for_each = { for i, k in var.subnets_abastece : k.name => k }

  name                 = each.key
  resource_group_name  = data.azurerm_resource_group.rg.name
  address_prefixes     = each.value.address_prefixes
  virtual_network_name = azurerm_virtual_network.vnet-1.name

  dynamic "delegation" {
    for_each = each.value["delegation"]

    content {
      name = delegation.value.name

      dynamic "service_delegation" {
        for_each = delegation.value.service_delegation

        content {
          name    = service_delegation.value.name
          actions = service_delegation.value.actions
        }
      }
    }

  }

  depends_on = [
    azurerm_virtual_network.vnet-1,
  ]
}

#
### Route table association
#
resource "azurerm_subnet_route_table_association" "rt-association-0" {
  for_each = { for i, k in var.subnets : k.name => k }

  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_id
  subnet_id      = azurerm_subnet.snet[each.key].id

  depends_on = [
    azurerm_subnet.snet
  ]
}

resource "azurerm_subnet_route_table_association" "rt-association-1" {
  for_each = { for i, k in var.subnets_abastece : k.name => k }

  route_table_id = data.terraform_remote_state.route_tables.outputs.route_table_abastece
  subnet_id      = azurerm_subnet.snet-1[each.key].id

  depends_on = [
    azurerm_subnet.snet-1
  ]
}

#
# NSG Association
#
resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.snet["stp-dig-snet-web-nprd"].id
  network_security_group_id = data.terraform_remote_state.nsg.outputs.network_security_group_id

  depends_on = [
    azurerm_subnet.snet,
  ]
}

#
### Vnet Peerings
#
resource "azurerm_virtual_network_peering" "peer-0" {
  allow_forwarded_traffic   = true
  name                      = "stp-dig-peer-nprd"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = data.azurerm_resource_group.rg.name
  use_remote_gateways       = true
  virtual_network_name      = azurerm_virtual_network.vnet-0.name
  depends_on = [
    azurerm_virtual_network.vnet-0,
  ]
}

resource "azurerm_virtual_network_peering" "peer-1" {
  allow_forwarded_traffic   = true
  name                      = "stp-dig-peer-abastece-nprd"
  remote_virtual_network_id = data.terraform_remote_state.vnet_hub.outputs.vnet_id
  resource_group_name       = data.azurerm_resource_group.rg.name
  use_remote_gateways       = true
  virtual_network_name      = azurerm_virtual_network.vnet-1.name
  depends_on = [
    azurerm_virtual_network.vnet-1,
  ]
}