
# Cria Route table e rotas
resource "azurerm_route_table" "route-table" {
  name                          = var.route_table_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = var.disable_bgp_route_propagation

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = var.tags
}

# Cria associação da route table com as subnets
resource "azurerm_subnet_route_table_association" "rt-association" {
  count = length(var.subnet_id)

  route_table_id = azurerm_route_table.route-table.id
  subnet_id      = var.subnet_id[count.index]

  depends_on = [
    azurerm_route_table.route-table
  ]
}