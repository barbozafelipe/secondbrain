output "private_dns_zone_ids" {
  value = [for i in azurerm_private_dns_zone.priv-dns-0 : i.id]
}