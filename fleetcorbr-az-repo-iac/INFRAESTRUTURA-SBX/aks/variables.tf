variable "resource_group_name_prefix" {
  default     = "RG"
  description = "Prefixo padrao para criação do Resource Group"
}

variable "resource_group_location" {
  default     = "brazilsouth"
  description = "Local padrao para criacao dos recursos."
}

variable "username" {
  type        = string
  description = "Usuario Administrador do Cluster"
  default     = "azureadmin"
}