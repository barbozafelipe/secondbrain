output "firewall_policy_id" {
  value = [azurerm_firewall_policy.res-8.id, azurerm_firewall_policy.res-9.id]
}