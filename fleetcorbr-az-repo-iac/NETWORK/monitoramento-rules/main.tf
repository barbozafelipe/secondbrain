data "terraform_remote_state" "azure_firewall" {
  backend = "azurerm"

  config = {
    resource_group_name  = "plt-idt-rg"
    storage_account_name = "pltidtsttfstate"
    container_name       = "tfsstate"
    key                  = "NETWORK/azure_firewall/terraform.tfstate"
    subscription_id      = "8fc13250-5fbc-47a3-b05f-b0a0cc93b4b9"
  }
}

# Invoca modulo de criação de collections groups
module "rule_collection_group" {
  source = "../../MODULES/azure_firewall_rules"

  for_each = toset(data.terraform_remote_state.azure_firewall.outputs.firewall_policy_id)

  firewall_policy_id    = each.value
  rule_collection_group = var.rule_collection_group
}

