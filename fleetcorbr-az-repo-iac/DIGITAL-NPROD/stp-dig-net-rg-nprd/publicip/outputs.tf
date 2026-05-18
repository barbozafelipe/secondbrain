output "apim_public_ip_id" {
  value = azurerm_public_ip.res-11.id
}

output "apim_abastece_ip_id" {
  value = azurerm_public_ip.pip-02.id
}

output "apim_chatbot_ip_id" {
  value = azurerm_public_ip.pip-03.id
}