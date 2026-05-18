resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.vnet_address_space

  tags = var.tags
}

# Cria subnets na Vnet dinamicamente
resource "azurerm_subnet" "snet" {
  for_each = { for i, k in var.subnets : k.name => k }

  name                 = each.key
  resource_group_name  = var.resource_group_name
  address_prefixes     = each.value.address_prefixes
  virtual_network_name = azurerm_virtual_network.vnet.name

  service_endpoints = lookup(each.value, "service_endpoints", [])

  dynamic "delegation" {
    for_each = each.value["delegation"] != null ? each.value["delegation"] : []

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
    azurerm_virtual_network.vnet,
  ]
}

# # Cria Route table e rotas
# resource "azurerm_route_table" "route-table" {
#   for_each = { for i, k in var.route_tables : k.name => k }

#   name                          = each.value.name
#   resource_group_name           = var.resource_group_name
#   location                      = var.location
#   disable_bgp_route_propagation = var.disable_bgp_route_propagation

#   dynamic "route" {
#     for_each = each.value.routes
#     content {
#       name                   = route.value.name
#       address_prefix         = route.value.address_prefix
#       next_hop_type          = route.value.next_hop_type
#       next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
#     }
#   }

#   tags = var.tags
# }

# # Cria associação da route table com as subnets
# resource "azurerm_subnet_route_table_association" "rt-association-0" {
#   for_each = { for i, k in var.subnets : k.name => k }

#   route_table_id = azurerm_route_table.route-table.id
#   subnet_id      = azurerm_subnet.snet[each.key].id

#   depends_on = [
#     azurerm_subnet.snet,
#     azurerm_route_table.route-table
#   ]
# }